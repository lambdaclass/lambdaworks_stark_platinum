use lambdaworks_math::field::{fields::fft_friendly::stark_252_prime_field::Stark252PrimeField, element::FieldElement};

pub mod constraints;
pub mod context;
#[cfg(debug_assertions)]
pub mod debug;
pub mod domain;
pub mod example;
pub mod frame;
pub mod fri;
pub mod grinding;
pub mod proof;
pub mod prover;
pub mod trace;
pub mod traits;
pub mod transcript;
pub mod utils;
pub mod verifier;

/// Configurations of the Prover available in compile time
pub mod config;

pub type PrimeField = Stark252PrimeField;
pub type FE = FieldElement<PrimeField>;
