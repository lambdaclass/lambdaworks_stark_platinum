use lambdaworks_math::traits::Serializable;
use lambdaworks_stark::cairo::runner::run::{generate_prover_args, CairoVersion};
use lambdaworks_stark::starks::{prover::prove, verifier::verify};
use std::env;
use std::time::Instant;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        println!("Usage: cargo run <command> [arguments]");
        return;
    }

    let command = &args[1];

    match command.as_str() {
        "prove" => {
            if args.len() < 4 {
                println!("Usage: cargo run prove <input_path> <output_path>");
                return;
            }

            let input_path = &args[2];
            let output_path = &args[3];
            let grinding_factor = 20;
            let timer = Instant::now();

            let cairo_version = if input_path.contains(".casm") {
                println!("Running casm on CairoVM and generating trace ...");
                CairoVersion::V1
            } else {
                println!("Running program on CairoVM and generating trace ...");
                CairoVersion::V0
            };

            let Ok(program_content) = std::fs::read(input_path) else {
                println!("Error opening {input_path} file");
                return;
            };
            let Ok((main_trace, cairo_air, mut pub_inputs)) =
                generate_prover_args(&program_content, &cairo_version, &None, grinding_factor) else {
                    println!("Error generating prover args");
                    return;
                };

            println!("  Time spent: {:?} \n", timer.elapsed());

            let timer = Instant::now();
            println!("Making proof ...");
            let proof;
            match prove(&main_trace, &cairo_air, &mut pub_inputs) {
                Ok(p) => proof = p,
                Err(e) => {
                    println!("Error making proof: {:?}", e);
                    return;
                }
            }
            println!("Time spent in proving: {:?} \n", timer.elapsed());
            let bytes = proof.serialize();
            let Ok(()) = std::fs::write(output_path, bytes) else {
                println!("Error writing proof to file: {output_path}");
                return;
            };
            println!("Proof written to {output_path}");
        }
        "verify" => {
            if args.len() < 3 {
                println!("Usage: cargo run verify <input_path>");
                return;
            }

            let input_path = &args[2];
        }
        "prove_and_verify" => {
            if args.len() < 3 {
                println!("Usage: cargo run prove_and_verify <input_path>");
                return;
            }

            let input_path = &args[2];
        }
        _ => {
            println!("Unknown command: {}", command);
            return;
        }
    }
    /*
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

    let Ok((main_trace, cairo_air, mut pub_inputs)) =
        generate_prover_args(&program_content, &cairo_version, &None, grinding_factor) else {
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
     */
}
