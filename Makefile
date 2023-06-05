.PHONY: test clippy

test:
	cargo test

clippy:
	cargo clippy --workspace --all-targets -- -D warnings

build_metal:
	cargo b --features metal --release
