use sha3::{Digest, Keccak256};

/// Build data with the concatenation of transcript hash and value.
/// Computes the hash of this element and returns the number of
/// leading zeros in the resulting value (in the big-endian representation).
///
/// # Parameters
///
/// * `transcript_challenge` - the hash value obtained from the transcript
/// * `value` - the value to be concatenated with the transcript hash
/// (i.e. a candidate nonce).
///
/// # Returns
///
/// The number of leading zeros in the resulting hash value.
#[inline(always)]
pub fn hash_transcript_with_int_and_get_leading_zeros(
    transcript_challenge: &[u8; 32],
    value: u64,
) -> u8 {
    let mut data = [0; 40];
    data[..32].copy_from_slice(transcript_challenge);
    data[32..].copy_from_slice(&value.to_le_bytes());

    let digest = Keccak256::digest(data);

    let seed_head = u64::from_le_bytes(digest[..8].try_into().unwrap());
    seed_head.trailing_zeros() as u8
}
