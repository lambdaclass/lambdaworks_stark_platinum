pub use lambdaworks_crypto::fiat_shamir::transcript::Transcript;
use lambdaworks_crypto::merkle_tree::proof::Proof;
use lambdaworks_math::elliptic_curve::short_weierstrass::errors::DeserializationError;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsField;
use lambdaworks_math::traits::{ByteConversion, Deserializable, Serializable};

use crate::starks::utils::{deserialize_proof, serialize_proof};

use super::Commitment;

#[derive(Debug, Clone)]
pub struct FriDecommitment<F: IsField> {
    pub layers_auth_paths_sym: Vec<Proof<Commitment>>,
    pub layers_evaluations_sym: Vec<FieldElement<F>>,
    pub first_layer_evaluation: FieldElement<F>,
    pub first_layer_auth_path: Proof<Commitment>,
}

impl<F> Serializable for FriDecommitment<F>
where
    F: IsField,
    FieldElement<F>: ByteConversion,
{
    fn serialize(&self) -> Vec<u8> {
        let mut bytes = vec![];
        bytes.extend(self.layers_auth_paths_sym.len().to_be_bytes());
        for proof in &self.layers_auth_paths_sym {
            bytes.extend(serialize_proof(proof));
        }
        let first_layer_evaluation_bytes = self.first_layer_evaluation.to_bytes_be();
        let felt_len = first_layer_evaluation_bytes.len();
        bytes.extend(felt_len.to_be_bytes());
        bytes.extend(self.layers_evaluations_sym.len().to_be_bytes());
        for evaluation in &self.layers_evaluations_sym {
            bytes.extend(evaluation.to_bytes_be());
        }
        bytes.extend(first_layer_evaluation_bytes);
        bytes.extend(serialize_proof(&self.first_layer_auth_path));
        bytes
    }
}

impl<F> Deserializable for FriDecommitment<F>
where
    F: IsField,
    FieldElement<F>: ByteConversion,
{
    fn deserialize(bytes: &[u8]) -> Result<Self, DeserializationError>
    where
        Self: Sized,
    {
        let mut bytes = bytes;
        let mut layers_auth_paths_sym = vec![];
        let layers_auth_paths_sym_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        for _ in 0..layers_auth_paths_sym_len {
            let proof;
            (proof, bytes) = deserialize_proof(bytes)?;
            layers_auth_paths_sym.push(proof);
        }

        let felt_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        let layers_evaluations_sym_len = usize::from_be_bytes(
            bytes[..8]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[8..];

        let mut layers_evaluations_sym = vec![];
        for _ in 0..layers_evaluations_sym_len {
            let evaluation = FieldElement::<F>::from_bytes_be(
                bytes[..felt_len]
                    .try_into()
                    .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
            )?;
            bytes = &bytes[felt_len..];
            layers_evaluations_sym.push(evaluation);
        }

        let first_layer_evaluation = FieldElement::<F>::from_bytes_be(
            bytes[..felt_len]
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        )?;
        bytes = &bytes[felt_len..];

        let (first_layer_auth_path, _) = deserialize_proof(bytes)?;

        Ok(Self {
            layers_auth_paths_sym,
            layers_evaluations_sym,
            first_layer_evaluation,
            first_layer_auth_path,
        })
    }
}

#[cfg(test)]
mod tests {
    use lambdaworks_crypto::merkle_tree::proof::Proof;
    use lambdaworks_math::field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    };
    use proptest::{collection, prelude::*, prop_compose, proptest};

    use crate::starks::fri::{fri_decommit::FriDecommitment, Commitment};
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

    proptest! {
        #![proptest_config(
            ProptestConfig::default()
          )]
        #[test]
        fn test_serialize_and_deserialize(fri_decommitment in some_fri_decommitment()) {
            let serialized = fri_decommitment.serialize();
            let deserialized: FriDecommitment<Stark252PrimeField> = FriDecommitment::deserialize(&serialized).unwrap();

            for (a, b) in fri_decommitment.layers_auth_paths_sym.iter().zip(deserialized.layers_auth_paths_sym.iter()) {
                prop_assert_eq!(&a.merkle_path, &b.merkle_path);
            }

            for (a, b) in fri_decommitment.layers_evaluations_sym.iter().zip(deserialized.layers_evaluations_sym.iter()) {
                prop_assert_eq!(a, b);
            }

            prop_assert_eq!(fri_decommitment.first_layer_evaluation, deserialized.first_layer_evaluation);

            prop_assert_eq!(fri_decommitment.first_layer_auth_path.merkle_path, deserialized.first_layer_auth_path.merkle_path);

        }
    }
}
