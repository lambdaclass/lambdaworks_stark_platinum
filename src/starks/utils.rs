use lambdaworks_crypto::merkle_tree::proof::Proof;
use lambdaworks_math::errors::DeserializationError;

use super::config::Commitment;

pub fn serialize_proof(proof: &Proof<Commitment>) -> Vec<u8> {
    let mut bytes = vec![];
    bytes.extend((proof.merkle_path.len() as u32).to_be_bytes());
    for commitment in &proof.merkle_path {
        bytes.extend(commitment);
    }
    bytes
}

const U32_SIZE: usize = core::mem::size_of::<u32>();

pub fn deserialize_proof(bytes: &[u8]) -> Result<(Proof<Commitment>, &[u8]), DeserializationError> {
    let mut bytes = bytes;
    let mut merkle_path = vec![];
    let merkle_path_len = u32::from_be_bytes(
        bytes
            .get(..U32_SIZE)
            .ok_or(DeserializationError::InvalidAmountOfBytes)?
            .try_into()
            .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
    );
    bytes = &bytes[U32_SIZE..];

    for _ in 0..merkle_path_len {
        let commitment = bytes
            .get(..32)
            .ok_or(DeserializationError::InvalidAmountOfBytes)?
            .try_into()
            .map_err(|_| DeserializationError::InvalidAmountOfBytes)?;
        merkle_path.push(commitment);
        bytes = &bytes[32..];
    }

    Ok((Proof { merkle_path }, bytes))
}

#[cfg(test)]
mod test {
    use lambdaworks_crypto::merkle_tree::proof::Proof;

    use crate::starks::utils::{serialize_proof, deserialize_proof};

    #[test]
    fn serialize_deserialize_proof() {
        let proof_value_a: [u8;32] = [42;32];
        let proof_value_b: [u8;32] = [31;32];

        let merkle_path = [proof_value_a,proof_value_b].to_vec();
        let proof = Proof {
            merkle_path
        };

        let serialized_proof = serialize_proof(&proof);
        let deserialized_proof = deserialize_proof(&serialized_proof).unwrap();
        assert_eq!(proof, deserialized_proof.0);
    
    }
}
