use super::air::{CairoAIR, PublicInputs};
use crate::cairo::air::MemorySegment;
use crate::starks::{
    proof::{options::ProofOptions, stark::StarkProof},
    verifier::verify,
};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use lambdaworks_math::traits::Deserializable;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::ops::Range;
use wasm_bindgen::prelude::wasm_bindgen;

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
    pub_input_serialized: &[u8],
    proof_options: &ProofOptions,
) -> bool {
    let pub_input: PublicInputs = Deserializable::deserialize(pub_input_serialized).unwrap();
    verify::<Stark252PrimeField, CairoAIR>(&proof.0, &pub_input, proof_options)
}

#[wasm_bindgen]
pub fn deserialize_proof_wasm(proof: &[u8]) -> Stark252PrimeFieldProof {
    let proof_inner: StarkProof<Stark252PrimeField> = Deserializable::deserialize(proof).unwrap();

    Stark252PrimeFieldProof(proof_inner)
}

#[cfg(test)]
mod tests {
    use super::super::serialized_proof::{PUBLIC_INPUTS, SERIALIZED_TEST_PROOF};
    use super::{deserialize_proof_wasm, verify_cairo_proof_wasm};
    use crate::starks::proof::options::ProofOptions;

    #[test]
    fn test_prove_cairo1_program_wasm() {
        let proof = deserialize_proof_wasm(&SERIALIZED_TEST_PROOF);
        let proof_options = ProofOptions::default_test_options();
        assert!(verify_cairo_proof_wasm(
            &proof,
            &PUBLIC_INPUTS,
            &proof_options
        ));
    }
}
