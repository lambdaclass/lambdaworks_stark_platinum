fn build_main_trace(
    &self,
    raw_trace: &Self::RawTrace,
    public_input: &mut Self::PublicInput,
) -> Result<TraceTable<Self::Field>, ProvingError> {
    let mut main_trace = build_cairo_execution_trace(&raw_trace.0, &raw_trace.1);

    pad_with_last_row(
        &mut main_trace,
        (public_input.program.len() >> 2) + 1,
        &MEMORY_COLUMNS,
    );

    let (missing_values, rc_min, rc_max) =
        get_missing_values_offset_columns(&main_trace, &[OFF_DST, OFF_OP0, OFF_OP1]);
    public_input.range_check_min = Some(rc_min);
    public_input.range_check_max = Some(rc_max);

    add_missing_values_to_offsets_column(&mut main_trace, missing_values);

    if self.context().trace_length < main_trace.n_rows() {
        return Err(ProvingError::WrongParameter(
            "Trace length is not large enough.".to_string(),
        ));
    }

    let padding = self.context().trace_length - main_trace.n_rows();
    pad_with_last_row(&mut main_trace, padding, &MEMORY_COLUMNS);

    Ok(main_trace)
}
