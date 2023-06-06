use lambdaworks_math::{
    field::{element::FieldElement, traits::IsFFTField},
    polynomial::Polynomial,
    traits::ByteConversion,
};

use super::{boundary::BoundaryConstraints, evaluation_table::ConstraintEvaluationTable};
use crate::{
    air::{frame::Frame, trace::TraceTable, traits::AIR},
    prover::evaluate_polynomial_on_lde_domain,
    Domain,
};
use std::iter::zip;

pub struct ConstraintEvaluator<'poly, F: IsFFTField, A: AIR> {
    air: A,
    boundary_constraints: BoundaryConstraints<F>,
    trace_polys: &'poly [Polynomial<FieldElement<F>>],
    primitive_root: FieldElement<F>,
}

impl<'poly, F: IsFFTField, A: AIR + AIR<Field = F>> ConstraintEvaluator<'poly, F, A> {
    pub fn new(
        air: &A,
        trace_polys: &'poly [Polynomial<FieldElement<F>>],
        primitive_root: &FieldElement<F>,
        public_input: &A::PublicInput,
        rap_challenges: &A::RAPChallenges,
    ) -> Self {
        let boundary_constraints = air.boundary_constraints(rap_challenges, public_input);

        Self {
            air: air.clone(),
            boundary_constraints,
            trace_polys,
            primitive_root: primitive_root.clone(),
        }
    }

    pub fn evaluate(
        &self,
        lde_trace: &TraceTable<F>,
        domain: &Domain<F>,
        alpha_and_beta_transition_coefficients: &[(FieldElement<F>, FieldElement<F>)],
        alpha_and_beta_boundary_coefficients: &[(FieldElement<F>, FieldElement<F>)],
        rap_challenges: &A::RAPChallenges,
    ) -> ConstraintEvaluationTable<F>
    where
        FieldElement<F>: ByteConversion,
    {
        // The + 1 is for the boundary constraints column
        let mut evaluation_table = ConstraintEvaluationTable::new(
            self.air.context().num_transition_constraints() + 1,
            &domain.lde_roots_of_unity_coset,
        );
        let n_trace_colums = self.trace_polys.len();
        let boundary_constraints = &self.boundary_constraints;

        let domains =
            boundary_constraints.generate_roots_of_unity(&self.primitive_root, n_trace_colums);
        let values = boundary_constraints.values(n_trace_colums);

        #[cfg(debug_assertions)]
        let mut boundary_polys = Vec::new();

        let boundary_polys_evaluations: Vec<Vec<FieldElement<F>>> = zip(domains, values)
            .zip(self.trace_polys)
            .map(|((xs, ys), trace_poly)| {
                let boundary_poly = trace_poly
                    - &Polynomial::interpolate(&xs, &ys)
                        .expect("xs and ys have equal length and xs are unique");

                #[cfg(debug_assertions)]
                boundary_polys.push(boundary_poly.clone());

                evaluate_polynomial_on_lde_domain(
                    &boundary_poly,
                    domain.blowup_factor,
                    domain.interpolation_domain_size,
                    &domain.coset_offset,
                )
                .unwrap()
            })
            .collect();

        #[cfg(debug_assertions)]
        let mut boundary_zerofiers = Vec::new();

        let boundary_zerofiers_inverse_evaluations: Vec<Vec<FieldElement<F>>> = (0..n_trace_colums)
            .map(|col| {
                let zerofier = self
                    .boundary_constraints
                    .compute_zerofier(&self.primitive_root, col);

                #[cfg(debug_assertions)]
                boundary_zerofiers.push(zerofier.clone());

                let mut evals = evaluate_polynomial_on_lde_domain(
                    &zerofier,
                    domain.blowup_factor,
                    domain.interpolation_domain_size,
                    &domain.coset_offset,
                )
                .unwrap();
                FieldElement::inplace_batch_inverse(&mut evals);
                evals
            })
            .collect();

        #[cfg(debug_assertions)]
        for (poly, z) in boundary_polys.iter().zip(boundary_zerofiers.iter()) {
            let (_, b) = poly.clone().long_division_with_remainder(z);
            assert_eq!(b, Polynomial::zero());
        }

        let blowup_factor = self.air.blowup_factor();

        #[cfg(debug_assertions)]
        let mut transition_evaluations = Vec::new();

        let divisors = self.air.transition_divisors();
        let boundary_term_degree_adjustment =
            self.air.composition_poly_degree_bound() - self.air.context().trace_length;

        let mut transition_zerofiers_inverse_evaluations = Vec::new();
        for divisor in divisors {
            let mut evaluations = evaluate_polynomial_on_lde_domain(
                &divisor,
                domain.blowup_factor,
                domain.interpolation_domain_size,
                &domain.coset_offset,
            )
            .unwrap();
            FieldElement::inplace_batch_inverse(&mut evaluations);
            transition_zerofiers_inverse_evaluations.push(evaluations);
        }

        let transition_degrees_len = self.air.context().transition_degrees_len();
        let context = self.air.context();
        let transition_degrees = context.transition_degrees();
        let mut degree_adjustments = Vec::with_capacity(transition_degrees_len);
        for transition_degree in transition_degrees.iter() {
            let lde = &domain.lde_roots_of_unity_coset;
            let mut transition_adjustment = Vec::with_capacity(lde.len());
            for d in lde.iter() {
                let degree_adjustment = self.air.composition_poly_degree_bound()
                    - (self.air.context().trace_length * (transition_degree - 1));
                transition_adjustment.push(d.pow(degree_adjustment));
            }
            degree_adjustments.push(transition_adjustment);
        }

        // Iterate over trace and domain and compute transitions
        for (i, d) in domain.lde_roots_of_unity_coset.iter().enumerate() {
            let frame = Frame::read_from_trace(
                lde_trace,
                i,
                blowup_factor,
                &self.air.context().transition_offsets,
            );

            let mut evaluations = self.air.compute_transition(&frame, rap_challenges);

            #[cfg(debug_assertions)]
            transition_evaluations.push(evaluations.clone());

            // TODO: Remove clones
            let denominators: Vec<_> = transition_zerofiers_inverse_evaluations
                .iter()
                .map(|zerofier_evals| zerofier_evals[i].clone())
                .collect();
            let degree_adjustments: Vec<_> = degree_adjustments
                .iter()
                .map(|transition_adjustments| transition_adjustments[i].clone())
                .collect();
            evaluations = Self::compute_constraint_composition_poly_evaluations(
                &evaluations,
                &denominators,
                &degree_adjustments,
                alpha_and_beta_transition_coefficients,
            );

            let d_adjustment_power = d.pow(boundary_term_degree_adjustment);
            let boundary_evaluation = zip(
                &boundary_polys_evaluations,
                &boundary_zerofiers_inverse_evaluations,
            )
            .enumerate()
            .map(
                |(index, (boundary_poly_evaluation, zerofier_inverse_evaluation))| {
                    let (boundary_alpha, boundary_beta) =
                        alpha_and_beta_boundary_coefficients[index].clone();

                    &boundary_poly_evaluation[i]
                        * &zerofier_inverse_evaluation[i]
                        * (&boundary_alpha * &d_adjustment_power + &boundary_beta)
                },
            )
            .fold(FieldElement::<F>::zero(), |acc, eval| acc + eval);

            evaluations.push(boundary_evaluation);

            let merged_value = evaluations
                .iter()
                .fold(FieldElement::<F>::zero(), |acc, eval| acc + eval);

            evaluation_table.evaluations_acc.push(merged_value);
        }

        evaluation_table
    }

