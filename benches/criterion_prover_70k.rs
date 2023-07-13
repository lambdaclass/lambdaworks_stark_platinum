use criterion::{
    criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup, Criterion, SamplingMode,
};
use functions::bench::run_cairo_bench_with_security_level;
use lambdaworks_stark::starks::proof::options::SecurityLevel;

pub mod functions;

fn fibo_70k_bench(c: &mut Criterion) {
    #[cfg(feature = "parallel")]
    {
        let num_threads: usize = std::env::var("NUM_THREADS")
            .unwrap_or("8".to_string())
            .parse()
            .unwrap();
        println!("Running benchmarks using {} threads", num_threads);
        rayon::ThreadPoolBuilder::new()
            .num_threads(num_threads)
            .build_global()
            .unwrap();
    };

    let mut group = c.benchmark_group("CAIRO");
    group.sampling_mode(SamplingMode::Flat);
    group.sample_size(10);
    run_cairo_bench(
        &mut group,
        "fibonacci/70000",
        &cairo0_program_path("fibonacci_70000.json"),
    );
}

fn cairo0_program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/cairo_programs/cairo0/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

fn run_cairo_bench(group: &mut BenchmarkGroup<'_, WallTime>, benchname: &str, program_path: &str) {
    run_cairo_bench_with_security_level(
        group,
        benchname,
        program_path,
        SecurityLevel::Provable128Bits,
    );
}

criterion_group!(benches, fibo_70k_bench);
criterion_main!(benches);
