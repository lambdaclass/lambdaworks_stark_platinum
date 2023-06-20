pub mod air;
pub mod cairo_run;
pub mod cairo_vm;
pub mod fri;
pub mod proof;
pub mod prover;
pub mod verifier;

use std::marker::PhantomData;

use air::traits::AIR;
use lambdaworks_crypto::{
    fiat_shamir::transcript::Transcript, merkle_tree::traits::IsMerkleTreeBackend,
};
use lambdaworks_math::fft::roots_of_unity::get_powers_of_primitive_root_coset;
use lambdaworks_math::{
    field::{
        element::FieldElement,
        fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
        traits::{IsFFTField, IsField, IsPrimeField},
    },
    traits::ByteConversion,
};
use sha3::{Digest, Sha3_256};

pub struct ProofConfig {
    pub count_queries: usize,
    pub blowup_factor: usize,
}

pub type PrimeField = Stark252PrimeField;
pub type FE = FieldElement<PrimeField>;

/// Uses randomness from the transcript to create a FieldElement
/// One bit less than the max used by the FieldElement is used as randomness. For StarkFields, this would be 251 bits randomness.
/// Randomness is interpreted as limbs in BigEndian, and each Limb is ordered in BigEndian
pub fn transcript_to_field<F: IsPrimeField, T: Transcript>(transcript: &mut T) -> FieldElement<F>
where
    FieldElement<F>: ByteConversion,
{
    let mut randomness = transcript.challenge();
    randomness_to_field(&mut randomness)
}

/// Transforms some random bytes to a field
/// Slicing the randomness to one bit less than what the max number of the field is to ensure each random element has the same probability of appearing
fn randomness_to_field<F: IsPrimeField>(randomness: &mut [u8; 32]) -> FieldElement<F>
where
    FieldElement<F>: ByteConversion,
{
    let random_bits_required = F::field_bit_size() - 1;
    let random_bits_created = randomness.len() * 8;
    let mut bits_to_clear = random_bits_created - random_bits_required;

    let mut i = 0;
    while bits_to_clear >= 8 {
        randomness[i] = 0;
        bits_to_clear -= 8;
        i += 1;
    }

    let pre_mask: u8 = 1u8.checked_shl(8 - bits_to_clear as u32).unwrap_or(0);
    let mask: u8 = pre_mask.wrapping_sub(1);
    randomness[i] &= mask;

    FieldElement::from_bytes_be(randomness).unwrap()
}

pub fn transcript_to_usize<T: Transcript>(transcript: &mut T) -> usize {
    const CANT_BYTES_USIZE: usize = (usize::BITS / 8) as usize;
    let value = transcript.challenge()[..CANT_BYTES_USIZE]
        .try_into()
        .unwrap();
    usize::from_be_bytes(value)
}

pub fn sample_z_ood<F: IsPrimeField, T: Transcript>(
    lde_roots_of_unity_coset: &[FieldElement<F>],
    trace_roots_of_unity: &[FieldElement<F>],
    transcript: &mut T,
) -> FieldElement<F>
where
    FieldElement<F>: ByteConversion,
{
    loop {
        let value: FieldElement<F> = transcript_to_field(transcript);
        if !lde_roots_of_unity_coset.iter().any(|x| x == &value)
            && !trace_roots_of_unity.iter().any(|x| x == &value)
        {
            return value;
        }
    }
}

pub fn batch_sample_challenges<F: IsFFTField, T: Transcript>(
    size: usize,
    transcript: &mut T,
) -> Vec<FieldElement<F>>
where
    FieldElement<F>: ByteConversion,
{
    (0..size).map(|_| transcript_to_field(transcript)).collect()
}

pub struct Domain<F: IsFFTField> {
    root_order: u32,
    lde_roots_of_unity_coset: Vec<FieldElement<F>>,
    lde_root_order: u32,
    trace_primitive_root: FieldElement<F>,
    trace_roots_of_unity: Vec<FieldElement<F>>,
    coset_offset: FieldElement<F>,
    blowup_factor: usize,
    interpolation_domain_size: usize,
}

impl<F: IsFFTField> Domain<F> {
    fn new<A: AIR<Field = F>>(air: &A) -> Self {
        // Initial definitions
        let blowup_factor = air.options().blowup_factor as usize;
        let coset_offset = FieldElement::<F>::from(air.options().coset_offset);
        let interpolation_domain_size = air.context().trace_length;
        let root_order = air.context().trace_length.trailing_zeros();
        // * Generate Coset
        let trace_primitive_root = F::get_primitive_root_of_unity(root_order as u64).unwrap();
        let trace_roots_of_unity = get_powers_of_primitive_root_coset(
            root_order as u64,
            interpolation_domain_size,
            &FieldElement::<F>::one(),
        )
        .unwrap();

        let lde_root_order = (air.context().trace_length * blowup_factor).trailing_zeros();
        let lde_roots_of_unity_coset = get_powers_of_primitive_root_coset(
            lde_root_order as u64,
            air.context().trace_length * blowup_factor,
            &coset_offset,
        )
        .unwrap();

        Self {
            root_order,
            lde_roots_of_unity_coset,
            lde_root_order,
            trace_primitive_root,
            trace_roots_of_unity,
            blowup_factor,
            coset_offset,
            interpolation_domain_size,
        }
    }
}

