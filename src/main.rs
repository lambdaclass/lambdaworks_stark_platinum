use lambdaworks_stark::cairo::runner::run::{generate_prover_args, CairoVersion};
use lambdaworks_stark::starks::{prover::prove, verifier::verify};
use std::env;
use std::time::Instant;

fn main() {
    let args: Vec<String> = env::args().collect();

    let file_path = &args[1];

    let timer = Instant::now();

    let cairo_version = if file_path.contains(".casm") {
        println!("Running casm on CairoVM and generating trace ...");
        CairoVersion::V1
    } else {
        println!("Running program on CairoVM and generating trace ...");
        CairoVersion::V0
    };

    let Ok((main_trace, cairo_air, mut pub_inputs)) =
        generate_prover_args(file_path, &cairo_version) else {
            println!("Error generating prover args");
            return;
        };

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
