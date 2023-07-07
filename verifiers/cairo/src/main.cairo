use debug::PrintTrait;
use array::ArrayDefault;
use array::{Span, ArrayTrait, SpanTrait, ArrayDrop};
use cairo_verifier::structs::{STARKProof, CairoAIR, PublicInputs, Domain};
use cairo_verifier::structs::{Challenges, RAPChallenges, DoubleFelt252Array};
use cairo_verifier::sample_proof::{get_sample_proof, get_sample_cairo_air, };
use cairo_verifier::utils::{
    pow128, powfelt, lookup, verify_trailing_zeros, is_val_in_array,
    get_powers_of_primitive_root_coset, get_primitive_root_of_unity, count_trailing_zeros,
    u64_byte_reverse
};
use cairo_verifier::air::{
    compute_instr_constraints, compute_operand_constraints, compute_register_constraints,
    compute_opcode_constraints, permutation_argument, memory_is_increasing,
    permutation_argument_range_check, range_check_builtin
};
use cairo_verifier::boundary::{
    get_boundary_constraints, BoundaryConstraint, compute_boundary_zerofier_challenges_z_num_den,
};

use integer::{u256, u128, u64, u32};
use keccak::{add_padding, keccak_add_u256_be, u128_split};
use starknet::SyscallResultTrait;
use traits::{Into, TryInto, DivRem};
use zeroable::{NonZero};
use option::OptionTrait;
use box::BoxTrait;


const MASK: u128 = 0x7ffffffffffffffffffffffffffffff; // 
const SHIFT: felt252 = 0x100000000000000000000000000000000;
const TWO_ADICITY: u128 = 48;
const TWO_ADIC_PRIMITVE_ROOT_OF_UNITY: felt252 =
    0x30a2e815081f7d927f73df497923b55d38dbf3801c203cee2bf6c4b68bc148c;

// TWO_ADIC_PRIMITVE_ROOT_OF_UNITY^(2^TWO_ADICITY) = 1

fn main() {
    'Hello, world444!'.print();
    let proof: STARKProof = get_sample_proof();
    let air: CairoAIR = get_sample_cairo_air();
    let domain: Domain = generate_domain(@air);
    let step1_challenges: Challenges = step_1_replay_rounds_and_recover_challenges(
        @air, @proof, @domain
    );
    let step2_ok = step_2_verify_claimed_position_polynomial(
        @air, @proof, @domain, @step1_challenges
    );

    assert(step2_ok == 1, 'Verification Failed at step2');
}