/// A Merkle tree backend for vectors of field elements.
/// This is used by the Stark prover to commit to
/// multiple trace columns using a single Merkle tree.
#[derive(Clone)]
pub struct BatchStarkProverBackend<F> {
    phantom: PhantomData<F>,
}

impl<F> Default for BatchStarkProverBackend<F> {
    fn default() -> Self {
        Self {
            phantom: PhantomData,
        }
    }
}

impl<F> IsMerkleTreeBackend for BatchStarkProverBackend<F>
where
    F: IsField,
    FieldElement<F>: ByteConversion,
{
    type Node = [u8; 32];
    type Data = Vec<FieldElement<F>>;

    fn hash_data(&self, input: &Vec<FieldElement<F>>) -> [u8; 32] {
        let mut hasher = Sha3_256::new();
        for element in input.iter() {
            hasher.update(element.to_bytes_be());
        }
        let mut result_hash = [0_u8; 32];
        result_hash.copy_from_slice(&hasher.finalize());
        result_hash
    }

    fn hash_new_parent(&self, left: &[u8; 32], right: &[u8; 32]) -> [u8; 32] {
        let mut hasher = Sha3_256::new();
        hasher.update(left);
        hasher.update(right);
        let mut result_hash = [0_u8; 32];
        result_hash.copy_from_slice(&hasher.finalize());
        result_hash
    }
}

#[cfg(test)]
mod tests {
    use lambdaworks_math::{
        field::{
            element::FieldElement,
            fields::{
                fft_friendly::stark_252_prime_field::Stark252PrimeField,
                montgomery_backed_prime_fields::{IsModulus, U256PrimeField},
            },
        },
        unsigned_integer::element::U256,
    };

    use crate::randomness_to_field;

    #[test]
    fn test_stark_prime_field_random_to_field_32() {
        #[rustfmt::skip]
        let mut randomness: [u8; 32] = [
            248, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0, 0, 32, 
        ];

        type FE = FieldElement<Stark252PrimeField>;
        let field_element: FE = randomness_to_field(&mut randomness);
        let expected_fe = FE::from(32u64);
        assert_eq!(field_element, expected_fe)
    }

    #[test]
    fn test_stark_prime_field_random_to_fiel_repeated_f_and_zero() {
        #[rustfmt::skip]
        let mut randomness: [u8; 32] = [
            255, 0, 255, 0, 255, 0, 255, 0,
            255, 0, 255, 0, 255, 0, 255, 0, 
            255, 0, 255, 0, 255, 0, 255, 0, 
            255, 0, 255, 0, 255, 0, 255, 0,
        ];

        type FE = FieldElement<Stark252PrimeField>;

        // 251 bits should be used (252 of StarkField - 1) to avoid duplicates
        // This leaves a 7
        let expected_fe = FE::from_hex_unchecked(
            "\
            0700FF00FF00FF00\
            FF00FF00FF00FF00\
            FF00FF00FF00FF00\
            FF00FF00FF00FF00",
        );

        let field_element: FE = randomness_to_field(&mut randomness);

        println!("{}", field_element.representative().to_string());

        assert_eq!(field_element, expected_fe)
    }

    #[test]
    fn test_241_bit_random_to_field() {
        #[derive(Clone, Debug)]
        pub struct TestModulus;
        impl IsModulus<U256> for TestModulus {
            const MODULUS: U256 = U256::from_hex_unchecked(
                "\
                0001000000000011\
                0000000000000000\
                0000000000000000\
                0000000000000001",
            );
        }

        pub type TestField = U256PrimeField<TestModulus>;

        #[rustfmt::skip]
        let mut randomness: [u8; 32] = [
            255, 255, 255, 1, 2, 3, 4, 5, 
            6, 7, 8, 1, 2, 3, 4, 5, 
            6, 7, 8, 1, 2, 3, 4, 5, 
            6, 7, 8, 1, 2, 3, 4, 5,
        ];

        type FE = FieldElement<TestField>;

        let expected_fe = FE::from_hex_unchecked(
            "\
            0000FF0102030405\
            0607080102030405\
            0607080102030405\
            0607080102030405",
        );

        let field_element: FE = randomness_to_field(&mut randomness);

        assert_eq!(field_element, expected_fe);
    }

    #[test]
    fn test_249_bit_random_to_field() {
        #[derive(Clone, Debug)]
        pub struct TestModulus;
        impl IsModulus<U256> for TestModulus {
            const MODULUS: U256 = U256::from_hex_unchecked(
                "\
                0200000000000011\
                0000000000000000\
                0000000000000000\
                0000000000000001",
            );
        }

        pub type TestField = U256PrimeField<TestModulus>;

        #[rustfmt::skip]
        let mut randomness: [u8; 32] = [
            255, 0, 255, 0, 255, 0, 255, 0,
            255, 0, 255, 0, 255, 0, 255, 0, 
            255, 0, 255, 0, 255, 0, 255, 0, 
            255, 0, 255, 0, 255, 0, 255, 0,
        ];

        let expected_fe = FE::from_hex_unchecked(
            "\
                0100FF00FF00FF00\
                FF00FF00FF00FF00\
                FF00FF00FF00FF00\
                FF00FF00FF00FF00",
        );

        type FE = FieldElement<TestField>;

        let field_element: FE = randomness_to_field(&mut randomness);

        assert_eq!(field_element, expected_fe)
    }
}
