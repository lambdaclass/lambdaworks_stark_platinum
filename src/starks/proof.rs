use lambdaworks_crypto::merkle_tree::proof::Proof;
use lambdaworks_math::{
    elliptic_curve::short_weierstrass::errors::DeserializationError,
    field::{element::FieldElement, traits::IsFFTField},
    traits::{ByteConversion, Deserializable, Serializable},
};

use super::{
    frame::Frame,
    fri::{fri_decommit::FriDecommitment, Commitment},
    utils::{deserialize_proof, serialize_proof},
};

#[derive(Debug, Clone)]
pub struct DeepPolynomialOpenings<F: IsFFTField> {
    pub lde_composition_poly_proof: Proof<Commitment>,
    pub lde_composition_poly_even_evaluation: FieldElement<F>,
    pub lde_composition_poly_odd_evaluation: FieldElement<F>,
    pub lde_trace_merkle_proofs: Vec<Proof<Commitment>>,
    pub lde_trace_evaluations: Vec<FieldElement<F>>,
}

#[derive(Debug)]
pub struct StarkProof<F: IsFFTField> {
    // Commitments of the trace columns
    // [tⱼ]
    pub lde_trace_merkle_roots: Vec<Commitment>,
    // tⱼ(zgᵏ)
    pub trace_ood_frame_evaluations: Frame<F>,
    // [H₁] and [H₂]
    pub composition_poly_root: Commitment,
    // H₁(z²)
    pub composition_poly_even_ood_evaluation: FieldElement<F>,
    // H₂(z²)
    pub composition_poly_odd_ood_evaluation: FieldElement<F>,
    // [pₖ]
    pub fri_layers_merkle_roots: Vec<Commitment>,
    // pₙ
    pub fri_last_value: FieldElement<F>,
    // Open(p₀(D₀), 𝜐ₛ), Opwn(pₖ(Dₖ), −𝜐ₛ^(2ᵏ))
    pub query_list: Vec<FriDecommitment<F>>,
    // Open(H₁(D_LDE, 𝜐₀), Open(H₂(D_LDE, 𝜐₀), Open(tⱼ(D_LDE), 𝜐₀)
    pub deep_poly_openings: Vec<DeepPolynomialOpenings<F>>,
}

impl<F> Serializable for DeepPolynomialOpenings<F>
where
    F: IsFFTField,
    FieldElement<F>: ByteConversion,
{
    fn serialize(&self) -> Vec<u8> {
        let mut bytes = vec![];
        bytes.extend(serialize_proof(&self.lde_composition_poly_proof));
        let lde_composition_poly_even_evaluation_bytes =
            self.lde_composition_poly_even_evaluation.to_bytes_be();
        let felt_len = lde_composition_poly_even_evaluation_bytes.len();
        bytes.extend(felt_len.to_be_bytes());
        bytes.extend(lde_composition_poly_even_evaluation_bytes);
        bytes.extend(self.lde_composition_poly_odd_evaluation.to_bytes_be());
        bytes.extend(self.lde_trace_merkle_proofs.len().to_be_bytes());
        for proof in &self.lde_trace_merkle_proofs {
            bytes.extend(serialize_proof(proof));
        }
        bytes.extend(self.lde_trace_evaluations.len().to_be_bytes());
        for evaluation in &self.lde_trace_evaluations {
            bytes.extend(evaluation.to_bytes_be());
        }
        bytes
    }
}

impl<F> Deserializable for DeepPolynomialOpenings<F>
where
    F: IsFFTField,
    FieldElement<F>: ByteConversion,
{
    fn deserialize(bytes: &[u8]) -> Result<Self, DeserializationError>
    where
        Self: Sized,
    {
        let mut bytes = bytes;
        let lde_composition_poly_proof;
        (lde_composition_poly_proof, bytes) = deserialize_proof(bytes)?;

        let felt_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        let lde_composition_poly_even_evaluation = FieldElement::from_bytes_be(
            bytes[..felt_len]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        )?;
        bytes = &bytes[felt_len..];

        let lde_composition_poly_odd_evaluation = FieldElement::from_bytes_be(
            bytes[..felt_len]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        )?;
        bytes = &bytes[felt_len..];

        let lde_trace_merkle_proofs_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        let mut lde_trace_merkle_proofs = vec![];
        for _ in 0..lde_trace_merkle_proofs_len {
            let proof;
            (proof, bytes) = deserialize_proof(bytes)?;
            lde_trace_merkle_proofs.push(proof);
        }

        let lde_trace_evaluations_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        let mut lde_trace_evaluations = vec![];
        for _ in 0..lde_trace_evaluations_len {
            let evaluation = FieldElement::from_bytes_be(
                bytes[..felt_len]
                    .try_into()
                    .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
            )?;
            bytes = &bytes[felt_len..];
            lde_trace_evaluations.push(evaluation);
        }

        Ok(DeepPolynomialOpenings {
            lde_composition_poly_proof,
            lde_composition_poly_even_evaluation,
            lde_composition_poly_odd_evaluation,
            lde_trace_merkle_proofs,
            lde_trace_evaluations,
        })
    }
}

