use crate::air::cairo_air::air::{CairoAIR, PublicInputs};
use crate::air::context::ProofOptions;
use crate::air::trace::TraceTable;
use crate::cairo_vm::cairo_mem::CairoMemory;
use crate::cairo_vm::cairo_trace::RegisterStates;
use crate::cairo_vm::execution_trace::build_main_trace;

use super::cairo_layout::CairoLayout;
use super::vec_writer::VecWriter;
use cairo_vm::cairo_run::{self, EncodeTraceError};
use cairo_vm::hint_processor::builtin_hint_processor::builtin_hint_processor_definition::BuiltinHintProcessor;
use cairo_vm::vm::errors::cairo_run_errors::CairoRunError;
use cairo_vm::vm::errors::trace_errors::TraceError;
use cairo_vm::vm::errors::vm_errors::VirtualMachineError;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {
    #[error("Failed to interact with the file system")]
    IO(#[from] std::io::Error),
    #[error("The cairo program execution failed")]
    Runner(#[from] CairoRunError),
    #[error(transparent)]
    EncodeTrace(#[from] EncodeTraceError),
    #[error(transparent)]
    VirtualMachine(#[from] VirtualMachineError),
    #[error(transparent)]
    Trace(#[from] TraceError),
}

/// Runs a cairo program in JSON format and returns trace, memory and program length.
/// Uses [cairo-rs](https://github.com/lambdaclass/cairo-rs/) project to run the program.
///
///  # Params
///
/// `entrypoint_function` - the name of the entrypoint function tu run. If `None` is provided, the default value is `main`.
/// `layout` - type of layout of Cairo.
/// `filename` - path to the input file.
/// `trace_path` - path where to store the generated trace file.
/// `memory_path` - path where to store the generated memory file.
///
/// # Returns
///
/// Ok(()) in case of succes
/// `Error` indicating the type of error.
pub fn run_program(
    entrypoint_function: Option<&str>,
    layout: CairoLayout,
    filename: &str,
) -> Result<(RegisterStates, CairoMemory, usize), Error> {
    // default value for entrypoint is "main"
    let entrypoint = entrypoint_function.unwrap_or("main");

    let trace_enabled = true;
    let mut hint_executor = BuiltinHintProcessor::new_empty();
    let cairo_run_config = cairo_run::CairoRunConfig {
        entrypoint,
        trace_enabled,
        relocate_mem: true,
        layout: layout.as_str(),
        proof_mode: false,
        secure_run: None,
    };

    let program_content = std::fs::read(filename).map_err(Error::IO)?;

    let (cairo_runner, vm) =
        match cairo_run::cairo_run(&program_content, &cairo_run_config, &mut hint_executor) {
            Ok(runner) => runner,
            Err(error) => {
                eprintln!("{error}");
                return Err(Error::Runner(error));
            }
        };

    let relocated_trace = vm.get_relocated_trace()?;

    let mut trace_vec = Vec::<u8>::new();
    let mut trace_writer = VecWriter::new(&mut trace_vec);
    cairo_run::write_encoded_trace(relocated_trace, &mut trace_writer)?;

    let mut memory_vec = Vec::<u8>::new();
    let mut memory_writer = VecWriter::new(&mut memory_vec);
    cairo_run::write_encoded_memory(&cairo_runner.relocated_memory, &mut memory_writer)?;

    trace_writer.flush()?;
    memory_writer.flush()?;

    //TO DO: Better error handling
    let cairo_mem = CairoMemory::from_bytes_le(&memory_vec).unwrap();
    let cairo_trace = RegisterStates::from_bytes_le(&trace_vec).unwrap();

    let data_len = cairo_runner.get_program().data_len();

    Ok((cairo_trace, cairo_mem, data_len))
}

pub fn generate_prover_args(
    file_path: &str,
) -> (TraceTable<Stark252PrimeField>, CairoAIR, PublicInputs) {
    let (register_states, memory, program_size) =
        run_program(None, CairoLayout::Plain, file_path).unwrap();

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
    };

    let mut pub_inputs = PublicInputs::from_regs_and_mem(&register_states, &memory, program_size);

    let main_trace = build_main_trace(&register_states, &memory, &mut pub_inputs);

    let cairo_air = CairoAIR::new(proof_options, main_trace.n_rows(), register_states.steps());

    (main_trace, cairo_air, pub_inputs)
}

pub fn program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/src/cairo_vm/test_data/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

#[cfg(test)]
mod tests {
    use crate::air::trace::TraceTable;
    use crate::cairo_run::cairo_layout::CairoLayout;
    use crate::cairo_vm::cairo_mem::CairoMemory;
    use crate::cairo_vm::cairo_trace::RegisterStates;
    use crate::cairo_vm::execution_trace::build_cairo_execution_trace;
    use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::MontgomeryConfigStark252PrimeField;
    use lambdaworks_math::field::{
        element::FieldElement, fields::montgomery_backed_prime_fields::U256PrimeField,
    };

    pub type Stark252PrimeField = U256PrimeField<MontgomeryConfigStark252PrimeField>;
    type FE = FieldElement<Stark252PrimeField>;

    #[test]
    fn test_parse_cairo_file() {
        let base_dir = env!("CARGO_MANIFEST_DIR");

        let json_filename = base_dir.to_owned() + "/src/cairo_run/program.json";
        let dir_trace = base_dir.to_owned() + "/src/cairo_run/program.trace";
        let dir_memory = base_dir.to_owned() + "/src/cairo_run/program.memory";

        println!("{}", json_filename);

        super::run_program(None, CairoLayout::AllCairo, &json_filename).unwrap();

        // read trace from file
        let raw_trace = RegisterStates::from_file(&dir_trace).unwrap();
        // read memory from file
        let memory = CairoMemory::from_file(&dir_memory).unwrap();

        let execution_trace = build_cairo_execution_trace(&raw_trace, &memory);

        // This trace is obtained from Giza when running the prover for the mentioned program.
        let expected_trace = TraceTable::new_from_cols(&vec![
            // col 0
            vec![FE::zero(), FE::zero(), FE::one()],
            // col 1
            vec![FE::one(), FE::one(), FE::one()],
            // col 2
            vec![FE::one(), FE::one(), FE::zero()],
            // col 3
            vec![FE::zero(), FE::zero(), FE::one()],
            // col 4
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 5
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 6
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 7
            vec![FE::zero(), FE::zero(), FE::one()],
            // col 8
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 9
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 10
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 11
            vec![FE::one(), FE::zero(), FE::zero()],
            // col 12
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 13
            vec![FE::zero(), FE::zero(), FE::one()],
            // col 14
            vec![FE::one(), FE::one(), FE::zero()],
            // col 15
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 16
            vec![FE::from(3), FE::from(3), FE::from(9)],
            // col 17
            vec![FE::from(8), FE::from(9), FE::from(9)],
            // col 18
            vec![FE::from(8), FE::from(8), FE::from(8)],
            // col 19
            vec![FE::from(1), FE::from(3), FE::from(5)],
            // col 20
            vec![FE::from(8), FE::from(8), FE::from(6)],
            // col 21
            vec![FE::from(7), FE::from(7), FE::from(7)],
            // col 22
            vec![FE::from(2), FE::from(4), FE::from(7)],
            // col 23
            vec![
                FE::from(0x480680017fff8000),
                FE::from(0x400680017fff7fff),
                FE::from(0x208b7fff7fff7ffe),
            ],
            // col 24
            vec![FE::from(3), FE::from(3), FE::from(9)],
            // col 25
            vec![FE::from(9), FE::from(9), FE::from(9)],
            // col 26
            vec![FE::from(3), FE::from(3), FE::from(9)],
            // col 27
            vec![FE::from(0x8000), FE::from(0x7fff), FE::from(0x7ffe)],
            // col 28
            vec![FE::from(0x7fff), FE::from(0x7fff), FE::from(0x7fff)],
            // col 29
            vec![FE::from(0x8001), FE::from(0x8001), FE::from(0x7fff)],
            // col 30
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 31
            vec![FE::zero(), FE::zero(), FE::zero()],
            // col 32
            vec![FE::from(0x1b), FE::from(0x1b), FE::from(0x51)],
            // col 33 - Selector column
            vec![FE::one(), FE::one(), FE::zero()],
        ]);

        assert_eq!(execution_trace.cols(), expected_trace.cols());
    }
}
