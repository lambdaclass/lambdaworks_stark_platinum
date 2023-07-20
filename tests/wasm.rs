use lambdaworks_stark::{
    cairo::{
        serialized::{PUBLIC_INPUTS, SERIALIZED_TEST_PROOF},
        wasm_wrappers::{deserialize_proof_wasm, verify_cairo_proof_wasm},
    },
    starks::proof::options::ProofOptions,
};
use wasm_bindgen_test::*;

wasm_bindgen_test_configure!(run_in_browser);

#[wasm_bindgen_test]
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
