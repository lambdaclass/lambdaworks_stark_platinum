use super::errors::InsecureOptionError;

/// The options for the proof
///
/// - `blowup_factor`: the blowup factor for the trace
/// - `fri_number_of_queries`: the number of queries for the FRI layer
/// - `coset_offset`: the offset for the coset
/// - `grinding_factor`: the number of leading zeros that we want for the Hash(hash || nonce)
#[derive(Clone, Debug)]
pub struct ProofOptions {
    pub blowup_factor: u8,
    pub fri_number_of_queries: usize,
    pub coset_offset: u64,
    pub grinding_factor: u8,
}

impl ProofOptions {
    pub fn new_with_checked_security(
        blowup_factor: u8,
        fri_number_of_queries: usize,
        coset_offset: u64,
        grinding_factor: u8,
    ) -> Result<Self, InsecureOptionError> {
        Ok(ProofOptions {
            blowup_factor,
            fri_number_of_queries,
            coset_offset,
            grinding_factor,
        })
    }
}