fn step_2_verify_claimed_position_polynomial(
    air: @CairoAIR, proof: @STARKProof, domain: @Domain, challenges: @Challenges, 
) -> felt252 {
    let composition_poly_even_ood_evaluation = *proof.composition_poly_even_ood_evaluation;
    let composition_poly_odd_ood_evaluation = *proof.composition_poly_odd_ood_evaluation;
    let z = *challenges.z;
    let boundary_constraints: Array<BoundaryConstraint> = get_boundary_constraints(
        air, challenges.rap_challenges, *domain.trace_primitive_root
    );

    let n_trace_cols: u32 = (*air.context.trace_columns).try_into().unwrap();
    let trace_length = *air.trace_length;
    let composition_poly_degree_bound = 2 * (trace_length);
    let boundary_term_degree_adjustment = composition_poly_degree_bound - trace_length;

    let (boundary_c_i_evaluations_num, boundary_c_i_evaluations_den) =
        compute_boundary_zerofier_challenges_z_num_den(
        @boundary_constraints, *challenges.z, proof.trace_ood_frame_evaluations.data
    );

    // print den
    let mut counter = 0;
    'num'.print();
    assert(boundary_c_i_evaluations_den.len() == boundary_c_i_evaluations_num.len(), 'err');
    assert(
        boundary_c_i_evaluations_den.len() == (*air.context.trace_columns).try_into().unwrap(),
        'err'
    );
    loop {
        if counter == boundary_c_i_evaluations_num.len() {
            break;
        }
        // 'counter'.print();
        // counter.print();
        (*boundary_c_i_evaluations_num.at(counter)).print();
        counter += 1;
    };

    'den'.print();
    counter = 0;
    loop {
        if counter == boundary_c_i_evaluations_den.len() {
            break;
        }
        // 'counter'.print();
        // counter.print();
        (*boundary_c_i_evaluations_den.at(counter)).print();
        counter += 1;
    };

    let mut boundary_quotient_odd_evaluation = 0;
    let z_pow_boundary_term_adjustment = powfelt(z, boundary_term_degree_adjustment.into());
    let mut counter: u32 = (*air.context.trace_columns - 1).try_into().unwrap();
    loop {
        if counter == 0 {
            let num = *(boundary_c_i_evaluations_num.at(counter));
            let den = *boundary_c_i_evaluations_den.at(counter);
            let alpha = *challenges.boundary_coeffs.a.at(counter);
            let beta = *challenges.boundary_coeffs.b.at(counter);

            boundary_quotient_odd_evaluation += num
                * den
                * (alpha * z_pow_boundary_term_adjustment + beta);

            break;
        }
        let num = *(boundary_c_i_evaluations_num.at(counter));
        let den = *boundary_c_i_evaluations_den.at(counter);
        let alpha = *challenges.boundary_coeffs.a.at(counter);
        let beta = *challenges.boundary_coeffs.b.at(counter);

        boundary_quotient_odd_evaluation += num
            * den
            * (alpha * z_pow_boundary_term_adjustment + beta);
        counter -= 1;
    };
    'boundary_eval'.print();
    boundary_quotient_odd_evaluation.print();

    let mut constraints = ArrayDefault::<felt252>::default();
    compute_instr_constraints(ref constraints, proof.trace_ood_frame_evaluations.data);
    compute_operand_constraints(ref constraints, proof.trace_ood_frame_evaluations.data);
    compute_register_constraints(
        ref constraints,
        proof.trace_ood_frame_evaluations.data,
        *proof.trace_ood_frame_evaluations.row_width
    );
    compute_opcode_constraints(ref constraints, proof.trace_ood_frame_evaluations.data);
    'constraints_len_opcode'.print();
    constraints.len().print();
    memory_is_increasing(
        ref constraints,
        proof.trace_ood_frame_evaluations.data,
        *proof.trace_ood_frame_evaluations.row_width
    );
    permutation_argument(
        ref constraints,
        proof.trace_ood_frame_evaluations.data,
        challenges.rap_challenges,
        *proof.trace_ood_frame_evaluations.row_width
    );
    permutation_argument_range_check(
        ref constraints,
        proof.trace_ood_frame_evaluations.data,
        challenges.rap_challenges,
        *proof.trace_ood_frame_evaluations.row_width
    );
    range_check_builtin(ref constraints, proof.trace_ood_frame_evaluations.data);
    // print constraints loop : 
    'constraints_len_fin'.print();
    constraints.len().print();
    let mut counter = 0;
    'constraints'.print();
    loop {
        if counter == constraints.len() {
            break;
        }
        counter.print();
        (*constraints.at(counter)).print();
        counter += 1;
    };

    let divisor_x_n = felt252_div(1, (powfelt(z, trace_length.into()) - 1).try_into().unwrap());
    'divisor_x_n'.print();
    divisor_x_n.print();

    return 1;
}

fn generate_domain(air: @CairoAIR) -> Domain {
    let blowup_factor = pow128(2, *air.context.options.blowup_factor_pow);
    let coset_offset = *air.context.options.coset_offset;
    let interpolation_domain_size = *air.trace_length;
    let root_order = *air.root_order;
    let check = verify_trailing_zeros(interpolation_domain_size, root_order);
    assert(check == 1, 'Wrong');
    let trace_primitive_root = get_primitive_root_of_unity(root_order);
    let trace_roots_of_unity = get_powers_of_primitive_root_coset(
        root_order.into(), interpolation_domain_size.into(), 1
    );

    // 'root_order'.print();
    // root_order.print();
    // 'lde_root_order'.print();

    let lde_root_order = root_order + (*air.context.options.blowup_factor_pow);
    lde_root_order.print();

    let lde_roots_of_unity_coset = get_powers_of_primitive_root_coset(
        lde_root_order.into(), (interpolation_domain_size * blowup_factor).into(), coset_offset
    );
    return Domain {
        root_order: root_order,
        lde_roots_of_unity_coset: lde_roots_of_unity_coset,
        lde_root_order: lde_root_order,
        trace_primitive_root: trace_primitive_root,
        trace_roots_of_unity: trace_roots_of_unity,
        blowup_factor: blowup_factor,
        coset_offset: coset_offset,
        interpolation_domain_size: interpolation_domain_size,
    };
}


