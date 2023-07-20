use debug::PrintTrait;
use array::ArrayDefault;
use array::{Span, ArrayTrait, SpanTrait, ArrayDrop};
use cairo_verifier::structs::{STARKProof, CairoAIR, PublicInputs, Domain, Frame};
use cairo_verifier::structs::{Challenges, RAPChallenges, DoubleFelt252Array};

use cairo_verifier::utils::{
    verify_bit_representation, powfelt_square_mul, mul_binomial_by_binomial, evaluate,
    interpolate_two_points, get_pow2_arrayf
};

use integer::{u256, u128, u64, u32};
use traits::{Into, TryInto};
use option::OptionTrait;
use box::BoxTrait;

const BUILTIN_OFFSET: u32 = 9;

const MEM_P_TRACE_OFFSET: u32 = 17;
const MEM_A_TRACE_OFFSET: u32 = 19;
const RANGE_CHECK_COL_1: u32 = 43;
const RANGE_CHECK_COL_2: u32 = 44;
const RANGE_CHECK_COL_3: u32 = 45;
const INST: u32 = 16;

// Range-check frame identifiers
const RC_0: u32 = 34;
const RC_1: u32 = 35;
const RC_2: u32 = 36;
const RC_3: u32 = 37;
const RC_4: u32 = 38;
const RC_5: u32 = 39;
const RC_6: u32 = 40;
const RC_7: u32 = 41;
const RC_VALUE: u32 = 42;
// Frame row identifiers 
// - flags 
const F_DST_FP: u32 = 0;
const F_OP_0_FP: u32 = 1;
const F_OP_1_VAL: u32 = 2;
const F_OP_1_FP: u32 = 3;
const F_OP_1_AP: u32 = 4;
const F_RES_ADD: u32 = 5;
const F_RES_MUL: u32 = 6;
const F_PC_ABS: u32 = 7;
const F_PC_REL: u32 = 8;
const F_PC_JNZ: u32 = 9;
const F_AP_ADD: u32 = 10;
const F_AP_ONE: u32 = 11;
const F_OPC_CALL: u32 = 12;
const F_OPC_RET: u32 = 13;
const F_OPC_AEQ: u32 = 14;

const FRAME_RES: u32 = 16;
const DST_ADDR: u32 = 17;
const FRAME_AP: u32 = 17;
const FRAME_FP: u32 = 18;
const FRAME_PC: u32 = 19;
const FRAME_DST_ADDR: u32 = 20;
const FRAME_OP0_ADDR: u32 = 21;
const FRAME_OP1_ADDR: u32 = 22;
const FRAME_INST: u32 = 23;
const FRAME_DST: u32 = 24;
const FRAME_OP0: u32 = 25;
const FRAME_OP1: u32 = 26;
const OFF_DST: u32 = 27;
const OFF_OP0: u32 = 28;
const OFF_OP1: u32 = 29;
const FRAME_T0: u32 = 30;
const FRAME_T1: u32 = 31;
const FRAME_MUL: u32 = 32;
const FRAME_SELECTOR: u32 = 33;

const NEXT_AP: u32 = 20;
const NEXT_FP: u32 = 21;
const NEXT_PC_1: u32 = 22;
const NEXT_PC_2: u32 = 23;

// // Auxiliary constraint identifiers
const MEMORY_INCREASING_0: u32 = 31;
const MEMORY_INCREASING_1: u32 = 32;
const MEMORY_INCREASING_2: u32 = 33;
const MEMORY_INCREASING_3: u32 = 34;

const MEMORY_CONSISTENCY_0: u32 = 35;
const MEMORY_CONSISTENCY_1: u32 = 36;
const MEMORY_CONSISTENCY_2: u32 = 37;
const MEMORY_CONSISTENCY_3: u32 = 38;

const PERMUTATION_ARGUMENT_0: u32 = 39;
const PERMUTATION_ARGUMENT_1: u32 = 40;
const PERMUTATION_ARGUMENT_2: u32 = 41;
const PERMUTATION_ARGUMENT_3: u32 = 42;

