use std::ops::Range;

use super::vec_writer::VecWriter;
use crate::cairo::air::{CairoAIR, PublicInputs};
use crate::cairo::cairo_layout::CairoLayout;
use crate::cairo::cairo_mem::CairoMemory;
use crate::cairo::execution_trace::build_main_trace;
use crate::cairo::register_states::RegisterStates;
use crate::starks::context::ProofOptions;
use crate::starks::trace::TraceTable;
use cairo_lang_starknet::casm_contract_class::CasmContractClass;
use cairo_vm::cairo_run::{self, EncodeTraceError};
use cairo_vm::felt::Felt252;
use cairo_vm::hint_processor::builtin_hint_processor::builtin_hint_processor_definition::BuiltinHintProcessor;
use cairo_vm::hint_processor::hint_processor_definition::HintProcessor;
use cairo_vm::serde::deserialize_program::BuiltinName;
use cairo_vm::types::program::Program;
use cairo_vm::types::relocatable::MaybeRelocatable;
use cairo_vm::vm::errors::cairo_run_errors::CairoRunError;
use cairo_vm::vm::errors::trace_errors::TraceError;
use cairo_vm::vm::errors::vm_errors::VirtualMachineError;
use cairo_vm::vm::runners::cairo_runner::{CairoArg, CairoRunner};
use cairo_vm::vm::vm_core::VirtualMachine;
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
/// Ok() in case of succes, with the following values:
/// - register_states
/// - cairo_mem
/// - data_len
/// - range_check: an Option<(usize, usize)> containing the start and end of range check.
/// `Error` indicating the type of error.
#[allow(clippy::type_complexity)]
pub fn run_program(
    entrypoint_function: Option<&str>,
    layout: CairoLayout,
    filename: &str,
) -> Result<(RegisterStates, CairoMemory, usize, Option<Range<u64>>), Error> {
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
    let register_states = RegisterStates::from_bytes_le(&trace_vec).unwrap();

    let data_len = cairo_runner.get_program().data_len();

    // get range start and end
    let range_check = vm
        .get_range_check_builtin()
        .map(|builtin| {
            let (idx, stop_offset) = builtin.get_memory_segment_addresses();
            let stop_offset = stop_offset.unwrap_or_default();
            let range_check_base =
                (0..idx).fold(1, |acc, i| acc + vm.get_segment_size(i).unwrap_or_default());
            let range_check_end = range_check_base + stop_offset;

            (range_check_base, range_check_end)
        })
        .ok();

    let range_check_builtin_range = range_check.map(|(start, end)| Range {
        start: start as u64,
        end: end as u64,
    });

    Ok((
        register_states,
        cairo_mem,
        data_len,
        range_check_builtin_range,
    ))
}

pub fn run_program_cairo_1(
    entrypoint_function: Option<&str>,
    layout: CairoLayout,
    filename: &str,
) -> Result<(RegisterStates, CairoMemory, usize), Error> {
    // default value for entrypoint is "main"
    let entrypoint = entrypoint_function.unwrap_or("main");

    let program_content = std::fs::read(filename).map_err(Error::IO)?;

    let casm_contract: CasmContractClass = serde_json::from_slice(&program_content).unwrap();

    let program: Program = casm_contract.clone().try_into().unwrap();

    let mut runner = CairoRunner::new(
        &(casm_contract.clone().try_into().unwrap()),
        layout.as_str(),
        false,
    )
    .unwrap();

    let mut vm = VirtualMachine::new(true);

    runner.initialize_function_runner_cairo_1(&mut vm, &[BuiltinName::range_check]);

    // Implicit Args
    let syscall_segment = MaybeRelocatable::from(vm.add_memory_segment());

    let args = [
        Felt252::new(1).into(),
        Felt252::new(1).into(),
        Felt252::new(1).into(),
    ];

    let builtins: Vec<&'static str> = runner
        .get_program_builtins()
        .iter()
        .map(|b| b.name())
        .collect();

    let builtin_segment: Vec<MaybeRelocatable> = vm
        .get_builtin_runners()
        .iter()
        .filter(|b| builtins.contains(&b.name()))
        .flat_map(|b| b.initial_stack())
        .collect();

    let initial_gas = MaybeRelocatable::from(usize::MAX);

    let mut implicit_args = builtin_segment;
    implicit_args.extend([initial_gas]);
    implicit_args.extend([syscall_segment]);

    // Other args

    // Load builtin costs
    let builtin_costs: Vec<MaybeRelocatable> =
        vec![0.into(), 0.into(), 0.into(), 0.into(), 0.into()];
    let builtin_costs_ptr = vm.add_memory_segment();
    vm.load_data(builtin_costs_ptr, &builtin_costs).unwrap();

    // Load extra data
    let core_program_end_ptr = (runner.program_base.unwrap() + program.data_len()).unwrap();
    let program_extra_data: Vec<MaybeRelocatable> =
        vec![0x208B7FFF7FFF7FFE.into(), builtin_costs_ptr.into()];
    vm.load_data(core_program_end_ptr, &program_extra_data)
        .unwrap();

    // Load calldata
    let calldata_start = vm.add_memory_segment();
    let calldata_end = vm.load_data(calldata_start, &args.to_vec()).unwrap();

    // Create entrypoint_args

    let mut entrypoint_args: Vec<CairoArg> = implicit_args
        .iter()
        .map(|m| CairoArg::from(m.clone()))
        .collect();
    entrypoint_args.extend([
        MaybeRelocatable::from(calldata_start).into(),
        MaybeRelocatable::from(calldata_end).into(),
    ]);
    let entrypoint_args: Vec<&CairoArg> = entrypoint_args.iter().collect();

    let mut hint_processor = BuiltinHintProcessor::new_empty();

    // Run contract entrypoint
    // We assume entrypoint 0 for only one function
    runner
        .run_from_entrypoint(
            0,
            &entrypoint_args,
            &mut None,
            true,
            Some(program.data_len() + program_extra_data.len()),
            &mut vm,
            &mut hint_processor,
        )
        .unwrap();

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

    runner.relocate(&mut vm, true);

    let relocated_trace = vm.get_relocated_trace()?;
    let relocated_memory = runner.relocated_memory;

    // (RegisterStates, CairoMemory, usize)
    /*
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
    let register_states = RegisterStates::from_bytes_le(&trace_vec).unwrap();

    let data_len = cairo_runner.get_program().data_len();

    Ok((register_states, cairo_mem, data_len))
    */
}

