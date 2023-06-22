use lambdaworks_math::field::fields::{
    fft_friendly::stark_252_prime_field::Stark252PrimeField, u64_prime_field::FE17,
};
use lambdaworks_stark::air::cairo_air::air::{
    CairoAIR, MemorySegment, MemorySegmentMap, PublicInputs, FRAME_DST_ADDR, FRAME_OP0_ADDR,
    FRAME_OP1_ADDR, FRAME_PC,
};
use lambdaworks_stark::air::example::fibonacci_rap::{fibonacci_rap_trace, FibonacciRAP};
use lambdaworks_stark::air::example::{
    dummy_air, fibonacci_2_columns, fibonacci_f17, quadratic_air, simple_fibonacci,
};
use lambdaworks_stark::air::trace::TraceTable;
use lambdaworks_stark::cairo_run::cairo_layout::CairoLayout;
use lambdaworks_stark::cairo_run::run::{generate_prover_args, program_path, run_program};
use lambdaworks_stark::cairo_vm::execution_trace::build_main_trace;
use lambdaworks_stark::{
    air::context::{AirContext, ProofOptions},
    fri::FieldElement,
    prover::prove,
    verifier::verify,
};

pub type FE = FieldElement<Stark252PrimeField>;

#[test_log::test]
fn test_prove_fib() {
    let trace = simple_fibonacci::fibonacci_trace([FE::from(1), FE::from(1)], 8);
    let trace_length = trace.n_rows();

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 1,
            coset_offset: 3,
        },
        trace_length,
        trace_columns: 1,
        transition_degrees: vec![1],
        transition_exemptions: vec![2],
        transition_offsets: vec![0, 1, 2],
        num_transition_constraints: 1,
    };

    let fibonacci_air = simple_fibonacci::FibonacciAIR::from(context);

    let result = prove(&trace, &fibonacci_air, &mut ()).unwrap();
    assert!(verify(&result, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_fib17() {
    let trace = simple_fibonacci::fibonacci_trace([FE17::from(1), FE17::from(1)], 4);
    let trace_length = trace.n_rows();

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 1,
            coset_offset: 3,
        },
        trace_length,
        trace_columns: 1,
        transition_degrees: vec![1],
        transition_exemptions: vec![2],
        transition_offsets: vec![0, 1, 2],
        num_transition_constraints: 1,
    };

    let fibonacci_air = fibonacci_f17::Fibonacci17AIR::from(context);

    let result = prove(&trace, &fibonacci_air, &mut ()).unwrap();
    assert!(verify(&result, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_fib_2_cols() {
    let trace = fibonacci_2_columns::fibonacci_trace_2_columns([FE::from(1), FE::from(1)], 16);
    let trace_length = trace.n_rows();

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 7,
            coset_offset: 3,
        },
        trace_length,
        transition_degrees: vec![1, 1],
        transition_exemptions: vec![1, 1],
        transition_offsets: vec![0, 1],
        num_transition_constraints: 2,
        trace_columns: 2,
    };

    let fibonacci_air = fibonacci_2_columns::Fibonacci2ColsAIR::from(context);

    let result = prove(&trace, &fibonacci_air, &mut ()).unwrap();
    assert!(verify(&result, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_quadratic() {
    let trace = quadratic_air::quadratic_trace(FE::from(3), 4);
    let trace_length = trace.n_rows();

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 1,
            coset_offset: 3,
        },
        trace_length,
        trace_columns: 1,
        transition_degrees: vec![2],
        transition_exemptions: vec![1],
        transition_offsets: vec![0, 1],
        num_transition_constraints: 1,
    };

    let quadratic_air = quadratic_air::QuadraticAIR::from(context);

    let result = prove(&trace, &quadratic_air, &mut ()).unwrap();
    assert!(verify(&result, &quadratic_air, &()));
}

#[ignore = "metal"]
/// Loads the program in path, runs it with the Cairo VM, and amkes a proof of it
fn test_prove_cairo_program(file_path: &str, memory_segments: &MemorySegmentMap) {
    let (main_trace, cairo_air, mut pub_inputs) = generate_prover_args(file_path, memory_segments);
    let result = prove(&main_trace, &cairo_air, &mut pub_inputs).unwrap();

    assert!(verify(&result, &cairo_air, &pub_inputs));
}

#[test_log::test]
fn test_prove_cairo_simple_program() {
    test_prove_cairo_program(
        &program_path("simple_program.json"),
        &MemorySegmentMap::new(),
    );
}

#[test_log::test]
fn test_prove_cairo_fibonacci_5() {
    test_prove_cairo_program(&program_path("fibonacci_5.json"), &MemorySegmentMap::new());
}

#[test_log::test]
fn test_prove_cairo_rc_program() {
    test_prove_cairo_program(
        &program_path("rc_program.json"),
        &MemorySegmentMap::from([(MemorySegment::RangeCheck, 27..29)]),
    );
}

#[test_log::test]
fn test_prove_cairo_lt_comparison() {
    test_prove_cairo_program(
        &program_path("lt_comparison.json"),
        &MemorySegmentMap::from([(MemorySegment::RangeCheck, 131..132)]),
    );
}

#[test_log::test]
fn test_prove_cairo_compare_lesser_array() {
    test_prove_cairo_program(
        &program_path("compare_lesser_array.json"),
        &MemorySegmentMap::from([(MemorySegment::RangeCheck, 856..866)]),
    );
}

#[test_log::test]
fn test_prove_cairo_output_and_rc_program() {
    test_prove_cairo_program(
        &program_path("signed_div_rem.json"),
        &MemorySegmentMap::from([
            (MemorySegment::Output, 289..293),
            (MemorySegment::RangeCheck, 293..309),
        ]),
    );
}

#[test_log::test]
fn test_prove_rap_fib() {
    let trace_length = 16;
    let trace = fibonacci_rap_trace([FE::from(1), FE::from(1)], trace_length);
    let trace_cols = trace.cols();
    let power_of_two_len = trace_cols[0].len();
    let exemptions = 3 + power_of_two_len - trace_length - 1;

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 1,
            coset_offset: 3,
        },
        trace_columns: 3,
        trace_length: trace_cols[0].len(),
        transition_degrees: vec![1, 2],
        transition_offsets: vec![0, 1, 2],
        transition_exemptions: vec![exemptions, 1],
        num_transition_constraints: 2,
    };

    let fibonacci_rap = FibonacciRAP::new(context);

    let result = prove(&trace, &fibonacci_rap, &mut ()).unwrap();
    assert!(verify(&result, &fibonacci_rap, &()));
}

