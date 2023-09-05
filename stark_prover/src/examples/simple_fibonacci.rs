use lambdaworks_crypto::fiat_shamir::transcript::Transcript;
use lambdaworks_math::field::{
    element::FieldElement,
    traits::{IsFFTField, IsField},
};

use crate::{
    constraints::boundary::{BoundaryConstraint, BoundaryConstraints},
    context::AirContext,
    frame::Frame,
    proof::options::ProofOptions,
    trace::TraceTable,
    traits::AIR,
};

pub struct FibonacciAIR<F>
where
    F: IsFFTField,
{
    context: AirContext,
    trace_length: usize,
    pub_inputs: FibonacciPublicInputs<F>,
    constraint_system: ConstraintSystem<F>,
}

#[derive(Clone, Debug)]
pub struct FibonacciPublicInputs<F>
where
    F: IsFFTField,
{
    pub a0: FieldElement<F>,
    pub a1: FieldElement<F>,
}

impl<F> AIR for FibonacciAIR<F>
where
    F: IsFFTField,
{
    type Field = F;
    type RAPChallenges = ();
    type PublicInputs = FibonacciPublicInputs<Self::Field>;

    fn new(
        trace_length: usize,
        pub_inputs: &Self::PublicInputs,
        proof_options: &ProofOptions,
    ) -> Self {
        let context = AirContext {
            proof_options: proof_options.clone(),
            trace_columns: 1,
            transition_degrees: vec![1],
            transition_exemptions: vec![2],
            transition_offsets: vec![0, 1, 2],
            num_transition_constraints: 1,
            num_transition_exemptions: 1,
        };

        let mut cs = ConstraintSystem::new(
            vec!["Fibonacci", "Disordered_Fibonacci", "Z"],
            vec!["Alpha"],
        );
        Fibonacci::add_to(&mut cs, "Fibonacci");

        Self {
            pub_inputs: pub_inputs.clone(),
            context,
            trace_length,
            constraint_system: cs,
        }
    }

    fn composition_poly_degree_bound(&self) -> usize {
        self.trace_length()
    }

    fn build_auxiliary_trace(
        &self,
        _main_trace: &TraceTable<Self::Field>,
        _rap_challenges: &Self::RAPChallenges,
    ) -> TraceTable<Self::Field> {
        TraceTable::empty()
    }

    fn build_rap_challenges<T: Transcript>(&self, _transcript: &mut T) -> Self::RAPChallenges {}

    fn compute_transition(
        &self,
        frame: &Frame<Self::Field>,
        _rap_challenges: &Self::RAPChallenges,
    ) -> Vec<FieldElement<Self::Field>> {
        let res = self.constraint_system.constraints[0].evaluate(
            &vec![
                frame.get_row(0).to_vec(),
                frame.get_row(1).to_vec(),
                frame.get_row(2).to_vec(),
            ],
            &Vec::new(),
        );

        vec![res]
    }

    fn boundary_constraints(
        &self,
        _rap_challenges: &Self::RAPChallenges,
    ) -> BoundaryConstraints<Self::Field> {
        let a0 = BoundaryConstraint::new_simple(0, self.pub_inputs.a0.clone());
        let a1 = BoundaryConstraint::new_simple(1, self.pub_inputs.a1.clone());

        BoundaryConstraints::from_constraints(vec![a0, a1])
    }

    fn number_auxiliary_rap_columns(&self) -> usize {
        0
    }

    fn context(&self) -> &AirContext {
        &self.context
    }

    fn trace_length(&self) -> usize {
        self.trace_length
    }

    fn pub_inputs(&self) -> &Self::PublicInputs {
        &self.pub_inputs
    }
}

pub fn fibonacci_trace<F: IsFFTField>(
    initial_values: [FieldElement<F>; 2],
    trace_length: usize,
) -> TraceTable<F> {
    let mut ret: Vec<FieldElement<F>> = vec![];

    ret.push(initial_values[0].clone());
    ret.push(initial_values[1].clone());

    for i in 2..(trace_length) {
        ret.push(ret[i - 1].clone() + ret[i - 2].clone());
    }

    TraceTable::new_from_cols(&[ret])
}

pub trait Constraint<F: IsField> {
    fn evaluate(
        &self,
        frame: &Vec<Vec<FieldElement<F>>>,
        challenges: &Vec<FieldElement<F>>,
    ) -> FieldElement<F>;
}

pub struct Binary {
    binary_column: usize,
}

