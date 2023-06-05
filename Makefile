.PHONY: test clippy

test:
	cargo test

clippy:
	cargo clippy --workspace --all-targets -- -D warnings

# BENCHMARK should be one of the [[bench]] names in Cargo.toml
# Benchmark groups are filtered by name, according to FILTER
# Example: make benchmark BENCH=criterion_field FILTER=CAIRO/fibonacci/50_b4_q64
benchmark:
	cargo criterion --features=metal --bench ${BENCH} -- ${FILTER}

# Benchmark groups are filtered by name, according to FILTER
# Example: make flamegraph BENCH=criterion_field FILTER=CAIRO/fibonacci/50_b4_q64
flamegraph:
	CARGO_PROFILE_BENCH_DEBUG=true cargo flamegraph --root --bench ${BENCH} -- --bench ${FILTER}

build_metal:
	cargo b --features metal --release
