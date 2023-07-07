use criterion::{
    black_box, criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup, Criterion,
};
use lambdaworks_stark::{
    cairo::{
        air::generate_cairo_proof,
        runner::run::{generate_prover_args, CairoVersion},
    },
    starks::proof::options::ProofOptions,
};
use std::time::Duration;

pub mod functions;

fn cairo_benches(c: &mut Criterion) {
    #[cfg(feature = "parallel")]
    rayon::ThreadPoolBuilder::new()
        .num_threads(8)
        .build_global()
        .unwrap();

    let mut group = c.benchmark_group("CAIRO");
    group.sample_size(10);
    group.measurement_time(Duration::from_secs(30));
    run_cairo_bench(
        &mut group,
        "fibonacci/10",
        &cairo0_program_path("fibonacci_10.json"),
    );
    run_cairo_bench(
        &mut group,
        "fibonacci/100",
        &cairo0_program_path("fibonacci_100.json"),
    );
}

fn cairo0_program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/cairo_programs/cairo0/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

fn run_cairo_bench(group: &mut BenchmarkGroup<'_, WallTime>, benchname: &str, program_path: &str) {
    let program_content = std::fs::read(program_path).unwrap();
    let proof_options = ProofOptions::default_test_options();
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

    group.bench_function(benchname, |bench| {
        bench.iter(|| {
            black_box(generate_cairo_proof(&main_trace, &pub_inputs, &proof_options).unwrap())
        });
    });
}

criterion_group!(benches, cairo_benches);
criterion_main!(benches);
