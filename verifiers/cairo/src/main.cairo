use debug::PrintTrait;
use array::ArrayDefault;
use array::ArrayTrait;
use cairo_verifier::stark_proof::{STARKProof};
use cairo_verifier::sample_proof::get_sample_proof;

fn main() {
    'Hello, world444!'.print();
    let proof: STARKProof = get_sample_proof();
    'Lde Merkle Roots'.print();
    proof.lde_trace_merkle_roots.print();
    'Ood Fr Evaluations'.print();
    proof.trace_ood_frame_evaluations.data.print();
    'Ood row width'.print();
    proof.trace_ood_frame_evaluations.row_width.print();
    'Comp poly'.print();
    proof.composition_poly_even_ood_evaluation.print();
    proof.composition_poly_odd_root.print();
    proof.composition_poly_odd_ood_evaluation.print();
    proof.composition_poly_even_root.print();
    'Fri layers merkle roots'.print();
    proof.fri_layers_merkle_roots.print();
    proof.fri_last_value.print();
}

