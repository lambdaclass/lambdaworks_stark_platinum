<div align="center">

# 🌟 Lambdaworks Stark Platinum Prover 🌟

<img src="https://github.com/lambdaclass/lambdaworks_stark_platinum/assets/569014/ad8d7943-f011-49b5-a0c5-f07e5ef4133e" alt="drawing" width="300"/>

## An open-source STARK prover, drop-in replacement for Winterfell.

</div>

## ⚠️ Disclaimer

This prover is still in development and may contain bugs. It is not intended to be used in production yet. 

Please check issues under security label, and wait for them to be resolved if they are relevant your project.

Output builtin is finished, and range check is supported but it's not sound yet. 

We expect to have something working in a good state by mid August 2023.

CLI currently runs with 100 bits of conjecturable security

## Table of Contents

- [Main Building Blocks](#main-building-blocks)
- [Requirements](#requirements)
- [Trying it](#how-to-try-it)
- [Prove and verify](#-prove-and-verify)
- [Fuzzers](#running-fuzzers)
- [Using cairo-compile for Cairo 0 programs](#using-cairo-compile-for-cairo-0-programs)
- [References](#-references)
- [Related projects](#-related-projects)

## Main building blocks

- [STARKS](https://github.com/lambdaclass/lambdaworks_cairo_prover/tree/main/src/starks): Everything related to STARKs building blocks such as the prover, verifier and FRI.
- [Cairo](https://github.com/lambdaclass/lambdaworks_cairo_prover/tree/main/src/cairo): Implementation of the Cairo AIR.

To be added:

-  Add winterfell api compatibility
-  Add parameters for proving and verifying in the CLI / (Public inputs should be serialized and deserialized)
-  Add Cairo compilation inside Rust, to prove and verify Cairo1/Cairo2 from the .cairo file, instead of the .casm file
-  Add last constraint of Range Check Built In
-  Add more parallelization
-  Benchmarks and optimizations for Graviton
-  Bitwise Builtin
-  Cairo Verifier
   - Batch verifier / For trees and N proofs
-  Chiplet support
-  Cuda with Icicle for FTT/NTT
-  Different layouts
-  DSL Plonk
-  Extension fields in Starks
-  Fix "enforce selector" security bug
-  Fix benches against other Field libraries, so results are more stable
-  HyperPlonk - Ultraplonk
-  Improve profiling with multithread
-  JSON serialization for proofs
-  Optimizations
  - Skip layers
  - Stop FRI
  - Batch FRI queries (improves proof size)
  - Others
-  Optimized backend for mini goldilocks
-  Pedersen Builtin
-  Pick hash configuration with ProofOptions
-  Poseidon Builtin
-  Poseidon Hash
   - Poseidon Tree 
   - Poseidon Batch Tree
-  Proof of concept of Wasm application running the verifier
-  Quality of life functions (to_decimal_string, from_decimal_string)
-  Sha256 Builtin
-  Sharp compatibility
-  Solidity Verifier
-  Support FFTx for CUDA
-  Tracing tools
-  Virtual columns
-  Vulkan support for FFT
-  Winterfell compatible API

## Requirements

- Cargo 1.69+
  
## How to try it

For the moment, only programs in Cairo 0 with no arguments and contracts in Cairo 1 with no arguments are supported.

### 🚀 Prove and verify

To prove Cairo programs you can use:

```bash
make prove PROGRAM_PATH=<compiled_program_path> PROOF_PATH=<output_proof_path>
```

To verify a proof you can use:
  
```bash
make verify PROOF_PATH=<proof_path>
```

For example:

```bash
make prove PROGRAM_PATH=fibonacci.json PROOF_PATH=fibonacci_proof
make verify PROOF_PATH=fibonacci_proof
```

To prove and verify with a single command you can use:

```bash
make run_all PROGRAM_PATH=<proof_path>
```


### Using Docker compiler for Cairo 0 programs

Build the compiler image with:

```bash
make docker_build_cairo_compiler
```

Then for example, if you have a Cairo program in the project folder, you can use:

```bash
make docker_compile_and_run_all PROGRAM=program_name.cairo
```

Or

```bash
make docker_compile_and_prove PROGRAM=program_name.cairo PROOF_PATH=proof_path
```

### Using cairo-compile for Cairo 0 programs

If you have `cairo-lang` installed, you can use it instead of the Dockerfile

Then for example, if you have some Cairo program in the project folder, you can use:

```bash
make compile_and_run_all PROGRAM=program_name.cairo
```

Or 

```bash
make compile_and_prove PROGRAM=program_name.cairo PROOF_PATH=proof_path
```

### Compiling Cairo 1 contracts

Clone `cairo` repository:

``` bash
git clone https://github.com/starkware-libs/cairo
```

Checkout version 1.1.0 (corresponding to that tag of the repository). In the `cairo` folder, run:

``` bash
git checkout v1.1.0
```

- To create json file from Cairo contract:

  ``` bash
  cargo run --bin starknet-compile -- /path/to/input.cairo /path/to/output.json
  ```

- To create casm file from json file:

  ``` bash
  cargo run --bin starknet-sierra-compile -- /path/to/input.json /path/to/output.casm
  ```

## Running tests
To run tests, simply use
```
make test
```
If you have the `cairo-lang` toolchain installed, this will compile the Cairo programs needed
for tests.
If you have built the cairo-compile docker image, that will be used for compiling instead.

Be sure to build the docker image if you don't want to install the `cairo-lang` toolchain:
```
make docker_build_cairo_compiler
```

## Running fuzzers
To run a fuzzer, simply use 

```
make fuzzer <name of the fuzzer>
```

if you don´t have the tools for fuzzing installed use

```
make fuzzer_tools
```

## 📚 References

- [Winterfell](https://github.com/facebook/winterfell)
- [Anatomy of a Stark](https://aszepieniec.github.io/stark-anatomy/overview)
- [Giza](https://github.com/maxgillett/giza)
- [Ministark](https://github.com/andrewmilson/ministark)
- [Sandstorm](https://github.com/andrewmilson/sandstorm)
- [STARK-101](https://starkware.co/stark-101/)
- [Summary on FRI low degree test](https://eprint.iacr.org/2022/1216)
- [STARKs paper](https://eprint.iacr.org/2018/046)
- [DEEP FRI](https://eprint.iacr.org/2019/336)
- [BrainSTARK](https://aszepieniec.github.io/stark-brainfuck/)
- [Thank goodness it's FRIday](https://vitalik.ca/general/2017/11/22/starks_part_2.html)
- [Diving DEEP FRI](https://blog.lambdaclass.com/diving-deep-fri/)
- [Periodic constraints](https://blog.lambdaclass.com/periodic-constraints-and-recursion-in-zk-starks/)
- [Chiplets Miden VM](https://wiki.polygon.technology/docs/miden/design/chiplets/main/)
- [Valida](https://github.com/valida-xyz/valida/tree/main)
- [Solidity Verifier](https://github.com/starkware-libs/starkex-contracts/tree/master/evm-verifier/solidity/contracts/cpu)
- [EthSTARK](https://github.com/starkware-libs/ethSTARK/tree/master)
- [CAIRO whitepaper](https://eprint.iacr.org/2021/1063.pdf)

## 🌞 Related Projects

- [CAIRO VM - Rust](https://github.com/lambdaclass/cairo-vm)
- [CAIRO VM - Go](https://github.com/lambdaclass/cairo_vm.go)
- [Lambdaworks](https://github.com/lambdaclass/lambdaworks)
- [CAIRO native](https://github.com/lambdaclass/cairo_native/)
- [StarkNet in Rust](https://github.com/lambdaclass/starknet_in_rust)