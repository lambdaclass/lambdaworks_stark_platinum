use lambdaworks_math::{
    field::{
        element::FieldElement,
        traits::{IsFFTField, IsField},
    },
    traits::ByteConversion,
};

use super::HASHER;
pub use super::{FriMerkleTree, Polynomial};
use lambdaworks_fft::polynomial::FFTPoly;

#[derive(Clone)]
pub struct FriLayer<F: IsField> {
    pub poly: Polynomial<FieldElement<F>>,
    pub evaluation: Vec<FieldElement<F>>,
    pub merkle_tree: FriMerkleTree<F>,
    pub coset_offset: FieldElement<F>,
    pub domain_size: usize,
}

impl<F> FriLayer<F>
where
    F: IsField + IsFFTField,
    FieldElement<F>: ByteConversion,
{
    pub fn new(
        poly: Polynomial<FieldElement<F>>,
        coset_offset: &FieldElement<F>,
        domain_size: usize,
    ) -> Self {
        let evaluation = poly
            .evaluate_offset_fft(1, Some(domain_size), coset_offset)
            .unwrap(); // TODO: return error

        let merkle_tree = FriMerkleTree::build(&evaluation, Box::new(HASHER));
        let coset_offset = coset_offset.square();
        let domain_size = domain_size / 2;

        Self {
            poly,
            evaluation: evaluation.to_vec(),
            merkle_tree,
            coset_offset,
            domain_size,
        }
    }
}
