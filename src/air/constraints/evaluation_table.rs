use lambdaworks_fft::polynomial::FFTPoly;
use lambdaworks_math::{
    field::{
        element::FieldElement,
        traits::{IsFFTField, IsField},
    },
    polynomial::Polynomial,
};

#[derive(Clone, Debug)]
pub struct ConstraintEvaluationTable<F: IsField> {
    // Accumulation of the evaluation of the constraints
    pub evaluations_acc: Vec<FieldElement<F>>,
    pub trace_length: usize,
}

impl<F: IsField> ConstraintEvaluationTable<F> {
    pub fn new(_n_cols: usize, domain: &[FieldElement<F>]) -> Self {
        let evaluations_acc = vec![FieldElement::zero(); _n_cols];

        println!("domain len: {}", domain.len());
        println!("_n_cols: {}", _n_cols);

        ConstraintEvaluationTable {
            evaluations_acc,
            trace_length: domain.len(),
        }
    }

    pub fn compute_composition_poly(&self, offset: &FieldElement<F>) -> Polynomial<FieldElement<F>>
    where
        F: IsFFTField,
        Polynomial<FieldElement<F>>: FFTPoly<F>,
    {
        Polynomial::interpolate_offset_fft(&self.evaluations_acc, offset).unwrap()
    }

    pub fn acc_evaluation_polynomial(&mut self, row: &[FieldElement<F>]) {
        self.evaluations_acc
            .iter_mut()
            .zip(row)
            .for_each(|(acc, d)| *acc = &*acc + d);
    }
}