const RANGE_CHECK_INCREASING_0: u32 = 43;
const RANGE_CHECK_INCREASING_1: u32 = 44;
const RANGE_CHECK_INCREASING_2: u32 = 45;

const RANGE_CHECK_0: u32 = 46;
const RANGE_CHECK_1: u32 = 47;
const RANGE_CHECK_2: u32 = 48;

const MEMORY_ADDR_SORTED_0: u32 = 46;
const MEMORY_ADDR_SORTED_1: u32 = 47;
const MEMORY_ADDR_SORTED_2: u32 = 48;
const MEMORY_ADDR_SORTED_3: u32 = 49;

const MEMORY_VALUES_SORTED_0: u32 = 50;
const MEMORY_VALUES_SORTED_1: u32 = 51;
const MEMORY_VALUES_SORTED_2: u32 = 52;
const MEMORY_VALUES_SORTED_3: u32 = 53;


const PERMUTATION_ARGUMENT_COL_0: u32 = 54;
const PERMUTATION_ARGUMENT_COL_1: u32 = 55;
const PERMUTATION_ARGUMENT_COL_2: u32 = 56;
const PERMUTATION_ARGUMENT_COL_3: u32 = 57;

const PERMUTATION_ARGUMENT_RANGE_CHECK_COL_1: u32 = 58;
const PERMUTATION_ARGUMENT_RANGE_CHECK_COL_2: u32 = 59;
const PERMUTATION_ARGUMENT_RANGE_CHECK_COL_3: u32 = 60;


fn compute_instr_constraints(ref constraints: Array<felt252>, frame: @Array<felt252>) {
    let mut counter = 0;
    let pow_arr = get_pow2_arrayf();
    loop {
        if counter == 15 {
            break;
        }
        constraints.append((*frame.at(counter)) * (*frame.at(counter) - 1));
        counter += 1;
    };
    constraints.append(*frame.at(15));
    let mut f0_squiggle = 0;
    let mut counter = 14;
    loop {
        if counter == 0 {
            f0_squiggle = (*frame.at(counter)) + 2 * f0_squiggle;

            break;
        }
        f0_squiggle = (*frame.at(counter)) + 2 * f0_squiggle;
        counter -= 1;
    };
    'f0_squiggle'.print();
    f0_squiggle.print();
    let b16 = 65536;
    let b32 = 4294967296;
    let b48 = 281474976710656;
    constraints
        .append(
            (*frame.at(OFF_DST))
                + (*frame.at(OFF_OP0)) * b16
                + (*frame.at(OFF_OP1)) * b32
                + f0_squiggle * b48
                - (*frame.at(FRAME_INST))
        );

    'constraints[INST]'.print();
    (*constraints.at(INST)).print();
}


fn compute_operand_constraints(ref constraints: Array<felt252>, frame: @Array<felt252>) {
    let _ap = *frame.at(FRAME_AP);
    let _fp = *frame.at(FRAME_FP);
    let _pc = *frame.at(FRAME_PC);
    let b15 = 32768;
    assert(constraints.len() == DST_ADDR, 'wrong');
    constraints
        .append(
            (*frame.at(F_DST_FP)) * _fp
                + (1 - (*frame.at(F_DST_FP))) * _ap
                + (*frame.at(OFF_DST))
                - b15
                - (*frame.at(FRAME_DST_ADDR))
        );
    constraints
        .append(
            (*frame.at(F_OP_0_FP)) * _fp
                + (1 - (*frame.at(F_OP_0_FP))) * _ap
                + (*frame.at(OFF_OP0))
                - b15
                - (*frame.at(FRAME_OP0_ADDR))
        );
    constraints
        .append(
            (*frame.at(F_OP_1_VAL)) * _pc
                + (*frame.at(F_OP_1_AP)) * _ap
                + (*frame.at(F_OP_1_FP)) * _fp
                + (1 - (*frame.at(F_OP_1_VAL)) - (*frame.at(F_OP_1_AP)) - (*frame.at(F_OP_1_FP)))
                    * (*frame.at(FRAME_OP0))
                + (*frame.at(OFF_OP1))
                - b15
                - (*frame.at(FRAME_OP1_ADDR))
        );
}

