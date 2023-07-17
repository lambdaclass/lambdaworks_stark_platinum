use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use lambdaworks_stark::{
    cairo::{
        air::PublicInputs,
        cairo_mem::CairoMemory,
        register_states::RegisterStates,
        runner::run::{generate_prover_args, CairoVersion},
    },
    starks::{
        proof::options::{ProofOptions, SecurityLevel},
        trace::TraceTable,
    },
};

pub fn generate_cairo_trace(filename: &str) -> (RegisterStates, CairoMemory) {
    let base_dir = env!("CARGO_MANIFEST_DIR").to_string() + "/src/cairo_vm/test_data/";

    let trace_path = format!("{base_dir}/{filename}.trace");
    let memory_path = format!("{base_dir}/{filename}.memory");

    let register_states =
        RegisterStates::from_file(&trace_path).expect("Cairo trace binary file not found");
    let memory = CairoMemory::from_file(&memory_path).expect("Cairo memory binary file not found");

    (register_states, memory)
}

pub fn generate_prover_args_with_options(
    program_path: &str,
    security_level: SecurityLevel,
) -> (ProofOptions, TraceTable<Stark252PrimeField>, PublicInputs) {
    let program_content = std::fs::read(program_path).unwrap();
    let proof_options = ProofOptions::new_secure(security_level, 3);
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();
    (proof_options, main_trace, pub_inputs)
}
