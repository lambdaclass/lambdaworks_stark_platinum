use std::env;
use std::time::{Instant};

use lambdaworks_stark::{cairo_run::run::generate_prover_args, prover::prove, verifier::verify};

fn main() {
    let args: Vec<String> = env::args().collect();

    let file_path = &args[1];
    let (main_trace, cairo_air, mut pub_inputs) = generate_prover_args(file_path);

    let timer = Instant::now();
    println!("Making proof ...");
    let proof = prove(&main_trace, &cairo_air, &mut pub_inputs).unwrap();
    println!("Proof generated");
    println!("Time spent creating proof: {:?} ", timer.elapsed());

    let timer = Instant::now();

    println!("Verifying ...");
    if verify(&proof, &cairo_air, &pub_inputs) {
        println!("Verification succeded");
    } else {
        println!("Verification failed");
    }
    println!("Time spent verifying: {:?} ", timer.elapsed());
}