pub fn generate_prover_args(
    file_path: &str,
) -> (TraceTable<Stark252PrimeField>, CairoAIR, PublicInputs) {
    let (register_states, memory, program_size, range_check_builtin_range) =
        run_program(None, CairoLayout::Small, file_path).unwrap();

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
    };

    let mut pub_inputs = PublicInputs::from_regs_and_mem(
        &register_states,
        &memory,
        program_size,
        range_check_builtin_range,
    );

    let main_trace = build_main_trace(&register_states, &memory, &mut pub_inputs);

    let has_range_check_builtin = pub_inputs.range_check_builtin_range.is_some();
    let cairo_air = CairoAIR::new(
        proof_options,
        main_trace.n_rows(),
        register_states.steps(),
        has_range_check_builtin,
    );

    (main_trace, cairo_air, pub_inputs)
}

pub fn generate_prover_args_cairo_1(
    file_path: &str,
) -> (TraceTable<Stark252PrimeField>, CairoAIR, PublicInputs) {
    let (register_states, memory, program_size, range_check_builtin_range) =
        run_program(None, CairoLayout::Plain, file_path).unwrap();

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
    };

    let mut pub_inputs = PublicInputs::from_regs_and_mem(
        &register_states,
        &memory,
        program_size,
        range_check_builtin_range,
    );

    let main_trace = build_main_trace(&register_states, &memory, &mut pub_inputs);

    let cairo_air = CairoAIR::new(
        proof_options,
        main_trace.n_rows(),
        register_states.steps(),
        range_check_builtin_range.is_some(),
    );

    (main_trace, cairo_air, pub_inputs)
}

pub fn program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/cairo_programs/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

#[cfg(test)]
mod tests {
    use crate::cairo::execution_trace::build_cairo_execution_trace;

    use super::*;
    use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::MontgomeryConfigStark252PrimeField;
    use lambdaworks_math::field::{
        element::FieldElement, fields::montgomery_backed_prime_fields::U256PrimeField,
    };

    pub type Stark252PrimeField = U256PrimeField<MontgomeryConfigStark252PrimeField>;
    type FE = FieldElement<Stark252PrimeField>;

    #[test]
    fn test_parse_cairo_file() {
        let base_dir = env!("CARGO_MANIFEST_DIR");
        let json_filename = base_dir.to_owned() + "/src/cairo/runner/program.json";

        let (register_states, memory, program_size, _rg_in_out) =
            run_program(None, CairoLayout::AllCairo, &json_filename).unwrap();
        let pub_inputs =
            PublicInputs::from_regs_and_mem(&register_states, &memory, program_size, None);
        let execution_trace = build_cairo_execution_trace(&register_states, &memory, &pub_inputs);

        // This trace is obtained from Giza when running the prover for the mentioned program.
        let expected_trace = TraceTable::new_from_cols(&[
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