fn compute_register_constraints(
    ref constraints: Array<felt252>, frame: @Array<felt252>, offset: u32
) {
    // ap and fp constraints
    constraints
        .append(
            (*frame.at(FRAME_AP))
                + (*frame.at(F_AP_ADD)) * (*frame.at(FRAME_RES))
                + (*frame.at(F_AP_ONE))
                + (*frame.at(F_OPC_CALL)) * 2
                - (*frame.at(FRAME_AP + offset))
        );
    constraints
        .append(
            (*frame.at(F_OPC_RET)) * (*frame.at(FRAME_DST))
                + (*frame.at(F_OPC_CALL)) * ((*frame.at(FRAME_AP)) + 2)
                + (1 - (*frame.at(F_OPC_RET)) - (*frame.at(F_OPC_CALL))) * (*frame.at(FRAME_FP))
                - (*frame.at(FRAME_FP + offset))
        );

    let frame_inst_size = (*frame.at(F_OP_1_VAL)) + 1;

    constraints
        .append(
            (*frame.at(FRAME_T1) - *frame.at(F_PC_JNZ))
                * ((*frame.at(FRAME_PC + offset)) - (*frame.at(FRAME_PC) + frame_inst_size))
        );

    constraints
        .append(
            (*frame.at(FRAME_T0))
                * ((*frame.at(FRAME_PC + offset)) - (*frame.at(FRAME_PC) + (*frame.at(FRAME_OP1))))
                + (1 - (*frame.at(F_PC_JNZ))) * (*frame.at(FRAME_PC + offset))
                - ((1 - (*frame.at(F_PC_ABS)) - (*frame.at(F_PC_REL)) - (*frame.at(F_PC_JNZ)))
                    * ((*frame.at(FRAME_PC)) + frame_inst_size)
                    + (*frame.at(F_PC_ABS)) * (*frame.at(FRAME_RES))
                    + (*frame.at(F_PC_REL)) * ((*frame.at(FRAME_PC)) + (*frame.at(FRAME_RES))))
        );

    constraints.append((*frame.at(F_PC_JNZ)) * (*frame.at(FRAME_DST)) - (*frame.at(FRAME_T0)));
    constraints.append((*frame.at(FRAME_T0)) * (*frame.at(FRAME_RES)) - (*frame.at(FRAME_T1)));
}

fn compute_opcode_constraints(ref constraints: Array<felt252>, frame: @Array<felt252>) {
    constraints.append((*frame.at(FRAME_MUL)) - ((*frame.at(FRAME_OP0)) * (*frame.at(FRAME_OP1))));

    constraints
        .append(
            (*frame.at(F_RES_ADD)) * ((*frame.at(FRAME_OP0)) + (*frame.at(FRAME_OP1)))
                + (*frame.at(F_RES_MUL)) * (*frame.at(FRAME_MUL))
                + (1 - (*frame.at(F_RES_ADD)) - (*frame.at(F_RES_MUL)) - (*frame.at(F_PC_JNZ)))
                    * (*frame.at(FRAME_OP1))
                - (1 - (*frame.at(F_PC_JNZ))) * (*frame.at(FRAME_RES))
        );
    constraints.append((*frame.at(F_OPC_CALL)) * ((*frame.at(FRAME_DST)) - (*frame.at(FRAME_FP))));
    let frame_inst_size = (*frame.at(F_OP_1_VAL)) + 1;

    constraints
        .append(
            (*frame.at(F_OPC_CALL))
                * ((*frame.at(FRAME_OP0)) - ((*frame.at(FRAME_PC)) + frame_inst_size))
        );

    constraints.append((*frame.at(F_OPC_AEQ)) * ((*frame.at(FRAME_DST)) - (*frame.at(FRAME_RES))));
}