    /// Given `evaluations` T_i(x) of the trace polynomial composed with the constraint
    /// polynomial at a certain point `x`, computes the following evaluations and returns them:
    ///
    /// T_i(x) (alpha_i * x^(D - D_i) + beta_i) / (Z_i(x))
    ///
    /// where Z is the zerofier of the `i`-th transition constraint polynomial. In the fibonacci
    /// example, T_i(x) is t(x * g^2) - t(x * g) - t(x).
    ///
    /// This method is called in two different scenarios. The first is when the prover
    /// is building these evaluations to compute the composition and DEEP composition polynomials.
    /// The second one is when the verifier needs to check the consistency between the trace and
    /// the composition polynomial. In that case the `evaluations` are over an *out of domain* frame
    /// (in the fibonacci example they are evaluations on the points `z`, `zg`, `zg^2`).
    pub fn compute_constraint_composition_poly_evaluations(
        evaluations: &[FieldElement<F>],
        inverse_denominators: &[FieldElement<F>],
        degree_adjustments: &[FieldElement<F>],
        constraint_coeffs: &[(FieldElement<F>, FieldElement<F>)],
    ) -> Vec<FieldElement<F>> {
        let mut ret = Vec::with_capacity(evaluations.len());
        for (((eval, degree_adjustment), inverse_denominator), (alpha, beta)) in evaluations
            .iter()
            .zip(degree_adjustments)
            .zip(inverse_denominators)
            .zip(constraint_coeffs)
        {
            let zerofied_eval = eval * inverse_denominator;
            let result = zerofied_eval * (alpha * degree_adjustment + beta);
            ret.push(result);
        }

        ret
    }
}
