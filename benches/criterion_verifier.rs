use criterion::{
    black_box, criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup, Criterion,
};
use lambdaworks_math::{
    field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField, traits::Deserializable,
};
use lambdaworks_stark::{
    cairo::air::{CairoAIR, PublicInputs},
    starks::{
        proof::{options::ProofOptions, stark::StarkProof},
        verifier::verify,
    },
};
use std::time::Duration;

pub mod functions;

fn load_proof_and_pub_inputs(input_path: &str) -> (StarkProof<Stark252PrimeField>, PublicInputs) {
    let program_content = std::fs::read(input_path).unwrap();
    let mut bytes = program_content.as_slice();
    let proof_len = usize::from_be_bytes(bytes[0..8].try_into().unwrap());
    bytes = &bytes[8..];
    let proof = StarkProof::<Stark252PrimeField>::deserialize(&bytes[0..proof_len]).unwrap();
    bytes = &bytes[proof_len..];

    let public_inputs = PublicInputs::deserialize(bytes).unwrap();

    (proof, public_inputs)
}

fn verifier_benches(c: &mut Criterion) {
    let mut group = c.benchmark_group("VERIFIER");
    group.sample_size(10);
    group.measurement_time(Duration::from_secs(30));
    run_verifier_bench(
        &mut group,
        "fibonacci/10",
        &cairo0_proof_path("fibonacci_10.proof"),
    );
    run_verifier_bench(
        &mut group,
        "fibonacci/100",
        &cairo0_proof_path("fibonacci_100.proof"),
    );
}

fn cairo0_proof_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/benches/proofs/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

fn run_verifier_bench(
    group: &mut BenchmarkGroup<'_, WallTime>,
    benchname: &str,
    program_path: &str,
) {
    let (proof, pub_inputs) = load_proof_and_pub_inputs(program_path);
    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let cairo_air = CairoAIR::new(proof_options, proof.trace_length, pub_inputs.clone(), false);

    group.bench_function(benchname, |bench| {
        bench.iter(|| black_box(verify(&proof, &cairo_air, &pub_inputs)));
    });
}

criterion_group!(benches, verifier_benches);
criterion_main!(benches);
