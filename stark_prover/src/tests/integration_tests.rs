use lambdaworks_math::field::fields::{
    fft_friendly::stark_252_prime_field::Stark252PrimeField,
    u64_prime_field::{F17, FE17},
};

use crate::{
    examples::{
        fibonacci_2_columns::{self, Fibonacci2ColsAIR},
        quadratic_air::{self, QuadraticAIR, QuadraticPublicInputs},
        simple_fibonacci::{self, FibonacciAIR, FibonacciPublicInputs},
    },
    proof::options::ProofOptions,
    prover::prove,
    verifier::verify,
    Felt252,
};

#[test_log::test]
fn test_prove_fib() {
    let trace = simple_fibonacci::fibonacci_trace([Felt252::from(1), Felt252::from(1)], 8);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciPublicInputs {
        a0: Felt252::one(),
        a1: Felt252::one(),
    };

    let proof = prove::<Stark252PrimeField, FibonacciAIR<Stark252PrimeField>>(
        &trace,
        &pub_inputs,
        &proof_options,
    )
    .unwrap();
    assert!(
        verify::<Stark252PrimeField, FibonacciAIR<Stark252PrimeField>>(
            &proof,
            &pub_inputs,
            &proof_options
        )
    );
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
    let trace =
        fibonacci_2_columns::fibonacci_trace_2_columns([Felt252::from(1), Felt252::from(1)], 16);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciPublicInputs {
        a0: Felt252::one(),
        a1: Felt252::one(),
    };

    let proof = prove::<Stark252PrimeField, Fibonacci2ColsAIR<Stark252PrimeField>>(
        &trace,
        &pub_inputs,
        &proof_options,
    )
    .unwrap();
    assert!(verify::<
        Stark252PrimeField,
        Fibonacci2ColsAIR<Stark252PrimeField>,
    >(&proof, &pub_inputs, &proof_options));
}

#[test_log::test]
fn test_prove_quadratic() {
    let trace = quadratic_air::quadratic_trace(Felt252::from(3), 4);

    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = QuadraticPublicInputs {
        a0: Felt252::from(3),
    };

    let proof = prove::<Stark252PrimeField, QuadraticAIR<Stark252PrimeField>>(
        &trace,
        &pub_inputs,
        &proof_options,
    )
    .unwrap();
    assert!(
        verify::<Stark252PrimeField, QuadraticAIR<Stark252PrimeField>>(
            &proof,
            &pub_inputs,
            &proof_options
        )
    );
}
