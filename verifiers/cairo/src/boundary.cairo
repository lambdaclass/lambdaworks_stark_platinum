use debug::PrintTrait;
use array::ArrayDefault;
use array::{Span, ArrayTrait, SpanTrait, ArrayDrop};
use cairo_verifier::structs::{STARKProof, CairoAIR, PublicInputs, Domain};
use cairo_verifier::structs::{Challenges, RAPChallenges, DoubleFelt252Array};

use cairo_verifier::utils::{
    verify_bit_representation, powfelt_square_mul, mul_binomial_by_binomial, evaluate,
    interpolate_two_points
};

use integer::{u256, u128, u64, u32};
use traits::{Into, TryInto};
use option::OptionTrait;
use box::BoxTrait;

const BUILTIN_OFFSET: u32 = 9;

const MEM_P_TRACE_OFFSET: u32 = 17;
const MEM_A_TRACE_OFFSET: u32 = 19;
const RANGE_CHECK_COL_1: u32 = 43;
const RANGE_CHECK_COL_3: u32 = 45;
const PERMUTATION_ARGUMENT_COL_3: u32 = 57;
const PERMUTATION_ARGUMENT_RANGE_CHECK_COL_3: u32 = 60;


#[derive(Drop)]
struct BoundaryConstraint {
    col: u32,
    step: u64,
    value: felt252,
    root_of_unity: felt252, // ==  pow(trace_primitive_root, step)
}


fn get_boundary_constraints(
    air: @CairoAIR, rap_challenges: @RAPChallenges, trace_primitive_root: felt252
) -> Array<BoundaryConstraint> {
    let n_steps_min_one = *air.public_inputs.num_steps - 1;
    let final_index: u64 = (*air.trace_length - 1).try_into().unwrap();
    verify_bit_representation(n_steps_min_one, air.public_inputs.num_steps_min_one_binary);
    verify_bit_representation(final_index, air.trace_length_min_one_binary);
    let root_pow_n_steps = powfelt_square_mul(
        trace_primitive_root, air.public_inputs.num_steps_min_one_binary
    );
    let root_pow_final_index = powfelt_square_mul(
        trace_primitive_root, air.trace_length_min_one_binary
    );

    let initial_ap = BoundaryConstraint {
        col: MEM_P_TRACE_OFFSET, step: 0, value: *air.public_inputs.ap_init, root_of_unity: 1
    };
    let final_ap = BoundaryConstraint {
        col: MEM_P_TRACE_OFFSET,
        step: n_steps_min_one,
        value: *air.public_inputs.ap_final,
        root_of_unity: root_pow_n_steps
    };
    let initial_pc = BoundaryConstraint {
        col: MEM_A_TRACE_OFFSET, step: 0, value: *air.public_inputs.pc_init, root_of_unity: 1
    };
    let final_pc = BoundaryConstraint {
        col: MEM_A_TRACE_OFFSET,
        step: n_steps_min_one,
        value: *air.public_inputs.pc_final,
        root_of_unity: root_pow_n_steps
    };

    let range_check_min = BoundaryConstraint {
        col: RANGE_CHECK_COL_1, step: 0, value: *air.public_inputs.range_check_min, root_of_unity: 1
    };

    let range_check_max = BoundaryConstraint {
        col: RANGE_CHECK_COL_3,
        step: final_index,
        value: *air.public_inputs.range_check_max,
        root_of_unity: root_pow_final_index
    };

    // let builtin_offset = if *air.has_rc_builtin != 0 {
    //     0
    // } else {
    //     BUILTIN_OFFSET
    // };

    let mut cum_product: felt252 = 1;
    let mut counter = air.public_inputs.public_memory.len() - 1;
    let mut permutation_final: felt252 = 1;
    let z_memory = (*(rap_challenges.z_memory));
    let alpha_memory = (*(rap_challenges.alpha_memory));
    loop {
        let address = (*(air.public_inputs.public_memory.at(counter).address));
        let value = (*(air.public_inputs.public_memory.at(counter).value));
        if counter == 0 {
            cum_product *= z_memory - (address + alpha_memory * value);
            permutation_final *= (*(rap_challenges.z_memory));
            break;
        }

        cum_product *= z_memory - (address + alpha_memory * value);

        permutation_final *= (*(rap_challenges.z_memory));
        counter -= 1;
    };
    'cum_product'.print();
    cum_product.print();
    'permutation_final'.print();
    let permutation_final = felt252_div(permutation_final, cum_product.try_into().unwrap());
    permutation_final.print();

    let permutation_final_constraint = BoundaryConstraint {
        col: PERMUTATION_ARGUMENT_COL_3,
        step: final_index,
        value: permutation_final,
        root_of_unity: root_pow_final_index
    };

    let range_check_final_constraint = BoundaryConstraint {
        col: PERMUTATION_ARGUMENT_RANGE_CHECK_COL_3,
        step: final_index,
        value: 1,
        root_of_unity: root_pow_final_index
    };

    'root col 45'.print();
    root_pow_final_index.print();
    'root col 19'.print();
    root_pow_n_steps.print();

    let mut boundary_constraints = ArrayDefault::<BoundaryConstraint>::default();
    boundary_constraints.append(initial_ap);
    boundary_constraints.append(final_ap);
    boundary_constraints.append(initial_pc);
    boundary_constraints.append(final_pc);
    boundary_constraints.append(range_check_min);
    boundary_constraints.append(range_check_max);
    boundary_constraints.append(permutation_final_constraint);
    boundary_constraints.append(range_check_final_constraint);

    return boundary_constraints;
}

