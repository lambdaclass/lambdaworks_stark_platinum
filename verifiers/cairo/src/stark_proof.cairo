use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
// use cairo_verifier::sample_proof;

#[derive(Drop)]
struct STARKProof {
    lde_trace_merkle_roots: Array<felt252>,
    trace_ood_frame_evaluations: Frame,
    composition_poly_even_root: felt252,
    composition_poly_even_ood_evaluation: felt252,
    composition_poly_odd_root: felt252,
    composition_poly_odd_ood_evaluation: felt252,
    fri_layers_merkle_roots: Array<felt252>,
    fri_last_value: felt252,
    query_list: Array<FriDecommitment>,
    deep_poly_openings: DeepPolynomialOpenings
}

#[derive(Drop)]
struct FriDecommitment {
    layers_auth_paths_sym: Array<Array<felt252>>,
    layers_evaluations_sym: Array<felt252>,
    first_layer_evaluation: felt252,
    first_layer_auth_path: Array<felt252>,
}

#[derive(Drop)]
struct Frame {
    data: Array<felt252>,
    row_width: felt252,
}

#[derive(Drop)]
struct DeepPolynomialOpenings {
    lde_composition_poly_even_proof: Array<felt252>,
    lde_composition_poly_even_evaluation: felt252,
    lde_composition_poly_odd_proof: Array<felt252>,
    lde_composition_poly_odd_evaluation: felt252,
    lde_trace_merkle_proofs: Array<Array<felt252>>,
    lde_trace_evaluations: Array<felt252>,
}
