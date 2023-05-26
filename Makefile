.PHONY: test clippy

test:
	cargo test

clippy:
	cargo clippy --workspace --all-targets -- -D warnings
