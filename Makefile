.PHONY: test clippy
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

TEST_DIR=cairo_programs
CAIRO_PROGRAMS:=$(wildcard $(TEST_DIR)/*.cairo)
COMPILED_PROGRAMS:=$(patsubst $(TEST_DIR)/%.cairo, $(TEST_DIR)/%.json, $(CAIRO_PROGRAMS))

$(TEST_DIR)/%.json: $(TEST_DIR)/%.cairo
	cairo-compile --cairo_path="$(TEST_DIR)" $< --output $@

build: 
	cargo build --release

run: build
	cargo run --release $(PROGRAM_PATH)
	
test: $(COMPILED_PROGRAMS)
	cargo test

clippy:
	cargo clippy --workspace --all-targets -- -D warnings

build_metal:
	cargo b --features metal --release

docker_build_cairo_compiler:
	docker build -f cairo_compile.Dockerfile -t cairo .	
	
docker_compile_cairo:
	docker run -v $(ROOT_DIR):/pwd cairo cairo-compile /pwd/$(PROGRAM) > $(OUTPUT)

target/release/lambdaworks-stark: 
	cargo build --release
	
docker_compile_and_run: target/release/lambdaworks-stark
	@echo "Compiling program with docker"
	@docker run -v $(ROOT_DIR):/pwd cairo cairo-compile /pwd/$(PROGRAM) > $(PROGRAM).json
	@echo "Compiling done \n"
	@cargo run --features instruments --quiet --release $(PROGRAM).json 
	@rm $(PROGRAM).json

compile_and_run: target/release/lambdaworks-stark
	@echo "Compiling program with cairo-compile"
	@cairo-compile $(PROGRAM) > $(PROGRAM).json
	@echo "Compiling done \n"
	@cargo run --features instruments --quiet --release $(PROGRAM).json 
	@rm $(PROGRAM).json

clean:
	rm -f $(TEST_DIR)/*.json

