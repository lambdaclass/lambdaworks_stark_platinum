use functions::path::cairo0_program_path;
use lambdaworks_stark::{cairo::air::generate_cairo_proof, starks::proof::options::SecurityLevel};

use crate::functions::stark::generate_prover_args_with_options;

pub mod functions;

#[global_allocator]
static ALLOC: dhat::Alloc = dhat::Alloc;

pub fn main() {
    let _profiler = dhat::Profiler::new_heap();
    println!("\nMeasuring prover RAM usage\n");

    run_prover(
        &cairo0_program_path("fibonacci_100.json"),
        SecurityLevel::Conjecturable80Bits,
    );
    run_prover(
        &cairo0_program_path("fibonacci_500.json"),
        SecurityLevel::Conjecturable80Bits,
    );
    run_prover(
        &cairo0_program_path("fibonacci_2000.json"),
        SecurityLevel::Conjecturable80Bits,
    );
    run_prover(
        &cairo0_program_path("fibonacci_5000.json"),
        SecurityLevel::Conjecturable80Bits,
    );
    run_prover(
        &cairo0_program_path("fibonacci_20000.json"),
        SecurityLevel::Conjecturable80Bits,
    );
}

fn run_prover(program_path: &str, security_level: SecurityLevel) {
    println!("Generating proof for {}", program_path);

    let (proof_options, main_trace, pub_inputs) =
        generate_prover_args_with_options(program_path, security_level);

    let _proof_size = generate_cairo_proof(&main_trace, &pub_inputs, &proof_options);
    println!(
        "Prover RAM usage: {} bytes",
        dhat::HeapStats::get().max_bytes
    );
}