// returns a polynomial in the form [a_n, a_n-1, ..., a_0] where a_n is the coefficient of x^n. 
fn compute_zerofier_doublestep(
    constraints: @Array<BoundaryConstraint>, offset: u32
) -> Array<felt252> {
    let mut binomial_0 = ArrayDefault::<felt252>::default();
    binomial_0.append(1);
    let min_root_pow_steps = -(*constraints.at(offset).root_of_unity);
    binomial_0.append(min_root_pow_steps);
    // b(x) = x - primitive_root^step
    let mut binomial_1 = ArrayDefault::<felt252>::default();
    binomial_1.append(1);
    let min_root_pow_steps = -(*constraints.at(offset + 1).root_of_unity);

    binomial_1.append(min_root_pow_steps);
    let zerofier = mul_binomial_by_binomial(@binomial_0, @binomial_1);

    return zerofier;
}


fn compute_zerofier_singlestep(
    constraints: @Array<BoundaryConstraint>, offset: u32
) -> Array<felt252> {
    let mut zerofier = ArrayDefault::<felt252>::default();
    zerofier.append(1);
    let min_root_pow_steps = -(*constraints.at(offset).root_of_unity);
    zerofier.append(min_root_pow_steps);
    // zerofier(x) = x - primitive_root^step
    return zerofier;
}

