use thiserror::Error;

#[derive(Debug, Error)]
pub enum InsecureOptionError {
    #[error("Field size is not large enough")]
    FieldSize,
}
