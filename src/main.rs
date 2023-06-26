use std::env;
use std::time::Instant;

use lambdaworks_stark::cairo::runner::run::generate_prover_args;
use lambdaworks_stark::starks::prover::prove;
use lambdaworks_stark::starks::verifier::verify;

fn main() {
    let args: Vec<String> = env::args().collect();

    let file_path = &args[1];
    println!("Running program and generating trace ...");
    let timer = Instant::now();

    let (main_trace, cairo_air, mut pub_inputs) = generate_prover_args(file_path, &None);
    println!("  Time spent: {:?} \n", timer.elapsed());

    let timer = Instant::now();
    println!("Making proof ...");
    let proof = prove(&main_trace, &cairo_air, &mut pub_inputs).unwrap();
    println!("Time spent in proving: {:?} \n", timer.elapsed());

    let timer = Instant::now();

    println!("Verifying ...");
    let proof_verified = verify(&proof, &cairo_air, &pub_inputs);
    println!("Time spent in verifying: {:?} \n", timer.elapsed());

    if proof_verified {
        println!("Verification succeded");
    } else {
        println!("Verification failed");
    }
}