fn memory_is_increasing(ref constraints: Array<felt252>, frame: @Array<felt252>, offset: u32) {
    let builtin_offset = 0;

    constraints
        .append(
            ((*frame.at(MEMORY_ADDR_SORTED_0)) - (*frame.at(MEMORY_ADDR_SORTED_1)))
                * ((*frame.at(MEMORY_ADDR_SORTED_1) - (*frame.at(MEMORY_ADDR_SORTED_0)) - 1))
        );
    'SORTED_01'.print();
    (*frame.at(MEMORY_ADDR_SORTED_0)).print();
    (*frame.at(MEMORY_ADDR_SORTED_1)).print();

    constraints
        .append(
            ((*frame.at(MEMORY_ADDR_SORTED_1)) - (*frame.at(MEMORY_ADDR_SORTED_2)))
                * ((*frame.at(MEMORY_ADDR_SORTED_2)) - (*frame.at(MEMORY_ADDR_SORTED_1)) - 1)
        );

    constraints
        .append(
            ((*frame.at(MEMORY_ADDR_SORTED_2)) - (*frame.at(MEMORY_ADDR_SORTED_3)))
                * ((*frame.at(MEMORY_ADDR_SORTED_3)) - (*frame.at(MEMORY_ADDR_SORTED_2)) - 1)
        );

    constraints
        .append(
            ((*frame.at(MEMORY_ADDR_SORTED_3)) - (*frame.at(MEMORY_ADDR_SORTED_0 + offset)))
                * (((*frame.at(MEMORY_ADDR_SORTED_0 + offset))
                    - (*frame.at(MEMORY_ADDR_SORTED_3))
                    - 1))
        );

    constraints
        .append(
            ((*frame.at(MEMORY_VALUES_SORTED_0)) - (*frame.at(MEMORY_VALUES_SORTED_1)))
                * ((*frame.at(MEMORY_ADDR_SORTED_1)) - (*frame.at(MEMORY_ADDR_SORTED_0)) - 1)
        );

    constraints
        .append(
            ((*frame.at(MEMORY_VALUES_SORTED_1)) - (*frame.at(MEMORY_VALUES_SORTED_2)))
                * ((*frame.at(MEMORY_ADDR_SORTED_2)) - (*frame.at(MEMORY_ADDR_SORTED_1)) - 1)
        );

    constraints
        .append(
            ((*frame.at(MEMORY_VALUES_SORTED_2)) - (*frame.at(MEMORY_VALUES_SORTED_3)))
                * ((*frame.at(MEMORY_ADDR_SORTED_3)) - (*frame.at(MEMORY_ADDR_SORTED_2)) - 1)
        );

    constraints
        .append(
            ((*frame.at(MEMORY_VALUES_SORTED_3)) - (*frame.at(MEMORY_VALUES_SORTED_0 + offset)))
                * ((*frame.at(MEMORY_ADDR_SORTED_0 + offset))
                    - (*frame.at(MEMORY_ADDR_SORTED_3))
                    - 1)
        );
}

fn permutation_argument(
    ref constraints: Array<felt252>,
    frame: @Array<felt252>,
    rap_challenges: @RAPChallenges,
    offset: u32
) {
    let z = *rap_challenges.z_memory;
    let alpha = *rap_challenges.alpha_memory;

    let p0 = (*frame.at(PERMUTATION_ARGUMENT_COL_0));
    let p0_next = (*frame.at(PERMUTATION_ARGUMENT_COL_0 + offset));
    let p1 = (*frame.at(PERMUTATION_ARGUMENT_COL_1));
    let p2 = (*frame.at(PERMUTATION_ARGUMENT_COL_2));
    let p3 = (*frame.at(PERMUTATION_ARGUMENT_COL_3));

    let ap0_next = (*frame.at(MEMORY_ADDR_SORTED_0 + offset));
    let ap1 = (*frame.at(MEMORY_ADDR_SORTED_1));
    let ap2 = (*frame.at(MEMORY_ADDR_SORTED_2));
    let ap3 = (*frame.at(MEMORY_ADDR_SORTED_3));

    let vp0_next = (*frame.at(MEMORY_VALUES_SORTED_0 + offset));
    let vp1 = (*frame.at(MEMORY_VALUES_SORTED_1));
    let vp2 = (*frame.at(MEMORY_VALUES_SORTED_2));
    let vp3 = (*frame.at(MEMORY_VALUES_SORTED_3));

    let a0_next = (*frame.at(FRAME_PC + offset));
    let a1 = (*frame.at(FRAME_DST_ADDR));
    let a2 = (*frame.at(FRAME_OP0_ADDR));
    let a3 = (*frame.at(FRAME_OP1_ADDR));

    let v0_next = (*frame.at(FRAME_INST + offset));
    let v1 = (*frame.at(FRAME_DST));
    let v2 = (*frame.at(FRAME_OP0));
    let v3 = (*frame.at(FRAME_OP1));

    constraints.append((z - (ap1 + alpha * vp1)) * p1 - (z - (a1 + alpha * v1)) * p0);

    constraints.append((z - (ap2 + alpha * vp2)) * p2 - (z - (a2 + alpha * v2)) * p1);

    constraints.append((z - (ap3 + alpha * vp3)) * p3 - (z - (a3 + alpha * v3)) * p2);

    constraints
        .append(
            (z - (ap0_next + alpha * vp0_next)) * p0_next - (z - (a0_next + alpha * v0_next)) * p3
        );
}


