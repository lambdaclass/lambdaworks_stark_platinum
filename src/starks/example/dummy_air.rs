use lambdaworks_crypto::fiat_shamir::transcript::Transcript;
use lambdaworks_math::field::{
    element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    traits::IsFFTField,
};

use crate::starks::{
    constraints::boundary::{BoundaryConstraint, BoundaryConstraints},
    context::AirContext,
    frame::Frame,
    trace::TraceTable,
    traits::AIR,
};

#[derive(Clone)]
pub struct DummyAIR {
    context: AirContext,
    trace_length: usize,
}

impl DummyAIR {
    fn new(context: AirContext, trace_length: usize) -> Self {
        Self {
            context,
            trace_length,
        }
    }
}

impl AIR for DummyAIR {
    type Field = Stark252PrimeField;
    type RAPChallenges = ();
    type PublicInput = ();

    fn build_auxiliary_trace(
        &self,
        _main_trace: &TraceTable<Self::Field>,
        _rap_challenges: &Self::RAPChallenges,
        _public_input: &Self::PublicInput,
    ) -> TraceTable<Self::Field> {
        TraceTable::empty()
    }

    fn build_rap_challenges<T: Transcript>(&self, _transcript: &mut T) -> Self::RAPChallenges {}
    fn compute_transition(
        &self,
        frame: &Frame<Self::Field>,
        _rap_challenges: &Self::RAPChallenges,
    ) -> Vec<FieldElement<Self::Field>> {
        let first_row = frame.get_row(0);
        let second_row = frame.get_row(1);
        let third_row = frame.get_row(2);

        let f_constraint = &first_row[0] * (&first_row[0] - FieldElement::one());

        let fib_constraint = &third_row[1] - &second_row[1] - &first_row[1];

        vec![f_constraint, fib_constraint]
    }

    fn boundary_constraints(
        &self,
        _rap_challenges: &Self::RAPChallenges,
        _public_input: &Self::PublicInput,
    ) -> BoundaryConstraints<Self::Field> {
        let a0 = BoundaryConstraint::new(1, 0, FieldElement::<Self::Field>::one());
        let a1 = BoundaryConstraint::new(1, 1, FieldElement::<Self::Field>::one());

        BoundaryConstraints::from_constraints(vec![a0, a1])
    }

    fn number_auxiliary_rap_columns(&self) -> usize {
        0
    }

    fn context(&self) -> &AirContext {
        &self.context
    }

    fn composition_poly_degree_bound(&self) -> usize {
        self.trace_length
    }

    fn trace_length(&self) -> usize {
        self.trace_length
    }
}

pub fn dummy_trace<F: IsFFTField>(trace_length: usize) -> TraceTable<F> {
    let mut ret: Vec<FieldElement<F>> = vec![];

    let a0 = FieldElement::one();
    let a1 = FieldElement::one();

    ret.push(a0);
    ret.push(a1);

    for i in 2..(trace_length) {
        ret.push(ret[i - 1].clone() + ret[i - 2].clone());
    }

    TraceTable::new_from_cols(&[vec![FieldElement::<F>::one(); trace_length], ret])
}
