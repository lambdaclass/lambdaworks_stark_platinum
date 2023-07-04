use std::ops::Range;

use lambdaworks_crypto::merkle_tree::proof;
use lambdaworks_math::field::fields::{
    fft_friendly::stark_252_prime_field::Stark252PrimeField, u64_prime_field::FE17,
};
use lambdaworks_stark::{
    cairo::{
        air::{
            CairoAIR, MemorySegment, MemorySegmentMap, PublicInputs, FRAME_DST_ADDR,
            FRAME_OP0_ADDR, FRAME_OP1_ADDR, FRAME_PC,
        },
        cairo_layout::CairoLayout,
        execution_trace::build_main_trace,
        runner::run::{
            cairo0_program_path, cairo1_program_path, generate_prover_args, run_program,
            CairoVersion,
        },
    },
    starks::{
        context::AirContext,
        example::{
            dummy_air, fibonacci_2_columns,
            fibonacci_rap::{fibonacci_rap_trace, FibonacciRAP, FibonacciRAPPublicInputs},
            quadratic_air::{self, QuadraticPublicInputs},
            simple_fibonacci::{self, FibonacciPublicInputs},
        },
        proof::options::ProofOptions,
        prover::prove,
        trace::TraceTable,
        traits::AIR,
        verifier::verify,
    },
    FE,
};

const GRINDING_FACTOR: u8 = 1;

