use crate::{
    air::{
        self,
        constraints::boundary::{BoundaryConstraint, BoundaryConstraints},
        context::AirContext,
        trace::TraceTable,
        traits::AIR,
    },
    fri::FieldElement,
};
use lambdaworks_crypto::fiat_shamir::transcript::Transcript;
use lambdaworks_math::field::fields::u64_prime_field::F17;

#[derive(Clone)]
pub struct Fibonacci17AIR {
    context: AirContext,
}

impl From<AirContext> for Fibonacci17AIR {
    fn from(context: AirContext) -> Self {
        Self { context }
    }
}

pub fn build_main_trace(raw_trace: &[Vec<FieldElement<F17>>]) -> TraceTable<F17> {
    TraceTable::new_from_cols(raw_trace)
}

impl AIR for Fibonacci17AIR {
    type Field = F17;
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
        frame: &air::frame::Frame<Self::Field>,
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
        _public_input: &Self::PublicInput,
    ) -> BoundaryConstraints<Self::Field> {
        let a0 = BoundaryConstraint::new_simple(0, FieldElement::<Self::Field>::one());
        let a1 = BoundaryConstraint::new_simple(1, FieldElement::<Self::Field>::one());
        let result = BoundaryConstraint::new_simple(3, FieldElement::<Self::Field>::from(3));

        BoundaryConstraints::from_constraints(vec![a0, a1, result])
    }

    fn number_auxiliary_rap_columns(&self) -> usize {
        0
    }

    fn context(&self) -> &air::context::AirContext {
        &self.context
    }

    fn composition_poly_degree_bound(&self) -> usize {
        self.context().trace_length
    }
}