impl<F> Serializable for StarkProof<F>
where
    F: IsFFTField,
    FieldElement<F>: ByteConversion,
{
    fn serialize(&self) -> Vec<u8> {
        let mut bytes = vec![];
        bytes.extend(self.lde_trace_merkle_roots.len().to_be_bytes());
        for commitment in &self.lde_trace_merkle_roots {
            bytes.extend(commitment);
        }
        bytes.extend(self.trace_ood_frame_evaluations.serialize());
        bytes.extend(self.composition_poly_root);

        let composition_poly_even_ood_evaluation_bytes =
            self.composition_poly_even_ood_evaluation.to_bytes_be();
        bytes.extend(
            composition_poly_even_ood_evaluation_bytes
                .len()
                .to_be_bytes(),
        );
        bytes.extend(composition_poly_even_ood_evaluation_bytes);
        bytes.extend(self.composition_poly_odd_ood_evaluation.to_bytes_be());

        bytes.extend(self.fri_layers_merkle_roots.len().to_be_bytes());
        for commitment in &self.fri_layers_merkle_roots {
            bytes.extend(commitment);
        }

        bytes.extend(self.fri_last_value.to_bytes_be());

        bytes.extend(self.query_list.len().to_be_bytes());
        for query in &self.query_list {
            bytes.extend(query.serialize());
        }

        bytes
    }
}

#[cfg(test)]
mod test {
    use lambdaworks_crypto::merkle_tree::proof::Proof;
    use lambdaworks_math::field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    };
    use proptest::{collection, prelude::*, prop_compose, proptest};

    use crate::starks::{
        fri::{fri_decommit::FriDecommitment, Commitment},
        proof::DeepPolynomialOpenings,
    };
    use lambdaworks_math::traits::{Deserializable, Serializable};

    type FE = FieldElement<Stark252PrimeField>;

    prop_compose! {
            fn some_commitment()(high in any::<u128>(), low in any::<u128>()) -> Commitment {
                let mut bytes = [0u8; 32];
                bytes[..16].copy_from_slice(&high.to_be_bytes());
                bytes[16..].copy_from_slice(&low.to_be_bytes());
                bytes
        }
    }

    prop_compose! {
        fn commitment_vec()(vec in collection::vec(some_commitment(), 32)) -> Vec<Commitment> {
            vec
        }
    }

    prop_compose! {
        fn some_proof()(merkle_path in commitment_vec()) -> Proof<Commitment> {
            Proof{merkle_path}
        }
    }

    prop_compose! {
        fn proof_vec()(vec in collection::vec(some_proof(), 4)) -> Vec<Proof<Commitment>> {
            vec
        }
    }

    prop_compose! {
        fn some_felt()(base in any::<u64>(), exponent in any::<u128>()) -> FE {
            FE::from(base).pow(exponent)
        }
    }

    prop_compose! {
        fn field_vec()(vec in collection::vec(some_felt(), 16)) -> Vec<FE> {
            vec
        }
    }

    prop_compose! {
        fn some_fri_decommitment()(
            layers_auth_paths_sym in proof_vec(),
            layers_evaluations_sym in field_vec(),
            first_layer_evaluation in some_felt(),
            first_layer_auth_path in some_proof()
        ) -> FriDecommitment<Stark252PrimeField> {
            FriDecommitment{
                layers_auth_paths_sym,
                layers_evaluations_sym,
                first_layer_evaluation,
                first_layer_auth_path
            }
        }
    }

    prop_compose! {
        fn some_deep_polynomial_openings()(
            lde_composition_poly_proof in some_proof(),
            lde_composition_poly_even_evaluation in some_felt(),
            lde_composition_poly_odd_evaluation in some_felt(),
            lde_trace_merkle_proofs in proof_vec(),
            lde_trace_evaluations in field_vec()
        ) -> DeepPolynomialOpenings<Stark252PrimeField> {
            DeepPolynomialOpenings {
                lde_composition_poly_proof,
                lde_composition_poly_even_evaluation,
                lde_composition_poly_odd_evaluation,
                lde_trace_merkle_proofs,
                lde_trace_evaluations
            }
        }
    }

    proptest! {
        #[test]
        fn test_deep_polynomial_openings_serialization(
            deep_polynomial_openings in some_deep_polynomial_openings()
        ) {
            let serialized = deep_polynomial_openings.serialize();
            let deserialized = DeepPolynomialOpenings::<Stark252PrimeField>::deserialize(&serialized).unwrap();

            for (a, b) in deep_polynomial_openings.lde_trace_merkle_proofs.iter().zip(deserialized.lde_trace_merkle_proofs.iter()) {
                prop_assert_eq!(&a.merkle_path, &b.merkle_path);
            };

            prop_assert_eq!(deep_polynomial_openings.lde_composition_poly_even_evaluation, deserialized.lde_composition_poly_even_evaluation);
            prop_assert_eq!(deep_polynomial_openings.lde_composition_poly_odd_evaluation, deserialized.lde_composition_poly_odd_evaluation);
            prop_assert_eq!(deep_polynomial_openings.lde_composition_poly_proof.merkle_path, deserialized.lde_composition_poly_proof.merkle_path);
            prop_assert_eq!(deep_polynomial_openings.lde_trace_evaluations, deserialized.lde_trace_evaluations);
        }
    }
}