#[test_log::test]
fn test_prove_fib() {
    let trace = simple_fibonacci::fibonacci_trace([FE::from(1), FE::from(1)], 8);
    let trace_length = trace.n_rows();

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 7,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let pub_inputs = FibonacciPublicInputs {
        a0: FE17::one(),
        a1: FE17::one(),
    };

    let proof = prove(&trace, pub_inputs, proof_options).unwrap();
    assert!(verify(&proof, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_fib17() {
    let trace = simple_fibonacci::fibonacci_trace([FE17::from(1), FE17::from(1)], 4);
    let trace_length = trace.n_rows();

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 7,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let pub_inputs = FibonacciPublicInputs {
        a0: FE17::one(),
        a1: FE17::one(),
    };

    let result = prove(&trace, pub_inputs, proof_options).unwrap();
    assert!(verify(&result, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_fib_2_cols() {
    let trace = fibonacci_2_columns::fibonacci_trace_2_columns([FE::from(1), FE::from(1)], 16);
    let trace_length = trace.n_rows();

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 7,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let pub_inputs = FibonacciPublicInputs {
        a0: FE::one(),
        a1: FE::one(),
    };

    let result = prove(&trace, pub_inputs, proof_options).unwrap();
    assert!(verify(&result, &fibonacci_air, &()));
}

#[test_log::test]
fn test_prove_quadratic() {
    let trace = quadratic_air::quadratic_trace(FE::from(3), 4);
    let trace_length = trace.n_rows();

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 1,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let pub_inputs = QuadraticPublicInputs { a0: FE::from(3) };

    let proof = prove(&trace, pub_inputs, proof_options).unwrap();
    assert!(verify(&proof, &quadratic_air, &()));
}

/// Loads the program in path, runs it with the Cairo VM, and makes a proof of it
fn test_prove_cairo_program(file_path: &str, output_range: &Option<Range<u64>>) {
    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: GRINDING_FACTOR,
    };

    let program_content = std::fs::read(file_path).unwrap();
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V0, output_range).unwrap();

    let proof = prove(&main_trace, &pub_inputs, proof_options).unwrap();

    assert!(verify(&proof, &cairo_air, &pub_inputs));
}

/// Loads the program in path, runs it with the Cairo VM, and makes a proof of it
fn test_prove_cairo1_program(file_path: &str) {
    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: GRINDING_FACTOR,
    };
    let program_content = std::fs::read(file_path).unwrap();
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V1, &None).unwrap();
    let result = prove(&main_trace, pub_inputs, proof_options).unwrap();

    assert!(verify(&result, &cairo_air, &pub_inputs));
}

#[test_log::test]
fn test_prove_cairo_simple_program() {
    test_prove_cairo_program(&cairo0_program_path("simple_program.json"), &None);
}

#[test_log::test]
fn test_prove_cairo_fibonacci_5() {
    test_prove_cairo_program(&cairo0_program_path("fibonacci_5.json"), &None);
}

#[cfg_attr(feature = "metal", ignore)]
#[test_log::test]
fn test_prove_cairo_fibonacci_casm() {
    test_prove_cairo1_program(&cairo1_program_path("fibonacci_cairo1.casm"));
}

#[test_log::test]
fn test_prove_cairo_rc_program() {
    test_prove_cairo_program(&cairo0_program_path("rc_program.json"), &None);
}

#[test_log::test]
fn test_prove_cairo_lt_comparison() {
    test_prove_cairo_program(&cairo0_program_path("lt_comparison.json"), &None);
}

#[cfg_attr(feature = "metal", ignore)]
#[test_log::test]
fn test_prove_cairo_compare_lesser_array() {
    test_prove_cairo_program(&cairo0_program_path("compare_lesser_array.json"), &None);
}

#[test_log::test]
fn test_prove_cairo_output_and_rc_program() {
    test_prove_cairo_program(&cairo0_program_path("signed_div_rem.json"), &Some(289..293));
}

#[test_log::test]
fn test_prove_rap_fib() {
    let steps = 16;
    let trace = fibonacci_rap_trace([FE::from(1), FE::from(1)], steps);

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 1,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let pub_inputs = FibonacciRAPPublicInputs {
        steps,
        a0: FE::one(),
        a1: FE::one(),
    };

    let proof = prove(&trace, pub_inputs, proof_options).unwrap();
    assert!(verify(&result, &fibonacci_rap, &()));
}

#[test_log::test]
fn test_prove_dummy() {
    let trace_length = 16;
    let trace = dummy_air::dummy_trace(trace_length);

    let proof_options = ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 1,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let proof = prove(&trace, (), proof_options).unwrap();
    assert!(verify(&proof, &dummy_air, &()));
}

#[test_log::test]
fn test_verifier_rejects_proof_of_a_slightly_different_program() {
    let program_content = std::fs::read(cairo0_program_path("simple_program.json")).unwrap();
    let (main_trace, public_input) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let result = prove(&main_trace, public_input, proof_options).unwrap();

    // We modify the original program and verify using this new "corrupted" version
    let mut corrupted_program = public_input.public_memory.clone();
    corrupted_program.insert(FE::one(), FE::from(5));
    corrupted_program.insert(FE::from(3), FE::from(5));

    // Here we use the corrupted version of the program in the public inputs
    public_input.public_memory = corrupted_program;
    assert!(!verify(&result, &cairo_air, &public_input));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_different_range_bounds() {
    let program_content = std::fs::read(cairo0_program_path("simple_program.json")).unwrap();
    let (main_trace, public_input) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };
    let result = prove(&main_trace, public_input, proof_options).unwrap();

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
    let program_content = std::fs::read(cairo0_program_path("rc_program.json")).unwrap();
    let (main_trace, public_input) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

    // The malicious value, we change the previous value to a 35.
    let malicious_rc_value = FE::from(35);

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let mut malicious_trace_columns = main_trace.cols();
    let n_cols = malicious_trace_columns.len();
    let mut last_column = malicious_trace_columns.last().unwrap().clone();
    last_column[0] = malicious_rc_value;
    malicious_trace_columns[n_cols - 1] = last_column;

    let malicious_trace = TraceTable::new_from_cols(&malicious_trace_columns);
    let proof = prove(&malicious_trace, public_input, proof_options).unwrap();
    assert!(!verify(&proof, &cairo_air, &public_input));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_overflowing_range_check_value() {
    // In this test we manually insert a value greater than 2^128 in the range-check builtin segment.

    // This value is greater than 2^128, and the verifier should reject the proof built with it.
    let overflowing_rc_value = FE::from_hex("0x100000000000000000000000000000001").unwrap();
    let program_content = std::fs::read(cairo0_program_path("rc_program.json")).unwrap();
    let (register_states, mut malicious_memory, program_size, _) = run_program(
        None,
        CairoLayout::Small,
        &program_content,
        &CairoVersion::V0,
    )
    .unwrap();

    // The malicious value is inserted in memory here.
    malicious_memory.data.insert(27, overflowing_rc_value);

    // These is the regular setup for generating the trace and the Cairo AIR, but now
    // we do it with the malicious memory
    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };
    let memory_segments = MemorySegmentMap::from([(MemorySegment::RangeCheck, 27..29)]);
    let mut pub_inputs = PublicInputs::from_regs_and_mem(
        &register_states,
        &malicious_memory,
        program_size,
        &memory_segments,
    );

    let malicious_trace = build_main_trace(&register_states, &malicious_memory, &mut pub_inputs);

    let cairo_air = CairoAIR::new(malicious_trace.n_rows(), pub_inputs.clone(), proof_options);

    let proof =
        prove::<Stark252PrimeField, CairoAIR>(&malicious_trace, pub_inputs, proof_options).unwrap();
    assert!(!verify(&proof, &cairo_air, &pub_inputs));
}

#[test_log::test]
fn test_verifier_rejects_proof_with_changed_output() {
    let program_content = std::fs::read(cairo0_program_path("output_program.json")).unwrap();
    let (main_trace, public_input) =
        generate_prover_args(&program_content, &CairoVersion::V0, &None).unwrap();

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

    let proof_options = ProofOptions {
        blowup_factor: 4,
        fri_number_of_queries: 3,
        coset_offset: 3,
        grinding_factor: 1,
    };

    let mut malicious_trace_columns = main_trace.cols();
    let mut output_column = malicious_trace_columns[output_col_idx].clone();
    output_column[output_row_idx] = malicious_output_value;
    malicious_trace_columns[output_col_idx] = output_column;

    let malicious_trace = TraceTable::new_from_cols(&malicious_trace_columns);
    let proof = prove(&malicious_trace, public_input, proof_options).unwrap();
    assert!(!verify(&proof, &cairo_air, &public_input));
}