fn step_1_replay_rounds_and_recover_challenges(
    air: @CairoAIR, proof: @STARKProof, domain: @Domain
) -> Challenges {
    // ===================================
    // ==========|   Round 1   |==========
    // ===================================
    // Build RAP Challenges
    // alpha_memory
    let hash_alpha_memory = starknet::syscalls::keccak_syscall(
        proof.lde_trace_merkle_roots.at(0).span()
    )
        .unwrap_syscall();
    // hash_alpha_memory.print();
    let alpha_memory: felt252 = (hash_alpha_memory.high & MASK).into() * SHIFT
        + hash_alpha_memory.low.into();
    'alpha_memory'.print();
    alpha_memory.print();

    // z_memory

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, hash_alpha_memory);
    add_padding(ref keccak_input, 0, 0);
    let hash_z_memory = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
    let z_memory: felt252 = (hash_z_memory.high & MASK).into() * SHIFT + hash_z_memory.low.into();
    'z_memory'.print();
    z_memory.print();

    // z_range_check
    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, hash_z_memory);
    add_padding(ref keccak_input, 0, 0);
    let hash_z_range_check = starknet::syscalls::keccak_syscall(keccak_input.span())
        .unwrap_syscall();
    let z_range_check: felt252 = (hash_z_range_check.high & MASK).into() * SHIFT
        + hash_z_range_check.low.into();
    'z_range_check'.print();
    z_range_check.print();
    let rap_challenges = RAPChallenges {
        alpha_memory: alpha_memory, z_memory: z_memory, z_range_check: z_range_check
    };

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, hash_z_range_check);

    match proof.lde_trace_merkle_roots.get(1) {
        Option::Some(x) => {
            let y = x.unbox();
            keccak_input.append(*y[0]);
            keccak_input.append(*y[1]);
            keccak_input.append(*y[2]);
            keccak_input.append(*y[3]);
            keccak_input.len().print();
        },
        Option::None(_) => {}
    }
    keccak_input.len().print();
    add_padding(ref keccak_input, 0, 0);

    // ===================================
    // ==========|   Round 2   |==========
    // ===================================
    // These are the challenges alpha^B_j and beta^B_j
    // >>>> Send challenges: 𝛼_j^B
    let mut boundary_coeffs_alphas = ArrayDefault::<felt252>::default();
    let counter = *air.context.trace_columns;
    'bound_alphas'.print();
    let last_hash: u256 = transcript_hash_loop(
        ref keccak_input, counter - 1, ref boundary_coeffs_alphas
    );
    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, last_hash);
    add_padding(ref keccak_input, 0, 0);

    // // >>>> Send  challenges: 𝛽_j^B
    'bound_betas'.print();
    let mut boundary_coeffs_betas = ArrayDefault::<felt252>::default();
    // let mut counter = air.context.trace_columns;
    let last_hash: u256 = transcript_hash_loop(
        ref keccak_input, counter - 1, ref boundary_coeffs_betas
    );
    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, last_hash);
    add_padding(ref keccak_input, 0, 0);

    // // // >>>> Send challenges: 𝛼_j^T
    'trans_alphas'.print();
    let mut transition_coeffs_alphas = ArrayDefault::<felt252>::default();
    let mut counter = *air.context.num_transition_constraints;
    let last_hash: u256 = transcript_hash_loop(
        ref keccak_input, counter - 1, ref transition_coeffs_alphas
    );
    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, last_hash);
    add_padding(ref keccak_input, 0, 0);

    // // >>>> Send challenges: 𝛽_j^T
    'trans_betas'.print();
    let mut transition_coeffs_betas = ArrayDefault::<felt252>::default();
    let mut counter = *air.context.num_transition_constraints;
    let last_hash: u256 = transcript_hash_loop(
        ref keccak_input, counter - 1, ref transition_coeffs_betas
    );

    let boundary_coeffs = DoubleFelt252Array {
        a: boundary_coeffs_alphas, b: boundary_coeffs_betas
    };

    let transition_coeffs = DoubleFelt252Array {
        a: transition_coeffs_alphas, b: transition_coeffs_betas
    };

    // <<<< Receive commitments: [H₁], [H₂]

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, last_hash);
    keccak_add_u256_be(ref keccak_input, *proof.composition_poly_root);
    add_padding(ref keccak_input, 0, 0);

    // ===================================
    // ==========|   Round 3   |==========
    // ===================================

    // >>>> Send challenge: z
    let (z, hash) = sample_ooz(
        ref keccak_input, domain.lde_roots_of_unity_coset, domain.trace_roots_of_unity
    );
    'z'.print();
    z.print();

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, hash);

    // <<<< Receive value: H₁(z²)
    keccak_add_u256_be(ref keccak_input, (*proof.composition_poly_even_ood_evaluation).into());
    // <<<< Receive value: H₂(z²)
    keccak_add_u256_be(ref keccak_input, (*proof.composition_poly_odd_ood_evaluation).into());
    // <<<< Receive values: tⱼ(zgᵏ)

    let mut counter = 0;
    let len = proof.trace_ood_frame_evaluations.data.len();
    loop {
        if counter == len {
            break;
        }
        keccak_add_u256_be(
            ref keccak_input, (*(proof.trace_ood_frame_evaluations.data.at(counter))).into()
        );
        counter += 1;
    };

    add_padding(ref keccak_input, 0, 0);

    // ===================================
    // ==========|   Round 4   |==========
    // ===================================

    // >>>> Send challenges: 𝛾, 𝛾'
    let gamma_even_hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
    let gamma_even: felt252 = (gamma_even_hash.high & MASK).into() * SHIFT
        + gamma_even_hash.low.into();
    'gamma_even'.print();
    gamma_even.print();

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, gamma_even_hash);
    add_padding(ref keccak_input, 0, 0);

    let gamma_odd_hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
    let gamma_odd: felt252 = (gamma_odd_hash.high & MASK).into() * SHIFT
        + gamma_odd_hash.low.into();
    'gamma_odd'.print();
    gamma_odd.print();

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, gamma_odd_hash);
    add_padding(ref keccak_input, 0, 0);

    // >>>> Send challenges: 𝛾ⱼ, 𝛾ⱼ'
    let mut trace_term_coeffs = ArrayDefault::<Array<felt252>>::default();
    let mut counter = *air.context.trace_columns;

    let last_hash: u256 = transcript_hash_double_loop(
        ref keccak_input,
        counter - 1,
        air.context.transition_offsets.len().into() - 1,
        ref trace_term_coeffs
    );

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, last_hash);

    // FRI commit phase
    'zetas'.print();
    let mut zetas = ArrayDefault::<felt252>::default();

    let hash = transcript_receive_and_hash_loop(
        ref keccak_input,
        0,
        proof.fri_layers_merkle_roots.len() - 1,
        proof.fri_layers_merkle_roots,
        ref zetas
    );

    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, hash);
    // <<<< Receive value: pₙ
    keccak_add_u256_be(ref keccak_input, (*proof.fri_last_value).into());
    add_padding(ref keccak_input, 0, 0);

    // Receive grinding value
    let transcript_challenge = starknet::syscalls::keccak_syscall(keccak_input.span())
        .unwrap_syscall();
    'transcript_challenge'.print();
    transcript_challenge.print();
    let mut keccak_input: Array::<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, transcript_challenge);
    // TODO : check with non-1 nonce if needs reverse endian. 
    keccak_input.append(*proof.nonce);
    add_padding(ref keccak_input, 0, 0);
    let digest = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
    // TODO : split_128 THEN reverse. Safer in extremely edgy cases. 
    let digest_low_reverse = integer::u128_byte_reverse(digest.low);
    let (seed_head, _) = u128_split(digest_low_reverse);
    'seed_head'.print();
    seed_head.print();
    let leading_zeros_count = count_trailing_zeros(seed_head, 0);
    'leading_zeros_count'.print();
    leading_zeros_count.print();
    // FRI query phase
    // TODO : improve this when https://github.com/lambdaclass/lambdaworks_cairo_prover/issues/100 is merged
    let mut iotas = ArrayDefault::<u64>::default();
    let modulus: u64 = (pow128(2, *domain.lde_root_order)).try_into().unwrap();
    let mut keccak_input: Array<u64> = Default::default();
    keccak_add_u256_be(ref keccak_input, transcript_challenge);
    // TODO : change mocked value (int.from_bytes((1).to_bytes(8, "little"), "big")) to nonce.reverse_endian64. 
    keccak_input.append(72057594037927936);
    add_padding(ref keccak_input, 0, 0);

    'modulus'.print();
    modulus.print();
    build_iotas(
        ref keccak_input, (*air.context.options.fri_number_of_queries) - 1, modulus, ref iotas
    );

    return Challenges {
        z: z,
        boundary_coeffs,
        transition_coeffs,
        trace_term_coeffs: trace_term_coeffs,
        gamma_even: gamma_even,
        gamma_odd: gamma_odd,
        zetas: zetas,
        iotas: iotas,
        rap_challenges: rap_challenges,
        leading_zeros_count: leading_zeros_count,
    };
}

