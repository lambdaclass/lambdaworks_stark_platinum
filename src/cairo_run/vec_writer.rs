use bincode::enc::write::Writer;
use std::io::{self, Write};

pub struct VecWriter<'a> {
    buf_writer: &'a mut Vec<u8>,
}

impl Writer for VecWriter<'_> {
    fn write(&mut self, bytes: &[u8]) -> Result<(), bincode::error::EncodeError> {
        self.buf_writer
            .write_all(bytes)
            .expect("Shouldn't fail in memory vector");

        Ok(())
    }
}

impl<'a> VecWriter<'a> {
    pub fn new(vec: &'a mut Vec<u8>) -> Self {
        Self {
            buf_writer: vec 
        }
    }

    pub fn flush(&mut self) -> io::Result<()> {
        self.buf_writer.flush()
    }
}
