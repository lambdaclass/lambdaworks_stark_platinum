use lambdaworks_math::field::fields::{
    fft_friendly::stark_252_prime_field::Stark252PrimeField as F,
    u64_prime_field::{F17, FE17},
};

use crate::{
    starks::{
        example::{
            dummy_air::{self, DummyAIR},
            fibonacci_2_columns::{self, Fibonacci2ColsAIR},
            fibonacci_rap::{fibonacci_rap_trace, FibonacciRAP, FibonacciRAPPublicInputs},
            quadratic_air::{self, QuadraticAIR, QuadraticPublicInputs},
            simple_fibonacci::{self, FibonacciAIR, FibonacciPublicInputs},
        },
        proof::options::ProofOptions,
        prover::prove,
        verifier::verify,
    },
    FE,
};

#[test_log::test]
fn test_prove_fib() {
    let trace = simple_fibonacci::fibonacci_trace([FE::from(1), FE::from(1)], 8);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciPublicInputs {
        a0: FE::one(),
        a1: FE::one(),
    };

    let proof = prove::<F, FibonacciAIR<F>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F, FibonacciAIR<F>>(
        &proof,
        &pub_inputs,
        &proof_options
    ));
}

#[test_log::test]
fn test_prove_fib17() {
    let trace = simple_fibonacci::fibonacci_trace([FE17::from(1), FE17::from(1)], 4);

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

    let proof = prove::<F17, FibonacciAIR<F17>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F17, FibonacciAIR<F17>>(
        &proof,
        &pub_inputs,
        &proof_options
    ));
}

#[test_log::test]
fn test_prove_fib_2_cols() {
    let trace = fibonacci_2_columns::fibonacci_trace_2_columns([FE::from(1), FE::from(1)], 16);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciPublicInputs {
        a0: FE::one(),
        a1: FE::one(),
    };

    let proof = prove::<F, Fibonacci2ColsAIR<F>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F, Fibonacci2ColsAIR<F>>(
        &proof,
        &pub_inputs,
        &proof_options
    ));
}

#[test_log::test]
fn test_prove_quadratic() {
    let trace = quadratic_air::quadratic_trace(FE::from(3), 4);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = QuadraticPublicInputs { a0: FE::from(3) };

    let proof = prove::<F, QuadraticAIR<F>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F, QuadraticAIR<F>>(
        &proof,
        &pub_inputs,
        &proof_options
    ));
}

#[test_log::test]
fn test_prove_rap_fib() {
    let steps = 16;
    let trace = fibonacci_rap_trace([FE::from(1), FE::from(1)], steps);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciRAPPublicInputs {
        steps,
        a0: FE::one(),
        a1: FE::one(),
    };

    let proof = prove::<F, FibonacciRAP<F>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F, FibonacciRAP<F>>(
        &proof,
        &pub_inputs,
        &proof_options
    ));
}

#[test_log::test]
fn test_prove_dummy() {
    let trace_length = 16;
    let trace = dummy_air::dummy_trace(trace_length);

    let proof_options = ProofOptions::default_test_options();

    let proof = prove::<F, DummyAIR>(&trace, &(), &proof_options).unwrap();
    assert!(verify::<F, DummyAIR>(&proof, &(), &proof_options));
}