fn build_iotas(ref keccak_input: Array<u64>, counter: u32, modulus: u64, ref values: Array<u64>) {
    if counter == 0 {
        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let (value, _) = u128_split(hash.high);
        let value = value % modulus;

        values.append(value);
        value.print();
        return ();
    } else {
        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let (value, _) = u128_split(hash.high);
        let value = value % modulus;
        values.append(value);
        'iota'.print();
        value.print();
        let mut keccak_input: Array::<u64> = Default::default();
        keccak_add_u256_be(ref keccak_input, hash);
        add_padding(ref keccak_input, 0, 0);
        return build_iotas(ref keccak_input, counter - 1, modulus, ref values);
    }
}

fn transcript_receive_and_hash_loop(
    ref keccak_input: Array<u64>,
    counter: u32,
    len: u32,
    commitments: @Array<u256>,
    ref values: Array<felt252>
) -> u256 {
    if counter == len {
        keccak_add_u256_be(ref keccak_input, *(commitments.at(counter)));
        add_padding(ref keccak_input, 0, 0);

        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let value: felt252 = (hash.high & MASK).into() * SHIFT + hash.low.into();
        values.append(value);
        value.print();
        return hash;
    } else {
        // 'commit_counter'.print();
        // counter.print();
        keccak_add_u256_be(ref keccak_input, *(commitments.at(counter)));
        add_padding(ref keccak_input, 0, 0);
        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let value: felt252 = (hash.high & MASK).into() * SHIFT + hash.low.into();
        // values.append(value);
        // value.print();
        let mut keccak_input: Array::<u64> = Default::default();
        keccak_add_u256_be(ref keccak_input, hash);
        return transcript_receive_and_hash_loop(
            ref keccak_input, counter + 1, len, commitments, ref values
        );
    }
}


