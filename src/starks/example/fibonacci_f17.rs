use lambdaworks_crypto::fiat_shamir::transcript::Transcript;
use lambdaworks_math::field::{element::FieldElement, fields::u64_prime_field::F17};

use crate::starks::{
    constraints::boundary::{BoundaryConstraint, BoundaryConstraints},
    context::AirContext,
    frame::Frame,
    trace::TraceTable,
    traits::AIR,
};

#[derive(Clone)]
pub struct Fibonacci17AIR {
    context: AirContext,
    trace_length: usize,
}

impl Fibonacci17AIR {
    pub fn new(context: AirContext, trace_length: usize) -> Self {
        Self {
            context,
            trace_length,
        }
    }
}

impl AIR for Fibonacci17AIR {
    type Field = F17;
    type RAPChallenges = ();
    type PublicInput = ();

    fn build_auxiliary_trace(
        &self,
        _main_trace: &TraceTable<Self::Field>,
        _rap_challenges: &Self::RAPChallenges,
        _public_input: &Self::PublicInputs,
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

        vec![third_row[0] - second_row[0] - first_row[0]]
    }

    fn boundary_constraints(
        &self,
        _rap_challenges: &Self::RAPChallenges,
        _public_input: &Self::PublicInputs,
    ) -> BoundaryConstraints<Self::Field> {
        let a0 = BoundaryConstraint::new_simple(0, FieldElement::<Self::Field>::one());
        let a1 = BoundaryConstraint::new_simple(1, FieldElement::<Self::Field>::one());
        let result = BoundaryConstraint::new_simple(3, FieldElement::<Self::Field>::from(3));

        BoundaryConstraints::from_constraints(vec![a0, a1, result])
    }

    fn number_auxiliary_rap_columns(&self) -> usize {
        0
    }

    fn context(&self) -> &AirContext {
        &self.context
    }

    fn composition_poly_degree_bound(&self) -> usize {
        self.trace_length()
    }

    fn trace_length(&self) -> usize {
        self.trace_length
    }
}