#[test_log::test]
fn test_prove_dummy() {
    let trace_length = 16;
    let trace = dummy_air::dummy_trace(trace_length);

    let context = AirContext {
        options: ProofOptions {
            blowup_factor: 2,
            fri_number_of_queries: 1,
            coset_offset: 3,
        },
        trace_length,
        trace_columns: 2,
        transition_degrees: vec![2, 1],
        transition_exemptions: vec![0, 2],
        transition_offsets: vec![0, 1, 2],
        num_transition_constraints: 2,
    };

    let dummy_air = dummy_air::DummyAIR::from(context);

    let result = prove(&trace, &dummy_air, &mut ()).unwrap();
    assert!(verify(&result, &dummy_air, &()));
}

#[test_log::test]
fn test_verifier_rejects_proof_of_a_slightly_different_program() {
    let (main_trace, cairo_air, mut public_input) = generate_prover_args(
        &program_path("simple_program.json"),
        &MemorySegmentMap::new(),
    );
    let result = prove(&main_trace, &cairo_air, &mut public_input).unwrap();

    // We modify the original program and verify using this new "corrupted" version
    let mut corrupted_program = public_input.public_memory.clone();
    corrupted_program.insert(FieldElement::one(), FieldElement::from(5));
    corrupted_program.insert(FieldElement::from(3), FieldElement::from(5));

    // Here we use the corrupted version of the program in the public inputs
    public_input.public_memory = corrupted_program;
    assert!(!verify(&result, &cairo_air, &public_input));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_different_range_bounds() {
    let (main_trace, cairo_air, mut public_input) = generate_prover_args(
        &program_path("simple_program.json"),
        &MemorySegmentMap::new(),
    );
    let result = prove(&main_trace, &cairo_air, &mut public_input).unwrap();

    public_input.range_check_min = Some(public_input.range_check_min.unwrap() + 1);
    assert!(!verify(&result, &cairo_air, &public_input));

    public_input.range_check_min = Some(public_input.range_check_min.unwrap() - 1);
    public_input.range_check_max = Some(public_input.range_check_max.unwrap() - 1);
    assert!(!verify(&result, &cairo_air, &public_input));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_changed_range_check_value() {
    // In this test we change the range-check value in the trace, so the constraint
    // that asserts that the sum of the rc decomposed values is equal to the
    // range-checked value won't hold, and the verifier will reject the proof.
    let (main_trace, cairo_air, mut public_input) = generate_prover_args(
        &program_path("rc_program.json"),
        &MemorySegmentMap::from([(MemorySegment::RangeCheck, 27..29)]),
    );

    // The malicious value, we change the previous value to a 35.
    let malicious_rc_value = FE::from(35);

    let mut malicious_trace_columns = main_trace.cols();
    let n_cols = malicious_trace_columns.len();
    let mut last_column = malicious_trace_columns.last().unwrap().clone();
    last_column[0] = malicious_rc_value;
    malicious_trace_columns[n_cols - 1] = last_column;

    let malicious_trace = TraceTable::new_from_cols(&malicious_trace_columns);
    let proof = prove(&malicious_trace, &cairo_air, &mut public_input).unwrap();
    assert!(!verify(&proof, &cairo_air, &public_input));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_overflowing_range_check_value() {
    // In this test we manually insert a value greater than 2^128 in the range-check builtin segment.

    // This value is greater than 2^128, and the verifier should reject the proof built with it.
    let overflowing_rc_value = FE::from_hex("0x100000000000000000000000000000001").unwrap();

    let layout = CairoLayout::Small;
    let program_path = program_path("rc_program.json");
    let (register_states, mut malicious_memory, program_size) =
        run_program(None, layout, &program_path).unwrap();

    // The malicious value is inserted in memory here.
    malicious_memory.data.insert(27, overflowing_rc_value);

    // These is the regular setup for generating the trace and the Cairo AIR, but now
    // we do it with the malicious memory
    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
    };
    let memory_segments = MemorySegmentMap::from([(MemorySegment::RangeCheck, 27..29)]);
    let mut pub_inputs = PublicInputs::from_regs_and_mem(
        &register_states,
        &malicious_memory,
        program_size,
        &memory_segments,
    );

    let malicious_trace = build_main_trace(&register_states, &malicious_memory, &mut pub_inputs);

    let cairo_air = CairoAIR::new(
        proof_options,
        malicious_trace.n_rows(),
        register_states.steps(),
        true,
    );

    let proof = prove(&malicious_trace, &cairo_air, &mut pub_inputs).unwrap();
    assert!(!verify(&proof, &cairo_air, &pub_inputs));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_changed_output() {
    let (main_trace, cairo_air, mut public_input) = generate_prover_args(
        &program_path("output_program.json"),
        &MemorySegmentMap::from([(MemorySegment::Output, 19..20)]),
    );

    // The malicious value, we change the previous value to a 100.
    let malicious_output_value = FE::from(100);

    let mut output_col_idx = None;
    let mut output_row_idx = None;
    for (i, row) in main_trace.rows().iter().enumerate() {
        let output_col_found = [FRAME_PC, FRAME_DST_ADDR, FRAME_OP0_ADDR, FRAME_OP1_ADDR]
            .iter()
            .find(|&&col_idx| row[col_idx] != FE::from(19));
        if output_col_found.is_some() {
            output_col_idx = output_col_found;
            output_row_idx = Some(i);
            break;
        }
    }
    let output_col_idx = *output_col_idx.unwrap();
    let output_row_idx = output_row_idx.unwrap();

    let mut malicious_trace_columns = main_trace.cols();
    let mut output_column = malicious_trace_columns[output_col_idx].clone();
    output_column[output_row_idx] = malicious_output_value;
    malicious_trace_columns[output_col_idx] = output_column;

    let malicious_trace = TraceTable::new_from_cols(&malicious_trace_columns);
    let proof = prove(&malicious_trace, &cairo_air, &mut public_input).unwrap();
    assert!(!verify(&proof, &cairo_air, &public_input));
}
