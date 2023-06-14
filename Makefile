CC=gcc

.PHONY: test clippy
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

build: 
	cargo build --release

run: build
	cargo run --release $(PROGRAM_PATH)
	
test:
	cargo test

clippy:
	cargo clippy --workspace --all-targets -- -D warnings

build_metal:
	cargo b --features metal --release

docker_build_cairo_compiler:
	docker build -f cairo_compile.Dockerfile -t cairo .	
	
docker_compile_cairo:
	docker run -v $(ROOT_DIR):/pwd cairo cairo-compile /pwd/$(PROGRAM) > $(OUTPUT)

docker_compile_and_run:
	@echo "Compiling program with docker"
	@docker run -v $(ROOT_DIR):/pwd cairo cairo-compile /pwd/$(PROGRAM) > $(PROGRAM).json
	@echo "Compiling done"
	@cargo run --quiet --release $(PROGRAM).json 
	@rm $(PROGRAM).json

compile_and_run:
	@echo "Compiling program with cairo-compile"
	@cairo-compile $(PROGRAM) > $(PROGRAM).json
	@echo "Compiling done"
	@cargo run --quiet --release $(PROGRAM).json 
	@rm $(PROGRAM).json