// assumes BuiltinOffset = 0 ie, builtins are used.
fn compute_boundary_zerofier_challenges_z_num_den(
    constraints: @Array<BoundaryConstraint>, z: felt252, trace_evaluations: @Array<felt252>
) -> (@Array<felt252>, @Array<felt252>) {
    let mut num = ArrayDefault::<felt252>::default();
    let mut den = ArrayDefault::<felt252>::default();
    let mut counter = MEM_P_TRACE_OFFSET;
    let mut num_counter = 0;
    loop {
        if counter == 0 {
            break;
        }
        den.append(0x1); // 0..16
        num.append(*trace_evaluations.at(num_counter));

        counter -= 1;
        num_counter += 1;
    };
    let deno_0_poly = compute_zerofier_doublestep(constraints, 0);
    let deno_0 = evaluate(@deno_0_poly, z, deno_0_poly.len() - 1);
    let num_0_poly = interpolate_two_points(
        *constraints.at(0).root_of_unity,
        *constraints.at(0).value,
        *constraints.at(1).root_of_unity,
        *constraints.at(1).value
    );
    let num_0 = *trace_evaluations.at(num_counter) - evaluate(@num_0_poly, z, num_0_poly.len() - 1);
    den.append(felt252_div(1, deno_0.try_into().unwrap())); // 17 
    den.append(0x1); // 18

    num.append(num_0); // 17
    num_counter += 1;
    num.append(*trace_evaluations.at(num_counter)); // 18
    num_counter += 1;

    // let deno_1_poly = compute_zerofier_doublestep(constraints, 2);
    // let deno_1 = evaluate(@deno_1_poly, z, deno_1_poly.len() - 1);
    den.append(felt252_div(1, deno_0.try_into().unwrap())); // 19
    let num_1_poly = interpolate_two_points(
        *constraints.at(2).root_of_unity,
        *constraints.at(2).value,
        *constraints.at(3).root_of_unity,
        *constraints.at(3).value
    );
    let num_1 = *trace_evaluations.at(num_counter) - evaluate(@num_1_poly, z, num_1_poly.len() - 1);
    num.append(num_1); // 19
    num_counter += 1;
    let mut counter = RANGE_CHECK_COL_1 - MEM_A_TRACE_OFFSET - 1;
    loop {
        if counter == 0 {
            break;
        }
        den.append(0x1); // 20..42
        num.append(*trace_evaluations.at(num_counter)); // 20..42
        counter -= 1;
        num_counter += 1;
    };
    // assert(num_counter == 43, 'fucky');
    let deno_2_poly = compute_zerofier_singlestep(constraints, 4);
    let deno_2 = evaluate(@deno_2_poly, z, deno_2_poly.len() - 1);
    den.append(felt252_div(1, deno_2.try_into().unwrap())); // 43
    num.append(*trace_evaluations.at(num_counter) - *constraints.at(4).value); // 43
    num_counter += 1;
    den.append(0x1); // 44
    num.append(*trace_evaluations.at(num_counter)); // 44
    num_counter += 1;

    let deno_3_poly = compute_zerofier_singlestep(constraints, 5);
    let deno_3 = evaluate(@deno_3_poly, z, deno_3_poly.len() - 1);
    den.append(felt252_div(1, deno_3.try_into().unwrap())); // 45
    num.append(*trace_evaluations.at(num_counter) - *constraints.at(5).value); // 45
    num_counter += 1;
    let mut counter = PERMUTATION_ARGUMENT_COL_3 - RANGE_CHECK_COL_3 - 1;
    loop {
        if counter == 0 {
            break;
        }
        den.append(0x1); // 46..56
        num.append(*trace_evaluations.at(num_counter)); // 46..56
        num_counter += 1;
        counter -= 1;
    };
    // let deno_4_poly = compute_zerofier_singlestep(constraints, 6);
    // let deno_4 = evaluate(@deno_4_poly, z, deno_4_poly.len() - 1);

    den.append(felt252_div(1, deno_3.try_into().unwrap())); // 57
    num.append(*trace_evaluations.at(num_counter) - *constraints.at(6).value); // 57
    num_counter += 1;
    den.append(0x1); // 58
    num.append(*trace_evaluations.at(num_counter)); // 58
    num_counter += 1;
    den.append(0x1); // 59
    num.append(*trace_evaluations.at(num_counter)); // 59
    num_counter += 1;

    // let deno_5_poly = compute_zerofier_singlestep(constraints, 7);
    // let deno_5 = evaluate(@deno_5_poly, z, deno_5_poly.len() - 1);

    den.append(felt252_div(1, deno_3.try_into().unwrap())); // 60
    num.append(*trace_evaluations.at(num_counter) - *constraints.at(7).value); // 60
    num_counter.print();
    return (@num, @den);
}

