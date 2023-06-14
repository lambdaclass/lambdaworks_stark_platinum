# Lambdaworks Cairo Prover

We're still moving all the code from [LambdaWorks](https://github.com/lambdaclass/lambdaworks) related to the STARK Cairo prover. 
The CI, the documentation and the GPU code hasn't yet been yet migrated.

## Main building blocks

- [AIR](https://github.com/lambdaclass/lambdaworks_cairo_prover/tree/main/src/air)
- [FRI protocol](https://github.com/lambdaclass/lambdaworks_cairo_prover/tree/main/src/fri)
- [Verifier](https://github.com/lambdaclass/lambdaworks_cairo_prover/blob/main/src/verifier.rs)
- [CairoVM](https://github.com/lambdaclass/lambdaworks_cairo_prover/tree/main/src/cairo_vm)

To be added:
- Grinding
- Skipping FRI layers
- Optimizing verifier operations
- Range check and Pedersen built-ins
- Different layouts

## How to try it

You can generate a proof for a compiled program with Cairo 0.11 and verify using `make run` or `cairo run`

For example, if you have a `program.json` in the project folder, you can use:

`make run PROGRAM_PATH=program.json`

or

`cargo run --release program.json`
## Compiling Cairo Programs to prove

You can compile a program using `cairo-compile`, which requires `python3.9` and `cairo-lang`

As an alternative, you can use the `Dockerfile` provided. 

Build it with:

`make docker_build_cairo_compiler`

and compile programs with:

`make docker_compile_cairo PROGRAM=program.cairo OUTPUT=program.json`
