use std::time::Duration;

use criterion::{
    black_box, criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup, Criterion,
};
use lambdaworks_stark::{
    air::cairo_air::air::MemorySegmentMap, cairo_run::run::generate_prover_args, prover::prove,
};

pub mod functions;
pub mod util;

fn cairo_benches(c: &mut Criterion) {
    let mut group = c.benchmark_group("CAIRO");
    group.sample_size(10);
    group.measurement_time(Duration::from_secs(30));
    run_cairo_bench(
        &mut group,
        "fibonacci/10",
        &program_path("fibonacci_10.json"),
    );
    run_cairo_bench(
        &mut group,
        "fibonacci/30",
        &program_path("fibonacci_30.json"),
    );
}

fn program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/src/cairo_vm/test_data/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

fn run_cairo_bench(group: &mut BenchmarkGroup<'_, WallTime>, benchname: &str, program_path: &str) {
    let (main_trace, cairo_air, mut pub_inputs) =
        generate_prover_args(program_path, &MemorySegmentMap::new());

    group.bench_function(benchname, |bench| {
        bench.iter(|| black_box(prove(&main_trace, &cairo_air, &mut pub_inputs).unwrap()));
    });
}

criterion_group!(benches, cairo_benches);
criterion_main!(benches);