impl Binary {
    pub fn add_to<F: IsField>(cs: &mut ConstraintSystem<F>, binary_column: &str) {
        cs.constraints.push(Box::new(Self {
            binary_column: cs.index(&binary_column.to_string()),
        }));
    }
}

impl<F: IsField> Constraint<F> for Binary {
    fn evaluate(
        &self,
        frame: &Vec<Vec<FieldElement<F>>>,
        challenges: &Vec<FieldElement<F>>,
    ) -> FieldElement<F> {
        (&frame[0][self.binary_column] - FieldElement::one()) * &frame[0][self.binary_column]
    }
}

#[derive(Clone)]
pub struct Fibonacci {
    fibonacci_column: usize,
}

impl Fibonacci {
    pub fn add_to<F: IsField>(cs: &mut ConstraintSystem<F>, column_name: &str) {
        cs.constraints.push(Box::new(Self {
            fibonacci_column: cs.index(&column_name.to_string()),
        }));
    }
}

impl<F: IsField> Constraint<F> for Fibonacci {
    fn evaluate(
        &self,
        frame: &Vec<Vec<FieldElement<F>>>,
        challenges: &Vec<FieldElement<F>>,
    ) -> FieldElement<F> {
        &frame[2][self.fibonacci_column]
            - &frame[1][self.fibonacci_column]
            - &frame[0][self.fibonacci_column]
    }
}

pub struct Permutation {
    cumulative: usize,
    columns_a: Vec<usize>,
    columns_b: Vec<usize>,
    challenge_z: usize,
    challenge_gamma: usize,
}

impl Permutation {
    pub fn add_to<F: IsField>(
        cs: &mut ConstraintSystem<F>,
        cumulative: &str,
        columns_a: Vec<String>,
        columns_b: Vec<String>,
        challenge_z: &str,
        challenge_gamma: &str,
    ) {
        cs.constraints.push(Box::new(Self {
            cumulative: cs.index(&cumulative.to_string()),
            columns_a: columns_a.iter().map(|x| cs.index(&x)).collect(),
            columns_b: columns_b.iter().map(|x| cs.index(&x)).collect(),
            challenge_gamma: cs.challenge_index(&challenge_gamma.to_string()),
            challenge_z: cs.challenge_index(&challenge_z.to_string()),
        }));
    }
}

impl<F: IsField> Constraint<F> for Permutation {
    fn evaluate(
        &self,
        frame: &Vec<Vec<FieldElement<F>>>,
        challenges: &Vec<FieldElement<F>>,
    ) -> FieldElement<F> {
        let z = &challenges[self.challenge_z];
        let gamma = challenges[self.challenge_gamma].clone();

        let mut columns_a = z.clone();
        let mut columns_b = z.clone();
        for (i, (&col_a, &col_b)) in self.columns_a.iter().zip(&self.columns_b).enumerate() {
            columns_a = columns_a + &frame[0][col_a] * gamma.pow(i);
            columns_b = columns_b + &frame[0][col_b] * gamma.pow(i);
        }
        columns_a * &frame[0][self.cumulative] - columns_b * &frame[1][self.cumulative]
    }
}

pub struct ConstraintSystem<F: IsField> {
    column_names: Vec<String>,
    challenges: Vec<String>,
    pub constraints: Vec<Box<dyn Constraint<F>>>,
}

impl<F: IsField> ConstraintSystem<F> {
    pub fn new(column_names: Vec<&str>, challenges: Vec<&str>) -> Self {
        Self {
            column_names: column_names.iter().map(|x| x.to_string()).collect(),
            challenges: challenges.iter().map(|x| x.to_string()).collect(),
            constraints: Vec::new(),
        }
    }

    fn index(&self, column_name: &String) -> usize {
        self.column_names
            .iter()
            .position(|c| c == column_name)
            .unwrap()
    }

    fn challenge_index(&self, column_name: &String) -> usize {
        self.challenges
            .iter()
            .position(|c| c == column_name)
            .unwrap()
    }

    pub fn add_fibonacci_constraint(&mut self, column_name: &str) {
        Fibonacci::add_to(self, column_name)
    }

    pub fn add_permutation_constraint(
        &mut self,
        cumulative: &str,
        columns_a: Vec<String>,
        columns_b: Vec<String>,
        challenge_z: &str,
        challenge_gamma: &str,
    ) {
        Permutation::add_to(
            self,
            cumulative,
            columns_a,
            columns_b,
            challenge_z,
            challenge_gamma,
        )
    }

    pub fn add_binary_constraint(&mut self, binary_column: &str) {
        Binary::add_to(self, binary_column)
    }
}
