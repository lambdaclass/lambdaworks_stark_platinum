use lambdaworks_math::{
    errors::DeserializationError,
    field::{element::FieldElement, traits::IsFFTField},
    polynomial::Polynomial,
    traits::{ByteConversion, Deserializable, Serializable},
};

use super::trace::TraceTable;

#[derive(Clone, Debug, PartialEq)]
pub struct Frame<F: IsFFTField> {
    // Vector of rows
    pub data: Vec<FieldElement<F>>,
    row_width: usize,
}

const U32_SIZE: usize = core::mem::size_of::<u32>();

impl<F: IsFFTField> Frame<F> {
    pub fn new(data: Vec<FieldElement<F>>, row_width: usize) -> Self {
        Self { data, row_width }
    }

    pub fn num_rows(&self) -> usize {
        self.data.len() / self.row_width
    }

    pub fn num_columns(&self) -> usize {
        self.row_width
    }

    pub fn get_row(&self, row_idx: usize) -> &[FieldElement<F>] {
        let row_offset = row_idx * self.row_width;
        &self.data[row_offset..row_offset + self.row_width]
    }

    pub fn get_row_mut(&mut self, row_idx: usize) -> &mut [FieldElement<F>] {
        let row_offset = row_idx * self.row_width;
        &mut self.data[row_offset..row_offset + self.row_width]
    }

    pub fn read_from_trace(
        trace: &TraceTable<F>,
        step: usize,
        blowup: u8,
        offsets: &[usize],
    ) -> Self {
        // Get trace length to apply module with it when getting elements of
        // the frame from the trace.
        let trace_steps = trace.n_rows();
        let data = offsets
            .iter()
            .flat_map(|frame_row_idx| {
                trace
                    .get_row((step + (frame_row_idx * blowup as usize)) % trace_steps)
                    .to_vec()
            })
            .collect();

        Self::new(data, trace.n_cols)
    }

    /// Given a slice of trace polynomials, an evaluation point `x`, the frame offsets
    /// corresponding to the computation of the transitions, and a primitive root,
    /// outputs the trace evaluations of each trace polynomial over the values used to
    /// compute a transition.
    /// Example: For a simple Fibonacci computation, if t(x) is the trace polynomial of
    /// the computation, this will output evaluations t(x), t(g * x), t(g^2 * z).
    pub fn get_trace_evaluations(
        trace_polys: &[Polynomial<FieldElement<F>>],
        x: &FieldElement<F>,
        frame_offsets: &[usize],
        primitive_root: &FieldElement<F>,
    ) -> Vec<Vec<FieldElement<F>>> {
        frame_offsets
            .iter()
            .map(|offset| x * primitive_root.pow(*offset))
            .map(|eval_point| {
                trace_polys
                    .iter()
                    .map(|poly| poly.evaluate(&eval_point))
                    .collect::<Vec<FieldElement<F>>>()
            })
            .collect()
    }
}

impl<F> Serializable for Frame<F>
where
    F: IsFFTField,
    FieldElement<F>: ByteConversion,
{
    fn serialize(&self) -> Vec<u8> {
        let mut bytes = vec![];

        bytes.extend((self.data.len() as u32).to_be_bytes());

        // TODO: This should return an Error, we can't serialize an empty Frame
        let felt_len = if self.data.is_empty() {
            0_u32
        } else {
            self.data[0].to_bytes_be().len() as u32
        };

        bytes.extend(felt_len.to_be_bytes());

        for felt in &self.data {
            bytes.extend(felt.to_bytes_be());
        }
        bytes.extend((self.row_width as u32).to_be_bytes());
        bytes
    }
}

impl<F> Deserializable for Frame<F>
where
    F: IsFFTField,
    FieldElement<F>: ByteConversion,
{
    fn deserialize(bytes: &[u8]) -> Result<Self, DeserializationError>
    where
        Self: Sized,
    {
        let mut bytes = bytes;
        let data_len = u32::from_be_bytes(
            bytes
                .get(..U32_SIZE)
                .ok_or(DeserializationError::InvalidAmountOfBytes)?
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        );
        bytes = &bytes[U32_SIZE..];

        println!("Data len: {}", data_len);

        let felt_len = u32::from_be_bytes(
            bytes
                .get(..U32_SIZE)
                .ok_or(DeserializationError::InvalidAmountOfBytes)?
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        ) as usize;

        println!("Felt len: {}", felt_len);
        bytes = &bytes[U32_SIZE..];

        let mut data = vec![];

        for _ in 0..data_len {
            let felt = FieldElement::<F>::from_bytes_be(
                bytes
                    .get(..felt_len)
                    .ok_or(DeserializationError::InvalidAmountOfBytes)?,
            )?;
            data.push(felt);
            bytes = &bytes[felt_len..];
        }

        let row_width = u32::from_be_bytes(
            bytes
                .get(..U32_SIZE)
                .ok_or(DeserializationError::InvalidAmountOfBytes)?
                .try_into()
                .map_err(|_| DeserializationError::InvalidAmountOfBytes)?,
        ) as usize;

        Ok(Self::new(data, row_width))
    }
}

#[cfg(test)]
mod tests {
    use lambdaworks_math::field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    };
    use proptest::{collection, prelude::*, prop_compose, proptest};

    use crate::starks::frame::Frame;
    use lambdaworks_math::traits::{Deserializable, Serializable};

    type FE = FieldElement<Stark252PrimeField>;

    prop_compose! {
        fn some_felt()(base in any::<u64>(), exponent in any::<u128>()) -> FE {
            FE::from(base).pow(exponent)
        }
    }

    prop_compose! {
        fn field_vec()(vec in collection::vec(some_felt(), 3)) -> Vec<FE> {
            vec
        }
    }

    proptest! {
        #![proptest_config(ProptestConfig {cases: 1, .. ProptestConfig::default()})]
        #[test]
        fn test_serialize_and_deserialize(data in field_vec(), row_width in any::<u32>()) {
            let frame = Frame::new(data, row_width as usize);
            let serialized = frame.serialize();
            let deserialized: Frame<Stark252PrimeField> = Frame::deserialize(&serialized).unwrap();

            prop_assert_eq!(frame.data, deserialized.data);
            prop_assert_eq!(frame.row_width, deserialized.row_width);
        }
    }
}
