use super::air::{CairoAIR, PublicInputs};
use crate::cairo::air::MemorySegment;
use crate::starks::{
    proof::{options::ProofOptions, stark::StarkProof},
    verifier::verify,
};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::ops::Range;
use wasm_bindgen::prelude::wasm_bindgen;
use wasm_bindgen::JsValue;

#[wasm_bindgen]
pub struct Stark252PrimeFieldProof(StarkProof<Stark252PrimeField>);

#[wasm_bindgen]
#[derive(Debug, Clone, Copy, Serialize, Deserialize, Eq, PartialEq, Hash)]
pub struct FE(FieldElement<Stark252PrimeField>);

#[wasm_bindgen]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MemorySegmentMap(HashMap<MemorySegment, Range<u64>>);

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MemoryMap(HashMap<FE, FE>);

#[wasm_bindgen]
pub fn verify_cairo_proof_wasm(
    proof: &Stark252PrimeFieldProof,
    pub_input_val: JsValue,
    proof_options: &ProofOptions,
) -> bool {
    let pub_input: PublicInputs = serde_wasm_bindgen::from_value(pub_input_val).unwrap();
    verify::<Stark252PrimeField, CairoAIR>(&proof.0, &pub_input, proof_options)
}