fn sample_ooz(
    ref keccak_input: Array<u64>,
    lde_roots_of_unity_coset: @Array<felt252>,
    trace_roots_of_unity: @Array<felt252>
) -> (felt252, u256) {
    let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
    let value: felt252 = (hash.high & MASK).into() * SHIFT + hash.low.into();

    let is_in_lde_roots_of_unity_coset = is_val_in_array(
        value, lde_roots_of_unity_coset, lde_roots_of_unity_coset.len() - 1
    );
    let is_in_trace_roots_of_unity = is_val_in_array(
        value, trace_roots_of_unity, trace_roots_of_unity.len() - 1
    );
    let check = is_in_lde_roots_of_unity_coset + is_in_trace_roots_of_unity;
    if check == 0 {
        return (value, hash);
    } else {
        let mut keccak_input: Array::<u64> = Default::default();
        keccak_add_u256_be(ref keccak_input, hash);
        add_padding(ref keccak_input, 0, 0);
        return sample_ooz(ref keccak_input, lde_roots_of_unity_coset, trace_roots_of_unity);
    }
}


fn transcript_hash_loop(
    ref keccak_input: Array<u64>, counter: u64, ref values: Array<felt252>
) -> u256 {
    if counter == 0 {
        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let value: felt252 = (hash.high & MASK).into() * SHIFT + hash.low.into();
        values.append(value);
        // value.print();
        return hash;
    } else {
        let hash = starknet::syscalls::keccak_syscall(keccak_input.span()).unwrap_syscall();
        let value: felt252 = (hash.high & MASK).into() * SHIFT + hash.low.into();
        values.append(value);
        // value.print();
        let mut keccak_input: Array::<u64> = Default::default();
        keccak_add_u256_be(ref keccak_input, hash);
        add_padding(ref keccak_input, 0, 0);
        return transcript_hash_loop(ref keccak_input, counter - 1, ref values);
    }
}


fn transcript_hash_double_loop(
    ref keccak_input: Array<u64>, counter: u64, inner_len: u64, ref values: Array<Array<felt252>>
) -> u256 {
    if counter == 0 {
        let mut current_values = ArrayDefault::<felt252>::default();
        let last_hash: u256 = transcript_hash_loop(ref keccak_input, inner_len, ref current_values);
        values.append(current_values);
        return last_hash;
    } else {
        let mut current_values = ArrayDefault::<felt252>::default();
        let last_hash: u256 = transcript_hash_loop(ref keccak_input, inner_len, ref current_values);
        // 'counter'.print();
        // counter.print();
        values.append(current_values);
        let mut keccak_input: Array::<u64> = Default::default();
        keccak_add_u256_be(ref keccak_input, last_hash);
        add_padding(ref keccak_input, 0, 0);
        return transcript_hash_double_loop(ref keccak_input, counter - 1, inner_len, ref values);
    }
}

