pub fn cairo0_program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const CAIRO0_BASE_REL_PATH: &str = "/cairo_programs/cairo0/";
    let program_base_path = CARGO_DIR.to_string() + CAIRO0_BASE_REL_PATH;
    program_base_path + program_name
}

pub fn cairo1_program_path(program_name: &str) -> String {
    const CARGO_DIR: &str = env!("CARGO_MANIFEST_DIR");
    const CAIRO1_BASE_REL_PATH: &str = "/cairo_programs/cairo1/";
    let program_base_path = CARGO_DIR.to_string() + CAIRO1_BASE_REL_PATH;
    program_base_path + program_name
}

/// Loads the program in path, runs it with the Cairo VM, and makes a proof of it
pub fn test_prove_cairo_program(file_path: &str, output_range: &Option<Range<u64>>) {
    let proof_options = ProofOptions::default_test_options();

    let program_content = std::fs::read(file_path).unwrap();
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V0, output_range).unwrap();
    let proof = generate_cairo_proof(&main_trace, &pub_inputs, &proof_options).unwrap();

    assert!(verify_cairo_proof(&proof, &pub_inputs, &proof_options));
}

/// Loads the program in path, runs it with the Cairo VM, and makes a proof of it
pub fn test_prove_cairo1_program(file_path: &str) {
    let proof_options = ProofOptions::default_test_options();
    let program_content = std::fs::read(file_path).unwrap();
    let (main_trace, pub_inputs) =
        generate_prover_args(&program_content, &CairoVersion::V1, &None).unwrap();
    let proof = generate_cairo_proof(&main_trace, &pub_inputs, &proof_options).unwrap();

    assert!(verify_cairo_proof(&proof, &pub_inputs, &proof_options));
}

fn create_memory_segment_map(
    range_check_builtin_range: Option<Range<u64>>,
    output_range: &Option<Range<u64>>,
) -> MemorySegmentMap {
    let mut memory_segments = MemorySegmentMap::new();

    if let Some(range_check_builtin_range) = range_check_builtin_range {
        memory_segments.insert(MemorySegment::RangeCheck, range_check_builtin_range);
    }
    if let Some(output_range) = output_range {
        memory_segments.insert(MemorySegment::Output, output_range.clone());
    }

    memory_segments
}
