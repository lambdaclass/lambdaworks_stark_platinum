use lambdaworks_math::field::traits::IsPrimeField;

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
    const NUM_SECURITY_BITS: usize = 128;
    // TODO: Make it work for extended fields
    const EXTENSION_DEGREE: usize = 1;
    // Estimated maximum domain size. 2^40 = 1 TB
    const NUM_BITS_MAX_DOMAIN_SIZE: usize = 40;

    pub fn new_with_checked_security<F: IsPrimeField>(
        blowup_factor: u8,
        fri_number_of_queries: usize,
        coset_offset: u64,
        grinding_factor: u8,
    ) -> Result<Self, InsecureOptionError> {
        Self::check_field_security::<F>()?;

        let num_bits_blowup_factor = blowup_factor.leading_zeros() as usize;

        if Self::NUM_SECURITY_BITS
            < grinding_factor as usize + num_bits_blowup_factor * fri_number_of_queries - 1
        {
            return Err(InsecureOptionError::SecurityBits);
        }

        Ok(ProofOptions {
            blowup_factor,
            fri_number_of_queries,
            coset_offset,
            grinding_factor,
        })
    }

    pub fn new_with_checked_provable_security<F: IsPrimeField>(
        blowup_factor: u8,
        fri_number_of_queries: usize,
        coset_offset: u64,
        grinding_factor: u8,
    ) -> Result<Self, InsecureOptionError> {
        Self::check_field_security::<F>()?;

        let num_bits_blowup_factor = blowup_factor.leading_zeros() as usize;

        if Self::NUM_SECURITY_BITS
            < grinding_factor as usize + num_bits_blowup_factor * fri_number_of_queries / 2
        {
            return Err(InsecureOptionError::SecurityBits);
        }

        Ok(ProofOptions {
            blowup_factor,
            fri_number_of_queries,
            coset_offset,
            grinding_factor,
        })
    }

    fn check_field_security<F: IsPrimeField>() -> Result<(), InsecureOptionError> {
        if F::field_bit_size() * Self::EXTENSION_DEGREE
            <= Self::NUM_SECURITY_BITS + Self::NUM_BITS_MAX_DOMAIN_SIZE
        {
            return Err(InsecureOptionError::FieldSize);
        }

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use lambdaworks_math::field::fields::{
        fft_friendly::stark_252_prime_field::Stark252PrimeField, u64_prime_field::F17,
    };

    use crate::starks::proof::errors::InsecureOptionError;

    use super::ProofOptions;

    #[test]
    fn stark_prime_field_is_large_enough_to_be_secure() {
        let options = ProofOptions::new_with_checked_security::<Stark252PrimeField>(1, 1, 1, 1);

        assert!(options.is_ok());
    }

    #[test]
    fn u64_prime_field_is_not_large_enough_to_be_secure() {
        let options = ProofOptions::new_with_checked_security::<F17>(1, 1, 1, 1);

        assert!(matches!(options, Err(InsecureOptionError::FieldSize)));
    }

    #[test]
    fn proof_options_are_insecure_for_too_many_fri_queries() {
        let fri_number_of_queries = 130;
        let options = ProofOptions::new_with_checked_security::<Stark252PrimeField>(
            1,
            fri_number_of_queries,
            1,
            1,
        );

        assert!(matches!(options, Err(InsecureOptionError::SecurityBits)));
    }

    #[test]
    fn proof_options_are_insecure_to_be_provable_for_too_many_fri_queries() {
        let fri_number_of_queries = 260;
        let options = ProofOptions::new_with_checked_security::<Stark252PrimeField>(
            1,
            fri_number_of_queries,
            1,
            1,
        );

        assert!(matches!(options, Err(InsecureOptionError::SecurityBits)));
    }
}
