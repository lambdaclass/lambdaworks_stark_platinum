use criterion::{
    black_box, criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup, Criterion,
};
use lambdaworks_stark::{
    cairo::{
        air::generate_cairo_proof,
        runner::run::{generate_prover_args, CairoVersion},
    },
    starks::proof::options::{self, SecurityLevel},
};

pub mod functions;

fn cairo_benches(c: &mut Criterion) {
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
    group.sample_size(10);

    run_lambdaworks_bench(
        &mut group,
        "lambdaworks/fibonacci/1000",
        &cairo0_program_path("fibonacci_1000.json"),
    );
    run_giza_bench(
        &mut group,
        "giza/fibonacci/1000",
        &cairo0_program_path("fibonacci_1000.json"),
        &cairo0_program_path("fibonacci_1000.trace"),
        &cairo0_program_path("fibonacci_1000.memory"),
    );

    run_lambdaworks_bench(
        &mut group,
        "lambdaworks/fibonacci/10000",
        &cairo0_program_path("fibonacci_10000.json"),
    );
    run_giza_bench(
        &mut group,
        "giza/fibonacci/10000",
        &cairo0_program_path("fibonacci_10000.json"),
        &cairo0_program_path("fibonacci_10000.trace"),
        &cairo0_program_path("fibonacci_10000.memory"),
    );
}

fn cairo0_program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const PROGRAM_BASE_REL_PATH: &str = "/cairo_programs/cairo0/";
    let program_base_path = CARGO_DIR.to_string() + PROGRAM_BASE_REL_PATH;
    program_base_path + program_name
}

fn run_lambdaworks_bench(
    group: &mut BenchmarkGroup<'_, WallTime>,
    benchname: &str,
    program_path: &str,
) {
    let program_content = std::fs::read(program_path).unwrap();
    let proof_options = options::ProofOptions::new_secure(SecurityLevel::Provable80Bits, 3);
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

    group.bench_function(benchname, |bench| {
        bench.iter(|| {
            black_box(generate_cairo_proof(&main_trace, &pub_inputs, &proof_options).unwrap())
        });
    });
}

fn run_giza_bench(
    group: &mut BenchmarkGroup<'_, WallTime>,
    benchname: &str,
    program_path: &str,
    trace_path: &str,
    memory_path: &str,
) {
    let proof_options = options::ProofOptions::new_secure(SecurityLevel::Provable80Bits, 3);
    let proof_options = giza_prover::ProofOptions::with_proof_options(
        Some(proof_options.fri_number_of_queries),
        Some(proof_options.blowup_factor as usize),
        Some(proof_options.grinding_factor as u32),
        None,
        None,
    );

    group.bench_function(benchname, |bench| {
        bench.iter(|| {
            let trace = giza_runner::ExecutionTrace::from_file(
                program_path.into(),
                trace_path.into(),
                memory_path.into(),
                None,
            );

            black_box(giza_prover::prove_trace(trace, &proof_options)).unwrap()
        });
    });
}

criterion_group!(benches, cairo_benches);
criterion_main!(benches);
