use criterion::{
    black_box, criterion_group, criterion_main, measurement::WallTime, BenchmarkGroup,
    Criterion,
};
use functions::stark::{
    generate_cairo_trace
};
use lambdaworks_math::helpers::next_power_of_two;
use lambdaworks_stark::{
    air::{context::ProofOptions, example::cairo::{self, PublicInputs}},
    fri::FieldElement,
    prover::prove,
};

pub mod functions;
pub mod util;

fn cairo_benches(c: &mut Criterion) {
    let mut group = c.benchmark_group("CAIRO");
    group.sample_size(10);

    /*
    let cargo_path = env!("CARGO_MANIFEST_DIR");
    let cairo_programs_path = &(cargo_path.to_string() + "/src/cairo_vm/test_data/");

    println!("Path: {:?}", cairo_programs_path);
    */

    run_cairo_bench(&mut group, "fibonacci/10", & "fibonacci_10");
    run_cairo_bench(&mut group, "fibonacci/30", &"fibonacci_30");

    run_cairo_bench(&mut group, &"factorial/8", "factorial_8");
    run_cairo_bench(&mut group, "factorial/16", & "factorial_16");
}

fn run_cairo_bench(group: &mut BenchmarkGroup<'_, WallTime>, benchname: &str, file: &str) {
    let (cairo_trace, cairo_memory) = generate_cairo_trace(file);

    let blowup_factors = [4];
    let query_numbers = [5];

    for &blowup_factor in blowup_factors.iter() {
        for &fri_number_of_queries in query_numbers.iter() {

            let proof_options = ProofOptions {
                blowup_factor,
                fri_number_of_queries,
                coset_offset: 3,
            };

            // This should be calculated automatically
            let optimal_amount_of_rows = next_power_of_two(cairo_trace.steps() as u64) as usize;

            let cairo_air = cairo::CairoAIR::new(proof_options,optimal_amount_of_rows, cairo_trace.steps());

            let name = format!("{benchname}_b{blowup_factor}_q{fri_number_of_queries})");

            let last_step = &cairo_trace.rows[cairo_trace.steps() - 1];

            let mut program = vec![];

            // This should be obtained from Cairo Memory
            // 24 may not be right
            for i in 1..=24 as u64 {
                program.push(cairo_memory.get(&i).unwrap().clone());
            }
            
            let mut public_input = PublicInputs {
                pc_init: FieldElement::from(cairo_trace.rows[0].pc),
                ap_init: FieldElement::from(cairo_trace.rows[0].ap),
                fp_init: FieldElement::from(cairo_trace.rows[0].fp),
                pc_final: FieldElement::from(last_step.pc),
                ap_final: FieldElement::from(last_step.ap),
                range_check_min: None,
                range_check_max: None,
                program,
                num_steps: cairo_trace.steps(),
            };
            

            group.bench_function(name, |bench| {
                bench.iter(
                    || black_box
                    (
                        prove(
                            black_box(&(cairo_trace.clone(), cairo_memory.clone())), 
                            black_box(&cairo_air),
                            black_box(&mut public_input)
                        )
                    )
                );
            });
        }
    }
}

criterion_group!(benches, cairo_benches);
criterion_main!(benches);
