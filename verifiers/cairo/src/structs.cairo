use array::ArrayTrait;
use debug::PrintTrait;
use array::ArrayDefault;
use integer::{u256, u64};

#[derive(Drop)]
struct STARKProof {
    lde_trace_merkle_roots: Array<Array<u64>>,
    trace_ood_frame_evaluations: Frame,
    composition_poly_root: u256,
    composition_poly_even_ood_evaluation: felt252,
    composition_poly_odd_ood_evaluation: felt252,
    fri_layers_merkle_roots: Array<u256>,
    fri_last_value: felt252,
    query_list: Array<FriDecommitment>,
    deep_poly_openings: Array<DeepPolynomialOpening>,
    nonce: u64
}

#[derive(Drop)]
struct FriDecommitment {
    layers_auth_paths_sym: Array<Array<u256>>,
    layers_evaluations_sym: Array<felt252>,
    layers_auth_paths: Array<Array<u256>>,
    layers_evaluations: Array<felt252>,
}

#[derive(Drop)]
struct Frame {
    data: Array<felt252>,
    row_width: u32,
}

#[derive(Drop)]
struct DeepPolynomialOpening {
    lde_composition_poly_proof: Array<u256>,
    lde_composition_poly_even_evaluation: felt252,
    lde_composition_poly_odd_evaluation: felt252,
    lde_trace_merkle_proofs: Array<Array<u256>>,
    lde_trace_evaluations: Array<felt252>,
}

#[derive(Drop)]
struct CairoAIR {
    context: AirContext,
    trace_length: u128,
    trace_length_min_one_binary: Array<u64>,
    root_order: u128, // == trace_length.trailing_zeros()
    public_inputs: PublicInputs,
    has_rc_builtin: felt252,
}

#[derive(Drop)]
struct AirContext {
    options: ProofOptions,
    trace_columns: u64,
    transition_degrees: Array<felt252>,
    transition_offsets: Array<felt252>,
    transition_exemptions: Array<felt252>,
    num_transition_constraints: u64,
}

#[derive(Drop)]
struct ProofOptions {
    blowup_factor_pow: u128, // blowup_factor = 2^blowup_factor_pow
    fri_number_of_queries: u32,
    coset_offset: felt252,
}

#[derive(Drop)]
struct Domain {
    root_order: u128,
    lde_roots_of_unity_coset: Array<felt252>,
    lde_root_order: u128,
    trace_primitive_root: felt252,
    trace_roots_of_unity: Array<felt252>,
    coset_offset: felt252,
    blowup_factor: u128,
    interpolation_domain_size: u128,
}

#[derive(Drop)]
struct PublicInputs {
    pc_init: felt252,
    ap_init: felt252,
    fp_init: felt252,
    pc_final: felt252,
    ap_final: felt252,
    range_check_min: felt252,
    range_check_max: felt252,
    memory_segments: MemorySegments,
    public_memory: Array<MemoryCell>, // address / value 
    num_steps: u64,
    num_steps_min_one_binary: Array<u64>,
}

#[derive(Drop)]
struct MemoryCell {
    address: felt252,
    value: felt252,
}

#[derive(Drop)]
struct Range {
    start: u64,
    end: u64,
}

#[derive(Drop)]
struct MemorySegments {
    range_check: Range,
    output: Range,
}

#[derive(Drop)]
struct RAPChallenges {
    alpha_memory: felt252,
    z_memory: felt252,
    z_range_check: felt252,
}

#[derive(Drop)]
struct DoubleFelt252Array {
    a: Array<felt252>,
    b: Array<felt252>,
}

#[derive(Drop)]
struct Challenges {
    z: felt252,
    boundary_coeffs: DoubleFelt252Array,
    transition_coeffs: DoubleFelt252Array,
    trace_term_coeffs: Array<Array<felt252>>,
    gamma_even: felt252,
    gamma_odd: felt252,
    zetas: Array<felt252>,
    iotas: Array<u64>,
    rap_challenges: RAPChallenges,
    leading_zeros_count: felt252,
}