fn permutation_argument_range_check(
    ref constraints: Array<felt252>,
    frame: @Array<felt252>,
    rap_challenges: @RAPChallenges,
    offset: u32
) {
    let z = *rap_challenges.z_range_check;

    constraints
        .append(
            ((*frame.at(RANGE_CHECK_COL_1)) - (*frame.at(RANGE_CHECK_COL_2)))
                * ((*frame.at(RANGE_CHECK_COL_2)) - (*frame.at(RANGE_CHECK_COL_1)) - 1)
        );

    constraints
        .append(
            ((*frame.at(RANGE_CHECK_COL_2)) - (*frame.at(RANGE_CHECK_COL_3)))
                * ((*frame.at(RANGE_CHECK_COL_3)) - (*frame.at(RANGE_CHECK_COL_2)) - 1)
        );

    constraints
        .append(
            ((*frame.at(RANGE_CHECK_COL_3)) - (*frame.at(RANGE_CHECK_COL_1 + offset)))
                * ((*frame.at(RANGE_CHECK_COL_1 + offset)) - (*frame.at(RANGE_CHECK_COL_3)) - 1)
        );

    let p0 = (*frame.at(PERMUTATION_ARGUMENT_RANGE_CHECK_COL_1));
    let p0_next = (*frame.at(PERMUTATION_ARGUMENT_RANGE_CHECK_COL_1 + offset));

    let p1 = (*frame.at(PERMUTATION_ARGUMENT_RANGE_CHECK_COL_2));
    let p2 = (*frame.at(PERMUTATION_ARGUMENT_RANGE_CHECK_COL_3));

    let ap0_next = (*frame.at(RANGE_CHECK_COL_1 + offset));
    let ap1 = (*frame.at(RANGE_CHECK_COL_2));
    let ap2 = (*frame.at(RANGE_CHECK_COL_3));

    let a0_next = (*frame.at(OFF_DST + offset));
    let a1 = (*frame.at(OFF_OP0));
    let a2 = (*frame.at(OFF_OP1));

    constraints.append((z - ap1) * p1 - (z - a1) * p0);
    constraints.append((z - ap2) * p2 - (z - a2) * p1);
    constraints.append((z - ap0_next) * p0_next - (z - a0_next) * p2);
}

fn range_check_builtin(ref constraints: Array<felt252>, frame: @Array<felt252>) {
    constraints
        .append(
            *frame.at(RC_0)
                + (*frame.at(RC_1)) * 65536
                + (*frame.at(RC_2)) * 4294967296
                + (*frame.at(RC_3)) * 281474976710656
                + (*frame.at(RC_4)) * 18446744073709551616
                + (*frame.at(RC_5)) * 1208925819614629174706176
                + (*frame.at(RC_6)) * 79228162514264337593543950336
                + (*frame.at(RC_7)) * 5192296858534827628530496329220096
                - (*frame.at(RC_VALUE))
        );
}
