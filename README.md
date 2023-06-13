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
