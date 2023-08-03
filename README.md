# Lambdaworks Stark Platinum Prover 

<img src="https://github.com/lambdaclass/lambdaworks_stark_platinum/assets/569014/ad8d7943-f011-49b5-a0c5-f07e5ef4133e" alt="drawing" width="300"/>

This prover is still in development and may contain bugs. It is not intended to be used in production yet. 

Please check issues under security label, and wait for them to be resolved if they are relevant your project.

Output builtin is finished, and range check is supported but it's not sound yet. 

We expect to have something working in a good state by mid August 2023.

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

### Prove and verify

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

## Benchmarks

To get the results of the table below, run

```
make benchmarks_table
```

The results shown are from the execution of a Fibonacci program.

Bits of security are used to ensure that the proof satisfies a certain conjuecturable security level.

First table has the results that are independent of the hardware used.

| n   | Trace length | Prover RAM | Proof size 80 bit security | Proof size 128 bit security |
|-----|--------------|------------|----------------------------|-----------------------------|
| 100 | 2^10         | 18.5 MB    | 270 KB                     | 476 KB                      |
| 500 | 2^12         | 75.5 MB    | 335 KB                     | 591 KB                      |
| 2k  | 2^14         | 302.1 MB   | 407 KB                     | 719 KB                      |
| 5k  | 2^16         | 1.2 GB     | 488 KB                     | 862 KB                      |
| 20k | 2^18         | 4.7 GB     | 576 KB                     | 1 MB                        |

Second table has the results of the execution on an Apple M1 with 4 E and 4 P cores and 16 GB of RAM:

<table>
    <tr>
        <th rowspan="2">Trace length</th>
        <th rowspan="2">Trace time</th>
        <th colspan="2" style="text-align:center">80 bit security</th>
        <th colspan="2" style="text-align:center">128 bit security</th>
    </tr>
    <tr>
        <th>Prover time</th>
        <th>Verifier time</th>
        <th>Prover time</th>
        <th>Verifier time</th>
    </tr>
    <tr>
        <td>2^10</td>
        <td>0.9 ms</td>
        <td>1.1 s</td>
        <td>3.1 ms</td>
        <td>1.1 s</td>
        <td>4.7 ms</td>
    </tr>
    <tr>
        <td>2^12</td>
        <td>5.3 ms</td>
        <td>335.5 ms</td>
        <td>7.6 ms</td>
        <td>336.4 ms</td>
        <td>9.5 ms</td>
    </tr>
    <tr>
        <td>2^14</td>
        <td>24.7 ms</td>
        <td>1.41 s</td>
        <td>26.4 ms</td>
        <td>1.42 s</td>
        <td>29 ms</td>
    </tr>
    <tr>
        <td>2^16</td>
        <td>77.2 ms</td>
        <td>5.8 s</td>
        <td>108.8 ms</td>
        <td>5.8 s</td>
        <td>113.9 ms</td>
    </tr>
    <tr>
        <td>2^18</td>
        <td>312 ms</td>
        <td>24.3 s</td>
        <td>477.4 ms</td>
        <td>24.3 s</td>
        <td>481.7 ms</td>
    </tr>
</table>

Third table has the results of the execution on an Intel Xeon Platinum with 4 cores and 16 GB of RAM:

<table>
     <tr>
        <th rowspan="2">Trace length</th>
        <th rowspan="2">Trace time</th>
        <th colspan="2" style="text-align:center">80 bit security</th>
        <th colspan="2" style="text-align:center">128 bit security</th>
    </tr>
    <tr>
        <th>Prover time</th>
        <th>Verifier time</th>
        <th>Prover time</th>
        <th>Verifier time</th>
    </tr>
    <tr>
        <td>2^10</td>
        <td>1.4 ms</td>
        <td>2.5 s</td>
        <td>6.3 ms</td>
        <td>2.5 s</td>
        <td>9.8 ms</td>
    </tr>
    <tr>
        <td>2^12</td>
        <td>8 ms</td>
        <td>709 ms</td>
        <td>13.3 ms</td>
        <td>710.5 ms</td>
        <td>17.7 ms</td>
    </tr>
    <tr>
        <td>2^14</td>
        <td>44.9 ms</td>
        <td>3 s</td>
        <td>41.1 ms</td>
        <td>3 s</td>
        <td>46.5 ms</td>
    </tr>
    <tr>
        <td>2^16</td>
        <td>140.8 s</td>
        <td>12.2 s</td>
        <td>160.6 ms</td>
        <td>12.2 s</td>
        <td>168 ms</td>
    </tr>
    <tr>
        <td>2^18</td>
        <td>700 ms</td>
        <td>50.5 s</td>
        <td>692.9 ms</td>
        <td>50.5 s</td>
        <td>702.6 ms</td>
    </tr>
</table>
