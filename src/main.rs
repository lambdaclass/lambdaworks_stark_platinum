use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use lambdaworks_stark::cairo::air::CairoAIR;
use lambdaworks_stark::cairo::runner::run::{generate_prover_args, CairoVersion};
use lambdaworks_stark::starks::proof::options::ProofOptions;
use lambdaworks_stark::starks::{prover::prove, verifier::verify};
use std::env;
use std::time::Instant;

fn main() {
    let args: Vec<String> = env::args().collect();

    let file_path = &args[1];
    let grinding_factor = 20;

    let timer = Instant::now();

    let cairo_version = if file_path.contains(".casm") {
        println!("Running casm on CairoVM and generating trace ...");
        CairoVersion::V1
    } else {
        println!("Running program on CairoVM and generating trace ...");
        CairoVersion::V0
    };

    let Ok(program_content) = std::fs::read(file_path) else {
        println!("ERROR opening {file_path} file");
        return;
    };

    let Ok((main_trace, mut pub_inputs)) =
        generate_prover_args(&program_content, &cairo_version, &None, grinding_factor) else {
            println!("Error generating prover args");
            return;
        };

    println!("  Time spent: {:?} \n", timer.elapsed());

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor,
    };

    let timer = Instant::now();
    println!("Making proof ...");
    let proof =
        prove::<Stark252PrimeField, CairoAIR>(&main_trace, pub_inputs, proof_options).unwrap();
    println!("Time spent in proving: {:?} \n", timer.elapsed());

    let timer = Instant::now();

    // println!("Verifying ...");
    // let proof_verified = verify(&proof, &cairo_air, &pub_inputs);
    // println!("Time spent in verifying: {:?} \n", timer.elapsed());

    // if proof_verified {
    //     println!("Verification succeded");
    // } else {
    //     println!("Verification failed");
    // }
}
