<div align="center">

# 🌟 Lambdaworks Stark Platinum Prover 🌟

<img src="https://github.com/lambdaclass/lambdaworks_stark_platinum/assets/569014/ad8d7943-f011-49b5-a0c5-f07e5ef4133e" alt="drawing" width="300"/>

## An open-source STARK prover, drop-in replacement for Winterfell.

</div>

[![Telegram Chat][tg-badge]][tg-url]

[tg-badge]: https://img.shields.io/static/v1?color=green&logo=telegram&label=chat&style=flat&message=join
[tg-url]: https://t.me/+98Whlzql7Hs0MDZh


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

## Documentation
- [STARKs](#starks)
    - [Recap](#recap)
    - [Protocol overview](#protocol-overview)
    - [Protocol](#protocol)
    - [Implementation](#lambdaworks-implementation)
        - [High Level API](#high-level-api-fibonacci-example)
        - [Under the hood](#how-this-works-under-the-hood)
- [Cairo](#cairo-1)
    - [Trace](#trace)
    - [Extended columns (RAP)](#extended-columns)
    - [Virtual columns and subcolumns](#virtual-columns-and-subcolumns)
    - [Builtins](#builtins)

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

### Using WASM verifier

To use the verifier in WASM, generate a npm package using `wasm-pack`

As a shortcut, you can call
`make build_wasm`
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

The following links, repos and projects have been important in the development of this library and we want to thank and acknowledge them. 

- [Starkware](https://starkware.co/)
- [Winterfell](https://github.com/facebook/winterfell)
- [Anatomy of a Stark](https://aszepieniec.github.io/stark-anatomy/overview)
- [Giza](https://github.com/maxgillett/giza)
- [Ministark](https://github.com/andrewmilson/ministark)
- [Sandstorm](https://github.com/andrewmilson/sandstorm)
- [STARK-101](https://starkware.co/stark-101/)
- [Risc0](https://github.com/risc0/risc0)
- [Neptune](https://github.com/Neptune-Crypto)
- [Summary on FRI low degree test](https://eprint.iacr.org/2022/1216)
- [STARKs paper](https://eprint.iacr.org/2018/046)
- [DEEP FRI](https://eprint.iacr.org/2019/336)
- [BrainSTARK](https://aszepieniec.github.io/stark-brainfuck/)
- [Plonky2](https://github.com/mir-protocol/plonky2)
- [Arkworks](https://github.com/arkworks-rs)
- [Thank goodness it's FRIday](https://vitalik.ca/general/2017/11/22/starks_part_2.html)
- [Diving DEEP FRI](https://blog.lambdaclass.com/diving-deep-fri/)
- [Periodic constraints](https://blog.lambdaclass.com/periodic-constraints-and-recursion-in-zk-starks/)
- [Chiplets Miden VM](https://wiki.polygon.technology/docs/miden/design/chiplets/main/)
- [Valida](https://github.com/valida-xyz/valida/tree/main)
- [Solidity Verifier](https://github.com/starkware-libs/starkex-contracts/tree/master/evm-verifier/solidity/contracts/cpu)
- [CAIRO verifier](https://github.com/starkware-libs/cairo-lang/tree/master/src/starkware/cairo/stark_verifier)
- [EthSTARK](https://github.com/starkware-libs/ethSTARK/tree/master)
- [CAIRO whitepaper](https://eprint.iacr.org/2021/1063.pdf)
- [Gnark](https://github.com/Consensys/gnark)

## 🌞 Related Projects

- [CAIRO VM - Rust](https://github.com/lambdaclass/cairo-vm)
- [CAIRO VM - Go](https://github.com/lambdaclass/cairo_vm.go)
- [Lambdaworks](https://github.com/lambdaclass/lambdaworks)
- [CAIRO native](https://github.com/lambdaclass/cairo_native/)
- [StarkNet in Rust](https://github.com/lambdaclass/starknet_in_rust)
- [StarkNet Stack](https://github.com/lambdaclass/starknet_stack)


# STARKs

The goal of this document is to give a good a understanding of our stark prover code. To this end, in the first section we go through a recap of how the proving system works at a high level mathematically; then we dive into how that's actually implemented in our code.

## Recap

## Verifying Computation through Polynomials

In general, we express computation in our proving system by providing an *execution trace* satisfying certain *constraints*. The execution trace is a table containing the state of the system at every step of computation. This computation needs to follow certain rules to be valid; these rules are our *constraints*.

The constraints for our computation are expressed using an `Algebraic Intermediate Representation` or `AIR`. This representation uses polynomials to encode constraints, which is why sometimes they are called `polynomial constraints`.

To make all this less abstract, let's go through two examples.

### Fibonacci numbers

Throughout this section and the following we will use this example extensively to have a concrete example. Even though it's a bit contrived (no one cares about computing fibonacci numbers), it's simple enough to be useful. STARKs and proving systems in general are very abstract things; having an example in mind is essential to not get lost.

Let's say our computation consists of calculating the `k`-th number in the fibonacci sequence. This is just the sequence of numbers $`a_n`$ satisfying

```math
a_0 = 1 
```

```math
a_1 = 1 
```

```math
a_{n+2} = a_{n + 1} + a_n 
```

An execution trace for this just consists of a table with one column, where each row is the `i`-th number in the sequence:

| a_i    | 
| ------ |
| 1      |
| 1      |
| 2      |
| 3      |
| 5      |
| 8      |
| 13      |
| 21      |

A `valid` trace for this computation is a table satisfying two things:

- The first two rows are `1`.
- The value on any other row is the sum of the two preceding ones.

The first item is called a `boundary constraint`, it just enforces specific values on the trace at certain points. The second one is a `transition constraint`; it tells you how to go from one step of computation to the next.

### Cairo

The example above is extremely useful to have a mental model, but it's not really useful for anything else. The problem is it just works for the very narrow example of computing fibonacci numbers. If we wanted to prove execution of something else, we would have to write an `AIR` for it.

What we're actually aiming for is an `AIR` for an entire general purpose `Virtual Machine`. This way, we can provide proofs of execution for *any* computation using just one `AIR`. This is what [cairo](https://www.cairo-lang.org/docs/) as a programming language does. Cairo code compiles to the bytecode of a virtual machine with an already defined `AIR`. The general flow when using cairo is the following:

- User writes a cairo program.
- The program is compiled into Cairo's VM bytecode.
- The VM executes said code and provides an execution trace for it.
- The trace is passed on to a STARK prover, which creates a proof of correct execution according to Cairo's AIR.
- The proof is passed to a verifier, who checks that the proof is valid.

Ultimately, our goal is to give the tools to write a STARK prover for the cairo VM and do so. However, this is not a good example to start out as it's incredibly complex. The execution trace of a cairo program has around 30 columns, some for general purpose registers, some for other reasons. Cairo's AIR contains a lot of different transition constraints, encoding all the different possible instructions (arithmetic operations, jumps, etc).

Use the fibonacci example as your go-to for understanding all the moving parts; keep the Cairo example in mind as the thing we are actually building towards.

## Fibonacci step by step walkthrough

Below we go through a step by step explanation of a STARK prover. We will assume the trace of the fibonacci sequence mentioned above; it consists of only one column of length $`2^n`$. In this case, we'll take `n=3`. The trace looks like this

| a_i    | 
| ------ |
| a_0      |
| a_1      |
| a_2      |
| a_3      |
| a_4      |
| a_5      |
| a_6      |
| a_7      |

### Trace polynomial

The first step is to interpolate these values to generate the `trace polynomial`. This will be a polynomial encoding all the information about the trace. The way we do it is the following: in the finite field we are working in, we take an `8`-th primitive root of unity, let's call it $`g`$. It being a primitive root means two things:

- `g` is an `8`-th root of unity, i.e., $`g^8 = 1`$.
- Every `8`-th root of unity is of the form $`g^i`$ for some $`0 \leq i \leq 7`$.

With `g` in hand, we take the trace polynomial `t` to be the one satisfying

```math
t(g^i) = a_i
```

From here onwards, we will talk about the validity of the trace in terms of properties that this polynomial must satisfy. We will also implicitly identify a certain power of $`g`$ with its corresponding trace element, so for example we sometimes think of $`g^5`$ as $`a_5`$, the fifth row in the trace, even though technically it's $`t`$ *evaluated in* $`g^5`$ that equals $`a_5`$.

We talked about two different types of constraints the trace must satisfy to be valid. They were:

- The first two rows are `1`.
- The value on any other row is the sum of the two preceding ones.

In terms of `t`, this translates to

- $`t(g^0) = 1`$ and $`t(g) = 1`$.
- $`t(x g^2) - t(xg) - t(x) = 0`$ for all $`x \in \{g^0, g^1, g^2, g^3, g^4, g^5\}`$. This is because multiplying by `g` is the same as advancing a row in the trace.

### Composition Polynomial

To convince the verifier that the trace polynomial satisfies the relationships above, the prover will construct another polynomial that shows that both the boundary and transition constraints are satisfied and commit to it. We call this polynomial the `composition polynomial`, and usually denote it with $`H`$. Constructing it involves a lot of different things, so we'll go step by step introducing all the moving parts required.

#### Boundary polynomial

To show that the boundary constraints are satisfied, we construct the `boundary polynomial`. Recall that our boundary constraints are $`t(g^0) = t(g) = 1`$. Let's call $`P`$ the polynomial that interpolates these constraints, that is, $`P`$ satisfies:

```math
P(1) = 1
```

```math
P(g) = 1
```

The boundary polynomial $`B`$ is defined as follows:

```math
B(x) = \dfrac{t(x) - P(x)}{(x - 1) (x - g)}
```

The denominator here is called the `boundary zerofier`, and it's the polynomial whose roots are the elements of the trace where the boundary constraints must hold.

How does $`B`$ encode the boundary constraints? The idea is that, if the trace satisfies said constraints, then

```math
t(1) - P(1) = 1 - 1 = 0 \\
```

```math
t(g) - P(g) = 1 - 1 = 0
```

so $`t(x) - P(x)`$ has $`1`$ and $`g`$ as roots. Showing these values are roots is the same as showing that $`B(x)`$ is a polynomial instead of a rational function, and that's why we construct $`B`$ this way.

#### Transition constraint polynomial
To convince the verifier that the transition constraints are satisfied, we construct the `transition constraint polynomial` and call it $`C(x)`$. It's defined as follows:

```math
C(x) = \dfrac{t(xg^2) - t(xg) - t(x)}{\prod_{i = 0}^{5} (x - g^i)}
```

How does $`C`$ encode the transition constraints? We mentioned above that these are satisfied if the polynomial in the numerator vanishes in the elements $`\{g^0, g^1, g^2, g^3, g^4, g^5\}`$. As with $`B`$, this is the same as showing that $`C(x)`$ is a polynomial instead of a rational function.

#### Constructing $`H`$
With the boundary and transition constraint polynomials in hand, we build the `composition polynomial` $`H`$ as follows: The verifier will sample four numbers $`\alpha_1, \alpha_2, \beta_1, \beta_2`$ and $`H`$ will be

```math
H(x) = B(x) (\alpha_1 x^{D - deg(B)} + \beta_1) + C(x) (\alpha_2 x^{D - deg(C)} + \beta_2)
```

where $`D`$ is the smallest power of two greater than the degrees of both $`B`$ and $`C`$, so for example if $`deg(B) = 3`$ and $`deg(C) = 6`$, then $`D = 8`$.

Why not just take $`H(x) = B(x) + C(x)`$? The reason for the alphas and betas is to make the resulting $`H`$ be always different and unpredictable for the prover, so they can't precompute stuff beforehand. The $`x^{D - deg(...)}`$ term is there to adjust the degree of the constraints. This ensures the soundness of the protocol according to the [ethSTARK documentation](https://eprint.iacr.org/2021/582.pdf).

With what we discussed above, showing that the constraints are satisfied is equivalent to saying that `H` is a polynomial and not a rational function (we are simplifying things a bit here, but it works for our purposes).

### Commiting to $`H`$

To show $`H`$ is a polynomial we are going to use the `FRI` protocol, which we treat as a black box. For all we care, a `FRI` proof will verify if what we committed to is indeed a polynomial. Thus, the prover will provide a `FRI` commitment to `H`, and if it passes, the verifier will be convinced that the constraints are satisfied.

There is one catch here though: how does the verifier know that `FRI` was applied to `H` and not any other polynomial? For this we need to add an additional step to the protocol. 


### Consistency check
After commiting to `H`, the prover needs to show that `H` was constructed correctly according to the formula above. To do this, it will ask the prover to provide an evaluation of `H` on some random point `z` and evaluations of the trace at the points $`t(z), t(zg)`$ and $`t(zg^2)`$.

Because the boundary and transition constraints are a public part of the protocol, the verifier knows them, and thus the only thing it needs to compute the evaluation $`(z)`$ by itself are the three trace evaluations mentioned above. Because it asked the prover for them, it can check both sides of the equation:

```math
H(z) = B(z) (\alpha_1 z^{D - deg(B)} + \beta_1) + C(z) (\alpha_2 z^{D - deg(C)} + \beta_2)
```

and be convinced that $`H`$ was constructed correctly.

We are still not done, however, as the prover could have now cheated on the values of the trace or composition polynomial evaluations.

### Deep Composition Polynomial

There are two things left the prover needs to show to complete the proof:

- That $`H`$ effectively is a polynomial, i.e., that the constraints are satisfied.
- That the evaluations the prover provided on the consistency check were indeed evaluations of the trace polynomial and composition polynomial on the out of domain point `z`.

Earlier we said we would use the `FRI` protocol to commit to `H` and show the first item in the list. However, we can slightly modify the polynomial we do `FRI` on to show both the first and second items at the same time. This new modified polynomial is called the `DEEP` composition polynomial. We define it as follows:

```math
Deep(x) = \gamma_1 \dfrac{H(x) - H(z)}{x - z} + \gamma_2 \dfrac{t(x) - t(z)}{x - z} + \gamma_3 \dfrac{t(x) - t(zg)}{x - zg} + \gamma_4 \dfrac{t(x) - t(zg^2)}{x - zg^2}
```

where the numbers $`\gamma_i`$ are randomly sampled by the verifier.

The high level idea is the following: If we apply `FRI` to this polynomial and it verifies, we are simultaneously showing that

- $`H`$ is a polynomial and the prover indeed provided `H(z)` as one of the out of domain evaluations. This is the first summand in `Deep(x)`.
- The trace evaluations provided by the prover were the correct ones, i.e., they were $`t(z)`$, $`t(zg)`$, and $`t(zg^2)`$. These are the remaining summands of the `Deep(x)`.

#### Consistency check
The prover needs to show that `Deep` was constructed correctly according to the formula above. To do this, the verifier will ask the prover to provide:

- An evaluation of `H` on `z` and `x_0`
- Evaluations of the trace at the points $`t(z)`$, $`t(zg)`$, $`t(zg^2)`$ and $`t(x_0)`$

Where `z` is the same random, out of domain point used in the consistency check of the composition polynomial, and `x_0` is a random point that belongs to the trace domain.

With the values provided by the prover, the verifier can check both sides of the equation:

```math
Deep(x_0) = \gamma_1 \dfrac{H(x_0) - H(z)}{x_0 - z} + \gamma_2 \dfrac{t(x_0) - t(z)}{x_0 - z} + \gamma_3 \dfrac{t(x_0) - t(zg)}{x_0 - zg} + \gamma_4 \dfrac{t(x_0) - t(zg^2)}{x_0 - zg^2}
```

The prover also needs to show that the trace evaluation $`t(x_0)`$ belongs to the trace. To achieve this, it needs to commit the merkle roots of `t` and the merkle proof of $`t(x_0)`$.

### Summary

We summarize below the steps required in a STARK proof for both prover and verifier.

#### Prover side

- Compute the trace polynomial `t` by interpolating the trace column over a set of $`2^n`$-th roots of unity $`\{g^i : 0 \leq i < 2^n\}`$.
- Compute the boundary polynomial `B`.
- Compute the transition constraint polynomial `C`.
- Construct the composition polynomial `H` from `B` and `C`.
- Sample an out of domain point `z` and provide the evaluations $`H(z)`$, $`t(z)`$, $`t(zg)`$, and $`t(zg^2)`$ to the verifier.
- Sample a domain point `x_0` and provide the evaluations $`H(x_0)`$ and $`t(x_0)`$ to the verifier.
- Construct the deep composition polynomial `Deep(x)` from `H`, `t`, and the evaluations from the item above.
- Do `FRI` on `Deep(x)` and provide the resulting FRI commitment to the verifier.
- Provide the merkle root of `t` and the merkle proof of $`t(x_0)`$.

#### Verifier side

- Take the evaluations $`H(z)`$, $`H(x_0)`$, $`t(z)`$, $`t(zg)`$, $`t(zg^2)`$ and $`t(x_0)`$ the prover provided.
- Reconstruct the evaluations $`B(z)`$ and $`C(z)`$ from the trace evaluations we were given. Check that the claimed evaluation $`H(z)`$ the prover gave us actually satisfies
    ```math
    H(z) = B(z) (\alpha_1 z^{D - deg(B)} + \beta_1) + C(z) (\alpha_2 z^{D - deg(C)} + \beta_2)
    ```
- Check that the claimed evaluation $`Deep(x_0)`$ the prover gave us actually satisfies
    ```math
    Deep(x_0) = \gamma_1 \dfrac{H(x_0) - H(z)}{x_0 - z} + \gamma_2 \dfrac{t(x_0) - t(z)}{x_0 - z} + \gamma_3 \dfrac{t(x_0) - t(zg)}{x_0 - zg} + \gamma_4 \dfrac{t(x_0) - t(zg^2)}{x_0 - zg^2}
    ```
- Using the merkle root and the merkle proof the prover provided, check that $`t(x_0)`$ belongs to the trace.
- Take the provided `FRI` commitment and check that it verifies.

## Simplifications and Omissions

The walkthrough above was for the fibonacci example which, because of its simplicity, allowed us to sweep under the rug a few more complexities that we'll have to tackle on the implementation side. They are:

#### Multiple trace columns

Our trace contained only one column, but in the general setting there can be multiple (the Cairo `AIR` has around 30). This means there isn't just *one* trace polynomial, but several; one for each column. This also means there are multiple boundary constraint polynomials.

The general idea, however, remains the same. The deep composition polynomial `H` is now the sum of several terms containing the boundary constraint polynomials $`B_1(x), \dots, B_k(x)`$ (one per column), and each $`B_i`$ is in turn constructed from the $`i`$-th trace polynomial $`t_i(x)`$.

#### Multiple transition constraints

Much in the same way, our fibonacci `AIR` had only one transition constraint, but there could be several. We will therefore have multiple transition constraint polynomials $`C_1(x), \dots, C_n(x)`$, each of which encodes a different relationship between rows that must be satisfied. Also, because there are multiple trace columns, a transition constraint can mix different trace polynomials. One such constraint could be

```math
C_1(x) = t_1(gx) - t_2(x)
```

which means "The first column on the next row has to be equal to the second column in the current row".

Again, even though this seems way more complex, the ideas remain the same. The composition polynomial `H` will now include a term for every $`C_i(x)`$, and for each one the prover will have to provide out of domain evaluations of the trace polynomials at the appropriate values. In our example above, to perform the consistency check on $`C_1(x)`$ the prover will have to provide the evaluations $`t_1(zg)`$ and $`t_2(z)`$.

#### Composition polynomial decomposition

In the actual implementation, we won't commit to $`H`$, but rather to a decomposition of $`H`$ into an even term $`H_1(x)`$ and an odd term $`H_2(x)`$, which satisfy

```math
H(x) = H_1(x^2) + x H_2(x^2)
```

This way, we don't commit to $`H`$ but to $`H_1`$ and $`H_2`$. This is just an optimization at the code level; once again, the ideas remain exactly the same.

#### FRI, low degree extensions and roots of unity

We treated `FRI` as a black box entirely. However, there is one thing we do need to understand about it: low degree extensions.

When applying `FRI` to a polynomial of degree $`n`$, we need to provide evaluations of it over a domain with *more* than $`n`$ points. In our case, the `DEEP` composition polynomial's degree is around the same as the trace's, which is, at most, $`2^n - 1`$ (because it interpolates the trace containing $`2^n`$ points).

The domain we are going to choose to evaluate our `DEEP` polynomial on will be a set of *higher* roots of unity. In our fibonacci example, we will take a primitive $`16`$-th root of unity $`\omega`$. As a reminder, this means:

- $`\omega`$ is an $`16`$-th root of unity, i.e., $`\omega^{16} = 1`$.
- Every $`16`$-th root of unity is of the form $`\omega^i`$ for some $`0 \leq i \leq 15`$.

Additionally, we also take it so that $`\omega`$ satisfies $`\omega^2 = g`$ ($`g`$ being the $`8`$-th primitive root of unity we used to construct `t`).

The evaluation of $`t`$ on the set $`\{\omega^i : 0 \leq i \leq 15\}`$ is called a *low degree extension* (`LDE`) of $`t`$. Notice this is not a new polynomial, they're evaluations of $`t`$ on some set of points. Also note that, because $`\omega^2 = g`$, the `LDE` contains all the evaluations of $`t`$ on the set of powers of $`g`$. In fact,

```math
    \{t(\omega^{2i}) : 0 \leq i \leq 15\} = \{t(g^i) : 0 \leq i \leq 7\}
```

This will be extremely important when we get to implementation.

For our `LDE`, we chose $`16`$-th roots of unity, but we could have chosen any other power of two greater than $`8`$. In general, this choice is called the `blowup factor`, so that if the trace has $`2^n`$ elements, a blowup factor of $`b`$ means our LDE evaluates over the $`2^{n} * b`$ roots of unity ($`b`$ needs to be a power of two). The blowup factor is a parameter of the protocol related to its security.

## Protocol Overview

In this section, we start diving deeper before showing the formal protocol. If you haven't done so, we recommend first reading the "Recap" section.

At a high level, the protocol works as follows. The starting point is a matrix $T$ that encodes the trace of a valid execution of the program. This matrix needs to be in a special format so that its correctness is equivalent to checking a finite number of polynomial equations on its rows. Transforming the execution to this matrix is what's called the arithmetization process.

Then a single polynomial $F$ is constructed that encodes the set of all the polynomial constraints. The satisfiability of all these constraints is equivalent to $F$ being divisible by some public polynomial $G$. So the prover constructs $H$ as the quotient $F/G$ called the composition polynomial.

Then the verifier chooses a random point $z$ and challenges the prover to reveal the values $F(z)$ and $H(z)$. Then the verifier checks that $H(z) = F(z)/G(z)$ which convinces him that the same relation holds at a level of polynomials and in consequence convinces the verifier that the private trace $T$ of the prover is valid.

In summary, at a very high level, the STARK protocol can be organized into three major parts:
- Arithmetization and commitment of execution trace.
- Construction of composition polynomial $H$.
- Opening of polynomials at random $z$.

## Arithmetization
As mentioned in the Recap, the trace is a table containing the state of the system at every step. In this section, we will denote the trace as $T$. A trace can have several columns to store different aspects or features of a particular state at a particular moment. We will refer to the $j$-th column as $T_j$. You can think of a trace as a matrix $T$ where the entry $T_{ij}$ is the $j$-th element of the $i$-th state.

The main tool in most proving systems is that of polynomials over a finite field  $\mathbb{F}$. Each column $T_j$ of the trace $T$ will be interpreted as evaluations of such a polynomial $t_j$. A consequence of this is that any type of information about the states must be encoded somehow as an element in $\mathbb{F}$.

To ease notation we will assume here and in the protocol that the constraints encoding transition rules depend only on a state and the previous one. Everything can be easily generalized to transitions that depend on many preceding states. Then, constraints can be expressed as multivariate polynomials in $2m$ variables
$$P_k^T(X_1, \dots, X_m, Y_1, \dots, Y_m)$$
A transition from state $i$ to state $i+1$ will be valid if and only if when we plug row $i$ of $T$ in the first $m$ variables and row $i+1$ in the second $m$ variables of $P_k^T$ we get $0$ for all $k$. In mathematical notation, this is
$$P_k^T(T_{i, 0}, \dots, T_{i, m}, T_{i+1, 0}, \dots, T_{i+1, m}) = 0 \text{    for all }k$$

These are called *transition constraints* and they check local properties of the trace, where local means relative to a specific row. There is another type of constraint, called *boundary constraint*, and denoted $P_j^B$. These enforce parts of the trace to take particular values. It is useful for example to verify the initial states.

So far, these constraints can only express local properties of the trace. There are situations where global properties of the trace need to be checked for consistency. For example, a column may need to take all values in a range but not in any predefined way. There are several methods to express these global properties as local by adding redundant columns. Usually, they need to involve randomness from the verifier to make sense and they turn into an interactive protocol on their own called *Randomized AIR with Preprocessing*.

## Polynomial commitment scheme
To make interactions possible, a crucial cryptographic primitive is the Polynomial Commitment Scheme. This is used to prevent the prover from changing the polynomials along the way to adjust them to what the verifier expects.

Such a scheme consists of two parts: the commit and the open protocols. STARK uses a univariate polynomial commitment scheme which internally uses a combination of a vector commitment scheme and a protocol called FRI. Let's begin with these two components and see how they build up the polynomial commitment scheme.

### Vector commitments
Given a vector $Y = (y_0, \dots, y_M)$, commiting to $Y$ means the following. The prover builds a Merkle tree out of it and sends the root of the tree to the verifier. The verifier can then ask the prover to reveal, or *open*, the value of the vector $Y$ at some index $i$. The prover won't have any choice other than to send the correct value. This is because the verifier will expect not only the corresponding value $y_i$ but also the authentication path to the root of the tree to check its authenticity. The authentication path encodes also the position $i$ and the length $M$ of the vector.

In STARKs, all commited vectors are of the form $Y = (p(d_1), \dots, p(d_M))$ for some polynomial $p$ and some domain fixed domain $D = (d_1, \dots, d_M)$. The domain is always known to the prover and the verifier.

### FRI
The FRI protocol is a very powerful tool to prove that the commitment of a vector $(p(d_1), \dots, p(d_M))$ corresponds to the evaluations of a polynomial $p$ of a certain degree. The degree is a configuration of the protocol.

### Polynomial commitments
STARK uses a univariate polynomial commitment scheme. The following is what is expected from the **commit** and **open** protocols:
- *Commit*: given a polynomial $p$, the prover produces a sort of hash of it. We denote it here by $[p]$ and is called the *commitment* of $p$. This hash is unique to $p$. The prover usually sends $[p]$ to the verifier.
- *Open*: this is an interactive protocol between the prover and the verifier. The prover holds the polynomial $p$. The verifier only holds the commitment $[p]$. The verifier sends a value $z$ to the prover at which he wants to know the value $y=p(z)$. The prover sends a value $y$ to the verifier and then they engage in the *Open* protocol. As a result of this, the verifier gets convinced that the polynomial that corresponds to the hash $[p]$ evaluates to $y$ at $z$.

Let's see how both of these protocols work in detail. Some configuration parameters are needed: 
- Powers of two $N = 2^n$ and $M = 2^m$ with $n < m$.
- A vector $D=(d_1,\dots,d_M)$, with $d_i$ in $\mathbb{F}$ for all $i$ and $d_i\neq d_j$ for all $i\neq j$.
- An integer $k > 0$.

The commitment scheme will only work for polynomials of degree at most $N$. Meaning that anyone will be able to commit to any polynomial, but the Open protocol will pass only for polynomials satisfying that degree bound.

#### Commit
Given a polynomial $p$, the commitment $[p]$ is just the commitment of the vector $(p(d_1), \dots, p(d_M))$. That is, $[p]$ is the root of the Merkle tree of the vector of evaluations of $p$ at $D$.

#### Open
It is an interactive protocol. So assume there is a prover and a verifier. We describe the process assuming an honest prover. In the next section, we analyze what happens for malicious provers.

The prover holds the polynomial $p$ and the verifier only the commitment $[p]$ of it. There is also an element $z$. The prover evaluates $p(z)$ and sends the result to the verifier. The goal, as we mentioned, is to generate a proof of the validity of the evaluation. Let us denote $y := p(z)$. This is a value now both the prover and verifier have.

The protocol has three steps:

- **FRI on $p$**: First the prover and the verifier engage in a FRI protocol for polynomials of degree at most $N$ to check that $[p]$ is the commitment of such a polynomial. We will assume from now on that the degree of $p$ is at most $N$. There is an optimization that completely removes this step. More on that [later](#optimize-the-open-protocol-reusing-fri-internal-challenges).

- **FRI on $(p-y)/(x-z)$**: Since $p(z) = y$, the polynomial $p$ can be written as $p = y + (x - z) q$ for some polynomial $q$. The prover computes the commitment $[q]$ and sends it to the verifier. Now they engage in a FRI protocol for polynomials of degree at most $N-1$, which convinces the verifier that $[q]$ is the commitment of a polynomial of degree at most $N-1$. 

- **Point checks**: From the point of view of the verifier the commitments $[p]$ and $[q]$ are still potentially unrelated. Therefore, there is a check to ensure that $q$ was computed properly from $p$ following the formula $q = (p-y)/(x-z)$ and that $[q]$ is its commitment. To do this the verifier challenges the prover to open $[p]$ and $[q]$ as vectors. Meaning they use the open protocol of the vector commitment scheme to reveal the values $p(d_i)$ and $q(d_i)$ for some random point $d_i \in D$ chosen by the verifier. Next he checks that $p(d_i) = y + (d_i - z) q(d_i) $. They repeat this last part $k$ times and, as we'll analyze in the next section, this whole thing will convince the verifier that $p = y + (x -z) q$ as polynomials with overwhelming probability (about $(N/M)^k$). Finally, from this equality, the verifier deduces that $p(z) = y$.

#### Soundness
Let's analyze why the open protocol is sound. Keep in mind that the prover always has to provide a commitment $[q]$ of a polynomial of degree at most $N-1$ that satisfies $p(d_i) = y + (d_i - z) q(d_i)$ for the chosen values of the verifier. That's the goal. An important but subtle part of the soundness is that $D$ is a vector of length $M>N$. To understand why let's see what would happen if $N = M$.

##### Case $M=N$
Suppose the prover is trying to cheat the verifier by sending a value $y$ different from $p(z)$. This means that $p - y$ is not divisible by $X-z$ as polynomials. But as long as $z$ is not in $D$ the prover can interpolate the values $$\frac{p(d_1) - y}{d_1 - z}, \dots, \frac{p(d_N) - y}{d_N - z},$$
at $D$ and obtain some polynomial $q$ of degree at most $N-1$. This polynomial satisfies $p(d_i) = y + (d_i - z) q(d_i)$ for all $d_i \in D$, but the equality of polynomials $p = y + (x - z) q$ does not hold. Mainly because that would imply that $p(z) = y$ and we are assuming the opposite case. Nevertheless, if they continue with the open protocol, FRI will pass since $q$ is truly a polynomial of degree at most $N-1$. All subsequent point checks will also pass since $q$ was crafted especially for that. 

So how come $p$ is different from $y + (x - z) q$ but has the property that $p(d_i) = y + (d_i - z) q(d_i)$ for all $d_i \in D$? FRI guarantees $q$ is of degree at most $N-1$, which implies that $y + (x - z) q$ is of degree at most $N$. Then, since $p$ is of degree at most $N$, the difference $$f := y + (X-z) q - p$$ is again of degree at most $N$. A polynomial $f$ of degree at most $N$ is zero if and only if we can prove that $f(d) = 0$ for $N+1$ distinct points. But the construction of $q$ only shows that $f(d_i) = 0$ for all $d_i \in D$, which is a set of $N$ points. It's not enough. One extra point and the equality $f=0$ would hold. Of course, that point doesn't exist, again because that would imply that $p(z) = y$, which we assume is not true.

##### Case $M=2N$
Let's see one more example where we double the de size of $D$ but keep the same bound for the degree of the polynomials. So polynomials are of degree at most $N$ and the length of $D$ is $M = 2N$.

Again let's assume the prover wants to cheat the verifier in the same way and claims that $y$ is $p(z)$ but in reality $y \neq p(z)$. Inevitably, for the Open protocol to succeed, the prover has to send a commitment $[q]$ of some polynomial of degree at most $N-1$. The strategy of the prover is pretty much constrained to be the same. But now he can't interpolate $q$ as before in every element of $D$, because that would produce a polynomial of degree at most $2N-1$. This most likely won't pass the FRI check.

Alternatively, he can choose some subset of $D' \subset D$ of size $N$ and interpolate only there to get a polynomial $q$ of degree at most $N-1$. That's going to succeed in the FRI phase, but what happens with the point checks? If the verifier chooses a challenge $d_i$ that belongs to $D'$, the check will pass. If $d_i \notin D'$, then the check will inevitably fail. This is because, as we saw in the previous case, one extra successful point to the already $N$ points where $q$ was interpolated was enough to prove that $p(z) = y$, which we assume now not to hold. This means, if $d_i \notin D'$, then $p(d_i)$ does not coincide with $y + (d_i - z) q(d_i)$ and the point check fails. So if the verifier chooses the challenges following a uniform distribution, then the chances of the prover being caught are $1/2$ for only one challenge. If the verifier performs $k$ challenges, then the chance of the prover not getting caught is $1/2^{k}$.

##### General case: the blowup factor
If the ratio between $M$ and $N$ is $2$, then $k$ challenges give $1/2^{k}$ of probability for a malicious prover to succeed. If the ratio is $4$, that is, if $M = 4N$, then that probability is $1/4^k$ for the same number of point checks. This provides another way of improving the soundness error. The larger the ratio, the harder is to cheat in the open protocol. This ratio is what's called *the blowup factor*. It is a security parameter and finding a balance between the number of challenges $k$ and the size of $D$ is part of the configuration of the protocol. Increasing the size of $D$ makes committing an expensive operation since it involves building a Merkle tree with a vector of the size of $D$. But increasing the number of challenges makes the size of the final proof larger.

We denote the blowup factor by $b$ and it's always assumed to be a power of $2$.

#### Batch
During proof generation, polynomials are committed and opened several times. Computing these for each polynomial independently is costly. In this section, we'll see how batching polynomials can reduce the amount of computation. Let $P=\{p_1, \dots, p_L\}$ be a set of polynomials. We will commit and open $P$ as a whole. We note this batch commitment as $[P]$.

We need the same configuration parameters as before: $N=2^n$, $M=2^m$ with $N < M$, a vector $D=(d_1, \dots, d_M)$ and $k>0$.

As described earlier, to commit to a single polynomial $p$, a Merkle tree is built over the vector $(p(d_1), \dots, p(d_m))$. When committing to a batch of polynomials $P=\{p_1, \dots, p_n\}$, the leaves of the Merkle tree are instead the concatenation of the polynomial evaluations. That is, in the batch setting, the Merkle tree is built for the vector $(p_1(d_1)||\dots||p_L(d_1), \dots, p_L(d_m)||\dots||p_n(d_m))$. The commitment $[P]$ is the root of this Merkle tree. This reduces the proof size: we only need one Merkle tree for $L$ polynomials. The verifier can then only ask for values in batches. When the verifier chooses an index $i$, the prover sends all of $p_1(d_i),\dots,p_L(d_i)$ along with one authentication path. The verifier on his side computes the concatenation $p_1(d_i)||\dots||p_L(d_i)$ and validates it with the authentication path and $[P]$. This also reduces the computational time. By traversing the Merkle tree one time, it can batch reveal several components at the same time.

The batch open protocol proceeds similarly to the case of a single polynomial. The prover will try to convince the verifier that the committed polynomials $P$ at $z$ evaluate to some values $y_i = p_i(z)$. In the batch case the prover will construct the following polynomial:

$$
Q:=\sum_{i=1}^{L}\gamma_i\frac{p_i-y_i}{X-z}
$$

Where $\gamma_i$ are challenges provided by the verifier. The prover commits to $Q$ and sends $[Q]$ to the verifier. Then the prover and verifier continue very similarly to the normal open protocol but for $Q$ only. This means that they engage in a FRI protocol for polynomials of degree at most $N-1$ for $Q$. Then they engage in the point checks for $Q$. Here, for each challenge $d_i$, the prover uses one authentication path for $[Q]$ to reveal $Q(d_i)$ and use one authentication path for $[P]$ to batch reveal values $p_1(d_i),\dots, p_L(d_i)$. Successful point checks here mean that $Q(d_i) = \sum_i \gamma_i(p_i(d_i) - y_i) / (d_i - z)$.

All of this is equivalent to running the open protocol $L$ times, one for each term $p_i$ and $y_i$. Note that this optimization makes a huge difference, as we only need to run the FRI protocol once instead of running it one time for each polynomial.

#### Optimize the open protocol reusing FRI internal challenges

There is an optimization for the open protocol to avoid running FRI to check that $p$ is of degree at most $N$. The idea is as follows. Part of FRI protocol for $[q]$, to check that it is of degree at most $N-1$, involves revealing values of $q$ at other random points $d_i$ chosen also by the verifier. These are part of the internal workings of FRI. These challenges are unrelated to what we mentioned before. So if one removes the FRI check for $p$, the point checks of the open protocol need to be performed on these challenges $d_i$ of the FRI protocol for $[q]$. This optimization is included in the formal description of the protocol.

### References

- [Transparent Polynomial Commitment Scheme with Polylogarithmic Communication Complexity](https://eprint.iacr.org/2019/1020)
- [Summary on FRI low degree test](https://eprint.iacr.org/2022/1216)
- [DEEP FRI](https://eprint.iacr.org/2019/336)
- [Thank goodness it's FRIday](https://vitalik.ca/general/2017/11/22/starks_part_2.html)
- [Diving DEEP FRI](https://blog.lambdaclass.com/diving-deep-fri/)

## High-level description of the protocol
The protocol is split into rounds. Each round more or less represents an interaction with the verifier. This means that each round will generally start by getting a challenge from the verifier. 

The prover will need to interpolate polynomials and he will always do it over the set $`D_S = \{ g^i \}_{ i=0 }^{ 2^n-1 } \subseteq \mathbb{F}`$, where $g$ is a $2^n$ root of unity in $\mathbb{F}$. Also, the vector commitments will be performed over the set $D_{LDE} = (h, h \omega, h \omega^2, \dots, h \omega^{2^{n + l}})$ where $\omega$ is a $2^{n + l}$ root of unity and $h$ is some field element. This is the set we denoted $D$ in the commitment scheme section. The specific choices for the shapes of these sets are motivated by optimizations at a code level.

### Round 1: Arithmetization and commitment of the execution trace
In **round 1**, the prover commits to the columns of the trace $T$. He does so by interpolating each column $j$ and obtaining univariate polynomials $t_j$.
Then the prover commits to $t_j$ over $D_{LDE}$. In this way, we have $T_{i,j}=t_j(g^i)$.
From now on, the prover won't be able to change the values of the trace $T$. The verifier will leverage this and send challenges to the prover. The prover cannot know in advance what these challenges will be, thus he cannot handcraft a trace to deceive the verifier.

As mentioned before, if some constraints cannot be expressed locally, more columns can be added to make a constraint-friendly trace. This is done by first committing to the first set of columns, then sampling challenges from the verifier and repeating round 1. The sampling of challenges serves to add new constraints. These constraints will make sure the new columns have some common structure with the original trace. In the protocol this is extended columns are referred to as the *RAP2* (Randomized AIR with Preprocessing). The matrix of the extended columns is denoted $M_{\text{RAP2}}$.

### Round 2: Construction of composition polynomial $H$
The goal of **round 2** is to build the composition polynomial $H$. This function will have the property that it is a polynomial if and only if the trace that the prover committed to at **round 1** is valid and satisfies the agreed polynomial constraints. That is, $H$ will be a polynomial if and only if $T$ is a trace that satisfies all the transition and boundary constraints.

Note that we can compose the polynomials $t_j$, the ones that interpolate the columns of the trace $T$, with the multivariate constraint polynomials as follows.
$$Q_k^T(x) = P_k^T(t_1(x), \dots, t_m(x), t_1(g x), \dots, t_m(\omega x))$$
These result in univariate polynomials. And the same can be done for the boundary constraints. Since $T_{i,j} = t_j(g^i)$, we have that these univariate polynomials vanish at every element of $D$ if and only if the trace $T$ is valid.

As we already mentioned, this is assuming that transitions only depend on the current and previous state. But it can be generalized to include *frames* with three or more rows or more context for each constraint. For example, in the Fibonacci case, the most natural way is to encode it as one transition constraint that depends on a row and the two preceding it as we already did in the Recap section. The STARK protocol checks whether the function $\frac{Q_k^T}{X^{2^n} - 1}$ is a polynomial instead of checking that the polynomial is zero over the domain $D =\{g_i\}_{i=0}^{2^n-1}$. The two statements are equivalent.

The verifier could check that all $\frac{Q_k^T}{X^{2^n} - 1}$ are polynomials one by one, and the same for the polynomials coming from the boundary constraints. But this is inefficient and the same can be obtained with a single polynomial. To do this, the prover samples challenges and obtains a random linear combination of these polynomials. The result of this is denoted by $H$ and is called the composition polynomial. It integrates all the constraints by adding them up. So after computing $H$, the prover commits to it and sends the commitment to the verifier. The rest of the protocol are efforts to prove that $H$ was properly constructed and that it is a polynomial, which can only be true if the prover has a valid extension of the original trace.

### Round 3: Evaluation of polynomials at $z$
The verifier needs to check that $H$ was constructed according to the rules of the protocol. That is, $H$ has to be a linear combination of all the functions $\frac{Q_k^T}{X^{2^n}-1}$ and similar terms for the boundary constraints. To do so, in **round 3** the verifier chooses a random point $z\in\mathbb{F}$ and the prover computes $H(z)$, $t_j(z)$ and $t_j(g z)$ for all $j$. With all these the verifier can check that $H$ and the expected linear combination coincide at least when evaluated at $z$. Since $z$ was chosen at random, this proves with overwhelming probability that $H$ was properly constructed.

### Round 4: Run batch open protocol 
In this round, the prover and verifier engage in the batch open protocol of the polynomial commitment scheme described above to validate all the evaluations at $z$ from the previous round.


## STARKs protocol

In this section we describe precisely the STARKs protocol used in Lambdaworks.

We begin with some additional considerations and notation for most of the relevant objects and values to refer to them later on.

#### Grinding
This is a technique to increase the soundness of the protocol by adding proof of work. It works as follows. At some fixed point in the protocol, the verifier sends a challenge $x$ to the prover. The prover needs to find a string $y$ such that $H(x || y)$ begins with a predefined number of zeroes. Here $x || y$ denotes the concatenation of $x$ and $y$, seen as bit strings.
The number of zeroes is called the *grinding factor*. The hash function $H$ can be any hash function, independent of other hash functions used in the rest of the protocol. In Lambdaworks we use Keccak256.

#### Transcript

The Fiat-Shamir heuristic is used to make the protocol noninteractive. We assume there is a transcript object to which values can be added and from which challenges can be sampled.

### General notation

- $\mathbb{F}$ denotes a finite field.
- Given a vector $D=(y_1,\dots,y_L)$ and a function $f:\text{set}(D) \to \mathbb{F}$, denote by $f(D)$ the vector $(f(y_1),\dots,f(y_L))$. Here $\text{set}(D)$ denotes the underlying set of $A$.
- A polynomial $p \in \mathbb{F}[X]$ induces a function $f:A \to \mathbb{F}$ for every subset $A$ of $\mathbb{F}$, where $f(a) := p(a)$.
- Let $p, q \in \mathbb{F}[X]$ be two polynomials. A function $f: A \to \mathbb{F}$ can be induced from them for every subset $A$ disjoint from the set of roots of $q$, defined by $f(a) := p(a) q(a)^{-1}$. We abuse notation and denote $f$ by $p/q$.

### Definitions 

We assume the prover has already obtained the trace of the execution of the program. This is a matrix $T$ with entries in a finite field $\mathbb{F}$. We assume the number of rows of $T$ is $2^n$ for some $n$ in $\mathbb{N}$.

##### Values known by the prover and verifier prior to the interactions

These values are determined the program,  the specifications of the AIR being used and the security parameters chosen.

- $m'$ is the number of columns of the trace matrix $T$.
- $r$ the number of RAP challenges.
- $m''$ is the number of extended columns of the trace matrix in the (optional) second round of RAP.
- $m$ is the total number of columns: $m := m' + m''$.
- $P_k^T$ denote the transition constraint polynomials for $k=1,\dots,n_T$. We are assuming these are of degree at most 2.
- $Z_j^T$ denote the transition constraint zerofiers for $k=1,\dots,n_T$.
- $b=2^l$ is the *[blowup factor](/starks/protocol_overview.html#general-case-the-blowup-factor)*.
- $c$ is the *grinding factor*.
- $Q$ is number of FRI queries.
- We assume there is a fixed hash function from $\mathbb{F}$ to binary strings. We also assume all Merkle trees are constructed using this hash function.

##### Values computed by the prover
These values are computed by the prover from the execution trace and are sent to the verifier along with the proof.
- $2^n$ is the number of rows of the trace matrix after RAP.
- $\omega$ a primitive $2^{n+l}$-th root of unity.
- $g = \omega^{b}$.
- An element $h\in\mathbb{F} \setminus \{\omega^i\}_{i \geq 0}$. This is called the *coset factor*.
- Boundary constraints polynomials $P_j^B$ for $j=1,\dots,m$.
- Boundary constraint zerofiers $Z_j^B$ for $j=1,\dots,m$..

##### Derived values
Both prover and verifier compute the following.

- The interpolation domain: the vector $D_S=(1, g, \dots, g^{2^n-1})$.
- The Low Degree Extension $D_{\text{LDE}} =(h, h\omega, h\omega^2,\dots, h\omega^{2^{n+l} - 1})$. Recall $2^l$ is the blowup factor.
- Let $d_k^T := 2^n (\deg(P_k^T) - 1)$ and let $d^B := 2^n$. Let $d := 2^{n + 1}$. Notice that $d^B \leq d$ and $d_k^T \leq d$ for all $k$. This holds because we assume all transition constraint polynomials are at most cubic.

#### Notation of important operations
##### Vector commitment scheme

Given a vector $A=(y_0, \dots, y_L)$. The operation $\text{Commit}(A)$ returns the root $r$ of the Merkle tree that has the hash of the elements of $A$ as leaves.

For $i\in[0,2^{n+k})$, the operation $\text{open}(A, i)$ returns $y_i$ and the authentication path $s$ to the Merkle tree root.

The operation $\text{Verify}(i,y,r,s)$ returns _Accept_ or _Reject_ depending on whether the $i$-th element of $A$ is $y$. It checks whether the authentication path $s$ is compatible with $i$, $y$ and the Merkle tree root $r$.


In our cases the sets $A$ will be of the form $A=(f(a), f(ab), f(ab^2), \dots, f(ab^L))$ for some elements $a,b\in\mathbb{F}$. It will be convenient to use the following abuse of notation. We will write $\text{Open}(A, ab^i)$ to mean $\text{Open}(A, i)$. Similarly, we will write $\text{Verify}(ab^i, y, r, s)$ instead of $\text{Verify}(i, y, r, s)$. Note that this is only notation and $\text{Verify}(ab^i, y, r, s)$ is only checking that the $y$ is the $i$-th element of the commited vector. 

### Protocol

#### Prover

##### Round 0: Transcript initialization

- Start a new transcript.
- (Strong Fiat Shamir) Add to it all the public values.

##### Round 1: Arithmetization and commitment of the execution trace
 
###### Round 1.1: Commit main trace

- For each column $M_j$ of the execution trace matrix $T$, interpolate its values at the domain $D_S$ and obtain polynomials $t_j$ such that $t_j(g^i)=T_{i,j}$.
- Compute $[t_j] := \text{Commit}(t_j(D_{\text{LED}}))$ for all $j=1,\dots,m'$ (*Batch commitment optimization applies here*).
- Add $[t_j]$ to the transcript in increasing order.

###### Round 1.2: Commit extended trace

- Sample random values $a_1,\dots,a_l$ in $\mathbb{F}$ from the transcript.
- Use $a_1,\dots,a_l$ to build $M_{\text{RAP2}}\in\mathbb{F}^{2^n\times m''}$ following the specifications of the RAP process.
- For each column $\hat M_j$ of the matrix $M_{\text{RAP2}}$, interpolate its values at the domain $D_S$ and obtain polynomials $t_{m'+1}, \dots, t_{m' + m''}$ such that $t_j(g^i)=\hat M_{i,j}$.
- Compute $[t_j] := \text{Commit}(t_j(D_{\text{LED}}))$ for all $j=m'+1,\dots,m'+m''$ (*Batch commitment optimization applies here*).
- Add $[t_j]$ to the transcript in increasing order for all $j=m'+1,\dots,m'+m''$.

##### Round 2: Construction of composition polynomial $H$
 
- Sample $\alpha_1^B,\dots,\alpha_{m}^B$ and $\beta_1^B,\dots,\beta_{m}^B$ in $\mathbb{F}$ from the transcript.
- Sample $\alpha_1^T,\dots,\alpha_{n_T}^T$ and $\beta_1^T,\dots,\beta_{n_T}^T$ in $\mathbb{F}$ from the transcript.
- Compute $B_j := \frac{t_j - P^B_j}{Z_j^B}$.
- Compute $C_k := \frac{P^T_k(t_1, \dots, t_m, t_1(gX), \dots, t_m(gX))}{Z_k^T}$.
- Compute the _composition polynomial_
  $$H := \sum_{k} (\alpha_k^T X^{d - d_k^T} + \beta_k^T)C_k + \sum_j (\alpha_j^BX^{d - d^B}+\beta_j^B)B_j$$
- Decompose $H$ as
  $$H = H_1(X^2) + XH_2(X^2)$$
- Compute commitments $[H_1]$ and $[H_2]$.
- Add $[H_1]$ and $[H_2]$ to the transcript.

##### Round 3: Evaluation of polynomials at $z$
 
- Sample from the transcript until obtaining $z\in\mathbb{F}\setminus D_{\text{LDE}}$.
- Compute $H_1(z^2)$, $H_2(z^2)$, and $t_j(z)$ and $t_j(gz)$ for all $j$.
- Add $H_1(z^2)$, $H_2(z^2)$, and $t_j(z)$ and $t_j(gz)$ for all $j$ to the transcript.

##### Round 4: Run batch open protocol 
 
- Sample $\gamma$, $\gamma'$, and $\gamma_1,\dots,\gamma_m$, $\gamma_1',\dots,\gamma_m'$ in $\mathbb{F}$ from the transcript.
- Compute $p_0$ as $$\gamma\frac{H_1 - H_1(z^2)}{X - z^2} + \gamma'\frac{H_2 - H_2(z^2)}{X - z^2} + \sum_j \gamma_j\frac{t_j - t_j(z)}{X - z} + \gamma_j'\frac{t_j - t_j(gz)}{X - gz}$$

###### Round 4.1.k: FRI commit phase

- Let $D_0:=D_{\text{LDE}}$, and $[p_0]:=\text{Commit}(p_0(D_0))$.
- Add $[p_0]$ to the transcript.
- For $k=1,\dots,n$ do the following:
  - Sample $\zeta_{k-1}$ from the transcript.
  - Decompose $p_{k-1}$ into even and odd parts, that is, $p_{k-1}=p_{k-1}^{odd}(X^2)+ X p_{k-1}^{even}(X^2)$.
  - Define $p_k:= p_{k-1}^{odd}(X) + \zeta_{k-1}p_{k-1}^{even}(X)$.
  - If $k < n$:
    - Let $L$ such that $|D_{k-1}|=2L$. Define $D_{k}:=(d_1^2, \dots, d_L^2)$, where $D_{k-1}=(d_1, \dots, d_{2L})$.
    - Let $[p_k]:=\text{Commit}(p_k(D_k))$.
    - Add $[p_k]$ to the transcript.
- $p_n$ is a constant polynomial and therefore $p_n\in\mathbb{F}$. Add $p_n$ to the transcript.

###### Round 4.2: Grinding
- Sample $x$ from the transcript.
- Compute $y$ such that $\text{Keccak256}(x || y)$ has $c$ leading zeroes.
- Add $y$ to the transcript.

###### Round 4.3: FRI query phase

- For $s=0,\dots,Q-1$ do the following:
  - Sample random index $\iota_s \in [0, 2^{n+l}]$ from the transcript and let $\upsilon_s := \omega^{\iota_s}$.
  - Compute $\text{Open}(p_0(D_0), \upsilon_s)$.
  - Compute $\text{Open}(p_k(D_k), -\upsilon_s^{2^k})$ for all $k=0,\dots,n-1$.


###### Round 4.4: Open deep composition polynomial components
- For $s=0,\dots,Q-1$ do the following:
    - Compute $\text{Open}(H_1(D_{\text{LDE}}), \upsilon_s)$, $\text{Open}(H_2(D_{\text{LDE}}), \upsilon_s)$.
    - Compute $\text{Open}(t_j(D_{\text{LDE}}), \upsilon_s)$ for all $j=1,\dots, m$.

##### Build proof

- Send the proof to the verifier:
$$
\begin{align}
\Pi = ( &\\
&\{[t_j], t_j(z), t_j(gz): 0\leq j < m\}, \\
&[H_1], H_1(z^2),[H_2], H_2(z^2), \\
&\{[p_k]: 0\leq k < n\}, \\
&p_n, \\
&y, \\
&\{\text{Open}(p_0(D_0), \upsilon_s): 0\leq s < Q\}), \\
&\{\text{Open}(p_k(D_k), -\upsilon_s^{2^k}): 0\leq k< n, 0\leq s < Q\}, \\
&\{\text{Open}(H_1(D_{\text{LDE}}), \upsilon_s): 0 \leq s < Q\}, \\
&\{\text{Open}(H_2(D_{\text{LDE}}), \upsilon_s): 0 \leq s < Q\}, \\
&\{\text{Open}(t_j(D_{\text{LDE}}), \upsilon_s): 0 \leq j< m, 0 \leq s < Q\}, \\
) &
\end{align}
$$

#### Verifier

##### Notation

- Bold capital letters refer to commitments. For example $\mathbf{H}_1$ is the claimed commitment $[H_1]$.
- Greek letters with superscripts refer to claimed function evaluations. For example $\tau_j^z$ is the claimed evaluation $t_j(z)$.
- Gothic letters refer to authentication paths (e.g. $\mathfrak{H}_1$ is the authentication path of the opening of $H_1$).

##### Input

$$
\begin{align}
\Pi = ( &\\
&\{\mathbf{T}_j, \tau_j^z, \tau_j^{gz}: 0\leq j < m\}, \\
&\mathbf{H}_1, \eta_1^{z^2},\mathbf{H}_2, \eta_2^{z^2}, \\
&\{\mathbf{P}_k: 0\leq k < n\}, \\
&\pi, \\
&y, \\
&\{(\pi_0^{\upsilon_s}, \mathfrak{P}_0): 0\leq s < Q\}, \\
&\{(\pi_k^{-\upsilon_s^{2^k}}, \mathfrak{P}_k): 0\leq k< n, 0\leq s < Q\}, \\
&\{(\eta_1^{\upsilon_s}, \mathfrak{H}_1): 0 \leq s < Q\}\\
&\{(\eta_2^{\upsilon_s}, \mathfrak{H}_2): 0 \leq s < Q\},\\
&\{(\tau_j^{\upsilon_s}, \mathfrak{T}_j): 0 \leq j< m, 0 \leq s < Q\}, \\
) &
\end{align}
$$

##### Step 1: Replay interactions and recover challenges

- Start a transcript
- (Strong Fiat Shamir) Commit to the set of coefficients of the transition and boundary polynomials, and add the commitments to the transcript.
- Add $\mathbf{T}_j$ to the transcript for all $j=1, \dots, m'$.
- Sample random values $a_1, \dots, a_l$ from the transcript.
- Add $\mathbf{T}_j$ to the transcript for $j=m' +1, \dots, m' + m''$.
- Sample $\alpha_1^B,\dots,\alpha_{m}^B$ and $\beta_1^B,\dots,\beta_{m}^B$ in $\mathbb{F}$ from the transcript.
- Sample $\alpha_1^T,\dots,\alpha_{n_T}^T$ and $\beta_1^T,\dots,\beta_{n_T}^T$ in $\mathbb{F}$ from the transcript.
- Add $\mathbf{H}_1$ and $\mathbf{H}_2$ to the transcript.
- Sample $z$ from the transcript.
- Add $\eta_1^{z^2}$, $\eta_2^{z^2}$, $\tau_j^z$ and $\tau_j^{gz}$ to the transcript.
- Sample $\gamma$, $\gamma'$, and $\gamma_1, \dots, \gamma_m, \gamma'_1, \dots,  \gamma'_m$ from the transcript.
- Add $\mathbf{P}_0$ to the transcript
- For $k=1, \dots, n$ do the following:
  - Sample $\zeta_{k-1}$
  - If $k < n$: add $\mathbf{P}_k$ to the transcript
- Add $\pi$ to the transcript.
- Sample $x$ from the transcript.
- Add $y$ to the transcript.
- For $s=0, \dots, Q-1$:
  - Sample random index $\iota_s \in [0, 2^{n+l}]$ from the transcript and let $\upsilon_s := \omega^{\iota_s}$.

##### Verify grinding:
Check that $\text{Keccak256}(x || y)$ has $c$ leading zeroes.


##### Step 2: Verify claimed composition polynomial

- Compute $h := \eta_1^{z^2} + z \eta_2^{z^2}$
- Compute $b_j := \frac{\tau_j^z - P^B_j(z)}{Z_j^B(z)}$
- Compute $c_k := \frac{P^T_k(\tau_1^z, \dots, \tau_m^z, \tau_1^{gz}, \dots, \tau_m^{gz})}{Z_k^T(z)}$
- Verify
  $$h = \sum_{k} (\alpha_k^T z^{d - d_k^T} + \beta_k^T)c_k + \sum_j (\alpha_j^B z^{d - d^B}+\beta_j^B)b_j$$

##### Step 3: Verify FRI

- Check that the following are all _Accept_:
  - $\text{Verify}((\upsilon_s, \pi_0^{\upsilon_s}), \mathbf{P}_0, \mathfrak{P}_0)$ for all $0\leq s < Q$.
  - $\text{Verify}((-\upsilon_s^{2^k}, \pi_k^{-\upsilon_s^{2^k}}), \mathbf{P}_k, \mathfrak{P}_k)$ for all $0\leq k < n$, $0\leq s < Q$.
- For all $s=0,\dots,Q-1$: - For all $k=0,\dots,n-1$: - Solve the following system of equations on the variables $G, H$
  $$
  \begin{aligned}
  \pi_k^{\upsilon_s^{2^{k}}} &= G + \upsilon_s^{2^k}H \\
  \pi_k^{-\upsilon_s^{2^{k}}} &= G - \upsilon_s^{2^k}H
  \end{aligned}
  $$
          - Define $\pi_{k+1}^{\upsilon_s^{2^{k+1}}}:=G + \zeta_{k}H$
      - Check that $\pi_n^{\upsilon_s^{2^n}}$ is equal to $\pi$.

##### Step 4: Verify deep composition polynomial is FRI first layer

- For $s=0,\dots,Q-1$ do the following:
    - Check that the following are all _Accept_:
        - $\text{Verify}((\upsilon_s, \eta_1^{\upsilon_s}), \mathbf{H}_1, \mathfrak{h}_1)$.
        - $\text{Verify}((\upsilon_s, \eta_2^{\upsilon_s}), \mathbf{H}_2, \mathfrak{h}_2)$.
        - $\text{Verify}((\upsilon_s, \tau_j^{\upsilon_s}), \mathbf{T}_j, \mathfrak{T}_j)$ for all $0\leq j < m$.
    - Check that $\pi_0^{\upsilon_s}$ is equal to the following:
        $$
        \gamma\frac{\eta_1^{\upsilon_s} - \eta_1^{z^2}}{\upsilon_s - z^2} + \gamma'\frac{\eta_2^{\upsilon_s} - \eta_2^{z^2}}{\upsilon_s - z^2} + \sum_j \gamma_j\frac{\tau_j^{\upsilon_s} - \tau_j^{z}}{\upsilon_s - z} + \gamma_j'\frac{\tau_j^{\upsilon_s} - \tau_j^{gz}}{\upsilon_s - gz}
        $$

## Other

### Notes on Optimizations
- Inversions of finite field elements are slow. There is a very well known trick to batch invert many elements at once replacing inversions by multiplications. See [here](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse#Multiple_inverses) for the algorithm.
- One of the most computationally intensive operations performed is polynomial division. These can be optimized by utilizing [Fast Fourier Transform](http://web.cecs.pdx.edu/~maier/cs584/Lectures/lect07b-11-MG.pdf) (FFT) to divide each field element in Lagrange form.
- In specific scenarios, such as dividing by a polynomial of the form (x-a), [Ruffini's rule](https://en.wikipedia.org/wiki/Ruffini%27s_rule) can be employed to further enhance performance.

## Lambdaworks Implementation

The goal of this section will be to go over the details of the implementation of the proving system. To this end, we will follow the flow the example in the `recap` chapter, diving deeper into the code when necessary and explaining how it fits into a more general case.

This implementation couldn't be done without checking Facebook's [Winterfell](https://github.com/facebook/winterfell) and Max Gillett's [Giza](https://github.com/maxgillett/giza). We want to thank everyone involved in them, along with Shahar Papini and Lior Goldberg from Starkware who also provided us valuable insight.

## High level API: Fibonacci example

Let's go over the main test we use for our prover, where we compute a STARK proof for a fibonacci trace with 4 rows and then verify it.

```rust
fn test_prove_fib() {
    let trace = simple_fibonacci::fibonacci_trace([FE::from(1), FE::from(1)], 8);
    let proof_options = ProofOptions::default_test_options();

    let pub_inputs = FibonacciPublicInputs {
        a0: FE::one(),
        a1: FE::one(),
    };

    let proof = prove::<F, FibonacciAIR<F>>(&trace, &pub_inputs, &proof_options).unwrap();
    assert!(verify::<F, FibonacciAIR<F>>(&proof, &pub_inputs, &proof_options));
}
```

The proving system revolves around the `prove` function, that takes a trace, public inputs and proof options as inputs to generate a proof, and a `verify` function that takes the generated proof, the public inputs and the proof options as inputs, outputting `true` when the proof is verified correctly and `false` otherwise. Note that the public inputs and proof options should be the same for both. Public inputs should be shared by the Cairo runner to prover and verifier, and the proof options should have been agreed on beforehand by the two entities beforehand.

Below we go over the main things involved in this code.

### AIR

To prove the integrity of a fibonacci trace, we first need to define what it means for a trace to be valid. As we've talked about in the recap, this involves defining an `AIR` for our computation where we specify both the boundary and transition constraints for a fibonacci sequence.

In code, this is done through the `AIR` trait. Implementing `AIR` requires defining a couple methods, but the two most important ones are `boundary_constraints` and `compute_transition`, which encode the boundary and transition constraints of our computation.


#### Boundary Constraints
For our Fibonacci `AIR`, boundary constraints look like this:

```rust
fn boundary_constraints(
    &self,
    _rap_challenges: &Self::RAPChallenges,
) -> BoundaryConstraints<Self::Field> {
    let a0 = BoundaryConstraint::new_simple(0, self.pub_inputs.a0.clone());
    let a1 = BoundaryConstraint::new_simple(1, self.pub_inputs.a1.clone());

    BoundaryConstraints::from_constraints(vec![a0, a1])
}
```

The `BoundaryConstraint` struct represents a specific boundary constraint, meaning "column `i` at row `j` should be equal to `x`". In this case, because we have only one column, we are using the `new_simple` method to simply say 

- Row `0` should equal the public input `a0`, which in the typical fibonacci is set to 1.
- Row `1` should equal the public input `a1`, which in the typical fibonacci is set to 1.

In the case of multiple columns, the `new` method exists so you can also specify column number.

After instantiating each of these constraints, we return all of them through the struct `BoundaryConstraints`.

#### Transition Constraints

The way we specify our fibonacci transition constraint looks like this:

```rust
fn compute_transition(
    &self,
    frame: &air::frame::Frame<Self::Field>,
    _rap_challenges: &Self::RAPChallenges,
) -> Vec<FieldElement<Self::Field>> {
    let first_row = frame.get_row(0);
    let second_row = frame.get_row(1);
    let third_row = frame.get_row(2);

    vec![third_row[0] - second_row[0] - first_row[0]]
}
```

It's not completely obvious why this is how we chose to express transition constraints, so let's talk a little about it. 

What we need to specify in this method is the relationship that has to hold between the current step of computation and the previous ones. For this, we get a `Frame` as an argument. This is a struct holding the current step (i.e. the current row of the trace) and all previous ones needed to encode our constraint. In our case, this is the current row and the two previous ones. To access rows we use the `get_row` method. The current step is always the last row (in our case `2`), with the others coming before it.

In our `compute_transition` method we get the three rows we need and return

```rust
third_row[0] - second_row[0] - first_row[0]
```

which is the value that needs to be zero for our constraint to hold. Because we support multiple transition constraints, we actually return a vector with one value per constraint, so the first element holds the first constraint value and so on.

### TraceTable

After defining our AIR, we create our specific trace to prove against it. 

```rust
let trace = fibonacci_trace([FE17::new(1), FE17::new(1)], 4);

let trace_table = TraceTable {
    table: trace.clone(),
    num_cols: 1,
};
```

`TraceTable` is the struct holding execution traces; the `num_cols` says how many columns the trace has, the `table` field is a `vec` holding the actual values of the trace in row-major form, meaning if the trace looks like this

```
| 1  | 2  |
| 3  | 4  |
| 5  | 6  |
```

then its corresponding `TraceTable` is 

```rust
let trace_table = TraceTable {
    table: vec![1, 2, 3, 4, 5, 6],
    num_cols: 2,
};
```

In our example, `fibonacci_trace` is just a helper function we use to generate the fibonacci trace with `4` rows and `[1, 1]` as the first two values.

### AIR Context

After specifying our constraints and trace, the only thing left to do is provide a few parameters related to the STARK protocol and our `AIR`. These specify things such as the number of columns of the trace and proof configuration, among others. They are all encapsulated in the `AirContext` struct, which in our example we instantiate like this:

```rust
let context = AirContext {
    options: ProofOptions {
        blowup_factor: 2,
        fri_number_of_queries: 1,
        coset_offset: 3,
    },
    trace_columns: trace_table.n_cols,
    transition_degrees: vec![1],
    transition_exemptions: vec![2],
    transition_offsets: vec![0, 1, 2],
    num_transition_constraints: 1,
};
```

Let's go over each of them:

- `options` requires a `ProofOptions` struct holding specific parameters related to the STARK protocol to be used when proving. They are:
    - The `blowup_factor` used for the trace LDE extension, a parameter related to the security of the protocol.
    - The number of queries performed by the verifier when doing `FRI`, also related to security.
    - The `offset` used for the LDE coset. This depends on the field being used for the STARK proof.
- `trace_columns` are the number of columns of the trace, respectively.
- `transition_degrees` holds the degree of each transition constraint.
- `transition_exemptions` is a `Vec` which tells us, for each column, the number of rows the transition constraints should not apply, starting from the end of the trace. In the example, the transition constraints won't apply on the last two rows of the trace.
- `transition_offsets` holds the indexes that define a frame for our `AIR`. In our fibonacci case, these are `[0, 1, 2]` because we need the current row and the two previous one to define our transition constraint.
- `num_transition_constraints` simply says how many transition constraints our `AIR` has.

### Proving execution

Having defined all of the above, proving our fibonacci example amounts to instantiating the necessary structs and then calling `prove` passing the trace, public inputs and proof options. We use a simple implementation of a hasher called `TestHasher` to handle merkle proof building.

```rust 
let proof = prove(&trace_table, &pub_inputs, &proof_options);
```

Verifying is then done by passing the proof of execution along with the same `AIR` to the `verify` function.

```rust
assert!(verify(&proof, &pub_inputs, &proof_options));
```

## How this works under the hood

In this section we go over how a few things in the `prove` and `verify` functions are implemented. If you just need to *use* the prover, then you probably don't need to read this. If you're going through the code to try to understand it, read on.

We will once again use the fibonacci example as an ilustration. Recall from the `recap` that the main steps for the prover and verifier are the following:

#### Prover side

- Compute the trace polynomial `t` by interpolating the trace column over a set of $2^n$-th roots of unity $\{g^i : 0 \leq i < 2^n\}$.
- Compute the boundary polynomial `B`.
- Compute the transition constraint polynomial `C`.
- Construct the composition polynomial `H` from `B` and `C`.
- Sample an out of domain point `z` and provide the evaluation $H(z)$ and all the necessary trace evaluations to reconstruct it. In the fibonacci case, these are $t(z)$, $t(zg)$, and $t(zg^2)$.
- Sample a domain point `x_0` and provide the evaluation $H(x_0)$ and $t(x_0)$.
- Construct the deep composition polynomial `Deep(x)` from `H`, `t`, and the evaluations from the item above.
- Do `FRI` on `Deep(x)` and provide the resulting FRI commitment to the verifier.
- Provide the merkle root of `t` and the merkle proof of $t(x_0)$.

#### Verifier side

- Take the evaluation $H(z)$ along with the trace evaluations the prover provided.
- Reconstruct the evaluations $B(z)$ and $C(z)$ from the trace evaluations. Check that the claimed evaluation $H(z)$ the prover gave us actually satisfies
    $$
    H(z) = B(z) (\alpha_1 z^{D - deg(B)} + \beta_1) + C(z) (\alpha_2 z^{D - deg(C)} + \beta_2)
    $$
- Take the evaluations $H(x_0)$ and $t(x_0)$.
- Check that the claimed evaluation $Deep(x_0)$ the prover gave us actually satisfies
    $$
    Deep(x_0) = \gamma_1 \dfrac{H(x_0) - H(z)}{x_0 - z} + \gamma_2 \dfrac{t(x_0) - t(z)}{x_0 - z} + \gamma_3 \dfrac{t(x_0) - t(zg)}{x_0 - zg} + \gamma_4 \dfrac{t(x_0) - t(zg^2)}{x_0 - zg^2}
    $$
- Take the provided `FRI` commitment and check that it verifies.
- Using the merkle root and the merkle proof the prover provided, check that $t(x_0)$ belongs to the trace.

Following along the code in the `prove` and `verify` functions, most of it maps pretty well to the steps above. The main things that are not immediately clear are:

- How we take the constraints defined in the `AIR` through the `compute_transition` method and map them to transition constraint polynomials.
- How we then construct `H` from them and the boundary constraint polynomials.
- What the composition polynomial even/odd decomposition is.
- What an `ood` frame is.
- What the transcript is.

## Reconstructing the transition constraint polynomials

This is possibly the most complex part of the code, so what follows is a long explanation for it.

In our fibonacci example, after obtaining the trace polynomial `t` by interpolating, the transition constraint polynomial is

$$
C(x) = \dfrac{t(xg^2) - t(xg) - t(x)}{\prod_{i = 0}^{5} (x - g^i)}
$$

On our `prove` code, if someone passes us a fibonacci `AIR` like the one we showed above used in one of our tests, we somehow need to construct $C(x)$. However, what we are given is not a polynomial, but rather this method

```rust
fn compute_transition(
        &self,
        frame: &air::frame::Frame<Self::Field>,
    ) -> Vec<FieldElement<Self::Field>> {
    let first_row = frame.get_row(0);
    let second_row = frame.get_row(1);
    let third_row = frame.get_row(2);

    vec![third_row[0] - second_row[0] - first_row[0]]
}
```

So how do we get to $C(x)$ from this? The answer is interpolation. What the method above is doing is the following: if you pass it a frame that looks like this

$$
\begin{bmatrix} t(x_0) \\ t(x_0g) \\ t(x_0g^2) \end{bmatrix}
$$

for any given point $x_0$, it will return the value

$$
t(x_0g^2) - t(x_0g) - t(x_0)
$$

which is the numerator in $C(x_0)$. Using the `transition_exemptions` field we defined in our `AIR`, we can also compute evaluations in the denominator, i.e. the zerofier evaluations. This is done under the hood by the `transition_divisors()` method.

The above means that even though we don't explicitly have the polynomial $C(x)$, we can evaluate it on points given an appropriate frame. If we can evaluate it on enough points, we can then interpolate them to recover $C(x)$. This is exactly how we construct both transition constraint polynomials and subsequently the composition polynomial `H`.

The job of evaluating `H` on enough points so we can then interpolate it is done by the `ConstraintEvaluator` struct. You'll notice `prove` does the following

```rust
let constraint_evaluations = evaluator.evaluate(
    &lde_trace,
    &lde_roots_of_unity_coset,
    &alpha_and_beta_transition_coefficients,
    &alpha_and_beta_boundary_coefficients,
);
```

This function call will return the evaluations of the boundary terms 

$$
B_i(x) (\alpha_i x^{D - deg(B)} + \beta_i)
$$

and constraint terms

$$
C_i(x) (\alpha_i x^{D - deg(C)} + \beta_i)
$$

for every $i$. The `constraint_evaluations` value returned is a `ConstraintEvaluationTable` struct, which is nothing more than a big list of evaluations of each polynomial required to construct `H`.

With this in hand, we just call

```rust
let composition_poly =  
    constraint_evaluations.compute_composition_poly(&   lde_roots_of_unity_coset);
```

which simply interpolates the sum of all evaluations to obtain `H`.

Let's go into more detail on how the `evaluate` method reconstructs $C(x)$ in our fibonacci example. It receives the `lde_trace` as an argument, which is this:

$$
\begin{bmatrix} t(\omega^0) \\ t(\omega^1) \\ \dots \\ t(\omega^{15}) \end{bmatrix}
$$

where $\omega$ is the primitive root of unity used for the `LDE`, that is, $\omega$ satisfies $\omega^2 = g$. We need to recover $C(x)$, a polynomial whose degree can't be more than $t(x)$'s. Because $t$ was built by interpolating `8` points (the trace), we know we can recover $C(x)$ by interpolating it on 16 points. We choose these points to be the `LDE` roots of unity 

$$
\{\omega^0, \omega, \omega^2, \dots, \omega^{15}\}
$$

Remember that to evaluate $C(x)$ on these points, all we need are the evaluations of the polynomial

$$
t(xg^2) - t(xg) - t(x)
$$

as the zerofier ones we can compute easily. These become:

$$
t(\omega^0 g^2) - t(\omega^0 g) - t(\omega^0) \\
t(\omega g^2) - t(\omega g) - t(\omega) \\
t(\omega^2 g^2) - t(\omega^2 g) - t(\omega^2) \\
\vdots \\
t(\omega^{15} g^2) - t(\omega^{15} g) - t(\omega^{15}) \\
$$

If we remember that $\omega^2 = g$, this is

$$
t(\omega^4) - t(\omega^2) - t(\omega^0) \\
t(\omega^5) - t(\omega^3) - t(\omega) \\
t(\omega^6) - t(\omega^4) - t(\omega^2) \\
\vdots \\
t(\omega^{3}) - t(\omega) - t(\omega^{15}) \\
$$

and we can compute each evaluation here by calling `compute_transition` on the appropriate frame built from the `lde_trace`. Specifically, for the first evaluation we can build the frame:

$$
\begin{bmatrix} t(\omega^0) \\ t(\omega^2) \\ t(\omega^{4}) \end{bmatrix}
$$

Calling `compute_transition` on this frame gives us the first evaluation. We can get the rest in a similar fashion, which is what this piece of code in the `evaluate` method does:

```rust
for (i, d) in lde_domain.iter().enumerate() {
    let frame = Frame::read_from_trace(
        lde_trace,
        i,
        blowup_factor,
        &self.air.context().transition_offsets,
    )

    let mut evaluations = self.air.compute_transition(&frame);

    ...
}
```

Each iteration builds a frame as above and computes one of the evaluations needed. The rest of the code just adds the zerofier evaluations, along with the alphas and betas. It then also computes boundary polynomial evaluations by explicitly constructing them.

#### Verifier

The verifier employs the same trick to reconstruct the evaluations on the out of domain point $C_i(z)$ for the consistency check.

## Even/odd decomposition for `H`

At the end of the recap we talked about how in our code we don't actually commit to `H`, but rather an even/odd decomposition for it. These are two polynomials `H_1` and `H_2` that satisfy

$$
H(x) = H_1(x^2) + x H_2(x^2)
$$

This all happens on this piece of code

```rust
let composition_poly =
    constraint_evaluations.compute_composition_poly(&lde_roots_of_unity_coset);

let (composition_poly_even, composition_poly_odd) = composition_poly.even_odd_decomposition();

// Evaluate H_1 and H_2 in z^2.
let composition_poly_evaluations = vec![
    composition_poly_even.evaluate(&z_squared),
    composition_poly_odd.evaluate(&z_squared),
];
```

After this, we don't really use `H` anymore, but rather `H_1` and `H_2`. There's not that much to say other than that.

## Out of Domain Frame

As part of the consistency check, the prover needs to provide evaluations of the trace polynomials in all the points needed by the verifier to check that `H` was constructed correctly. In the fibonacci example, these are $t(z)$, $t(zg)$, and $t(zg^2)$. In code, the prover passes these evaluations as a `Frame`, which we call the out of domain (`ood`) frame. 

The reason we do this is simple: with the frame in hand, the verifier can reconstruct the evaluations of the constraint polynomials $C_i(z)$ by calling the `compute_transition` method on the ood frame and then adding the alphas, betas, and so on, just like we explained in the section above.

## Transcript

Throughout the protocol, there are a number of times where the verifier randomly samples some values that the prover needs to use (think of the alphas and betas used when constructing `H`). Because we don't actually have an interaction between prover and verifier, we emulate it by using a hash function, which we assume is a source of randomness the prover can't control.

The job of providing these samples for both prover and verifier is done by the `Transcript` struct, which you can think of as a stateful `rng`; whenever you call `challenge()` on a transcript you get a random value and the internal state gets mutated, so the next time you call `challenge()` you get a different one. You can also call `append` on it to mutate its internal state yourself. This is done a number of times throughout the protocol to keep the prover honest so it can't predict or manipulate the outcome of `challenge()`.

Notice that to sample the same values, both prover and verifier need to call `challenge` and `append` in the same order (and with the same values in the case of `append`) and the same number of times.

The idea explained above is called the Fiat-Shamir heuristic or just `Fiat-Shamir`, and is more generally used throughout proving systems to remove interaction between prover and verifier. Though the concept is very simple, getting it right so the prover can't cheat is not, but we won't go into that here.

## Proof

The generated proof has got all the information needed for the verifier to verify it:
- Trace length: The number of rows of the trace table, needed to know the max degree of the polynomials that appear in the system.
- LDE trace commitments.
- DEEP composition polynomial out of domain even and odd evaluations.
- DEEP composition polynomial root.
- FRI layers merkle roots.
- FRI last layer value.
- Query list.
- DEEP composition poly openings.
- Nonce: Proof of work setting used to generate the proof.

## Special considerations

### FFT evaluation and interpolation
When evaluating or interpolating a polynomial, if the input (be it coefficients or evaluations) size isn't a power of two then the FFT API will extend it with zero padding until this requirement is met. This is because the library currently only uses a radix-2 FFT algorithm.

Also, right now FFT only supports inputs with a size up to $2^{2^64}$ elements.

## Other

### Why use roots of unity?

Whenever we interpolate or evaluate trace, boundary and constraint polynomials, we use some $2^n$-th roots of unity. There are a few reasons for this:

- Using roots of unity means we can use the [Fast Fourier Transform](https://en.wikipedia.org/wiki/Fast_Fourier_transform) and its inverse to evaluate and interpolate polynomials. This method is much faster than the naive Lagrange interpolation one. Since a huge part of the STARK protocol involves both evaluating and interpolating, this is a huge performance improvement.
- When computing boundary and constraint polynomials, we divide them by their `zerofiers`, polynomials that vanish on a few points (the trace elements where the constraints do not hold). These polynomials take the form

    $$
    Z(X) = \prod (X - x_i)
    $$

    where the $x_i$ are the points where we want it to vanish.

    When implementing this, evaluating this polynomial can be very expensive as it involves a huge product. However, if we are using roots of unity, we can use the following trick. The vanishing polynomial for all the $2^n$ roots of unity is

    $$
    X^{2^n} - 1
    $$

    Instead of expressing the zerofier as a product of the places where it should vanish, we express it as the vanishing polynomial above divided by the `exemptions` polynomial; the polynomial whose roots are the places where constraints don't need to hold. 

    $$
    Z(X) = \dfrac{X^{2^n} - 1}{\prod{(X - e_i)}}
    $$

    where the $e_i$ are now the points where we don't want it to vanish. This `exemptions` polynomial in the denominator is usually much smaller, and because the vanishing polynomial in the numerator is only two terms, evaluating it is really fast.

### What is a primitive root of unity?

The $n$-th roots of unity are the numbers $x$ that satisfy

$$
x^n = 1
$$

There are $n$ such numbers, because they are the roots of the polynomial $X^n - 1$. The set of $n$-th roots of unity always has a `generator`, a root $g$ that can be used to obtain every other root of unity by exponentiating. What this means is that the set of $n$-th roots of unity is

$$
\{g^i : 0 \leq i < n\}
$$

Any such generator `g` is called a *primitive root of unity*. It's called primitive because it allows us to recover any other root.

Here are a few important things to keep in mind, some of which we use throughout our implementation:

- There are always several primitive roots. If $g$ is primitive, then any power $g^k$ with $k$ coprime with $n$ is also primitive. As an example, if $g$ is a primitive $8$-th root of unity, then $g^3$ is also primitive.
- We generally will not care about which primitive root we choose; what we do care about is being *consistent*. We should always choose the same one throughout our code, otherwise computations will go wrong.
- Because $g^n = 1$, the powers of $g$ wrap around. This means

    $$
    g^{n + 1} = g \\
    g^{n + 2} = g^2
    $$

  and so on.
- If $w$ is a primitive $2^{n + 1}$-th root of unity, then $w^2$ is a primitive $2^n$-th root of unity. In general, if $w$ is a primitive $2^{n + k}$-th primitive root of unity, then $w^{2^k}$ is a primitive $2^n$-th root of unity.

### Why use Cosets?

When we perform `FRI` on the `DEEP` composition polynomial, the low degree extension we use is not actually over a set of higher roots of unity than the ones used for the trace, but rather a *coset* of it. A coset is simply a set of numbers all multiplied by the same element. We call said element the `offset`. In our case, a coset of the $2^n$-th roots of unity with primitive root $\omega$ and offset `h` is the set

$$
\{h \omega^i : 0 \leq i < 2^n\}
$$

So why not just do the LDE without the offset? The problem is in how we construct and evaluate the composition polynomial `H`. Let's say our trace polynomial was interpolated over the $2^n$-th roots of unity with primitive root $g$, and we are doing the LDE over the $2^{n + 1}$-th roots of unity with primitive root $\omega$, so $\omega^2 = g$ (i.e. the blowup factor is `2`).

Recall that `H` is a sum of terms that include boundary and transition constraint polynomials, and each one of them includes a division by a `zerofier`; a polynomial that vanishes on some roots of unity $g^i$. This is because the zerofier is what tells us which rows of the trace our constraint should apply on.

When doing `FRI`, we have to provide evaluations over the LDE domain we are using. If we don't include the offset, our domain is

$$
\{\omega^i : 0 \leq i < 2^{n + 1}\}
$$

Note that, because $w^2 = g$, some of the elements on this set (actually, half of them) are powers of $g$. If while doing `FRI` we evaluate `H` on them, the zerofier could vanish and we'd be dividing by zero. We introduce the offset to make sure this can't happen.

NOTE: a careful reader might note that we can actually evaluate `H` on the elements $g^i$, since on a valid trace the zerofiers will actually divide the polynomials on their numerator. The problem still remains, however, because of performance. We don't want to do polynomial division if we don't need to, it's much cheaper to just evaluate numerator and denominator and then divide. Of course, this only works if the denominator doesn't vanish; hence, cosets.


# Cairo

## Trace

The execution of a Cairo program produces a memory vector $V$ and a matrix $M$ of size $L \times 3$ with the evolution of the three registers `pc`, `ap`, `fp`. All of them with entries in $\mathbb{F}$.

### Construction of execution trace $T$:
In this section we describe the construction of the execution trace $T$. This is the matrix mentioned [here](#definitions) in the description of the STARK protocol

1. Augment each row of $M$ with information about the pointed instruction as follows: For each entry $(\text{pc}_i, \text{ap}_i, \text{fp}_i)$ of $M$, unpack the $\text{pc}_i$-th value of $V$. The result is a new matrix $M \in \mathbb{F}^{L\times 33}$ with the following layout
```
 A.  flags     (16) : Decoded instruction flags
 B.  res       (1)  : Res value
 C.  pointers  (2)  : Temporary memory pointers (ap and fp)
 D.  mem_a     (4)  : Memory addresses (pc, dst_addr, op0_addr, op1_addr)
 E.  mem_v     (4)  : Memory values (inst, dst, op0, op1)
 F.  offsets   (3)  : (off_dst, off_op0, off_op1)
 G.  derived   (3)  : (t0, t1, mul)

 A                B C  D    E    F   G
|xxxxxxxxxxxxxxxx|x|xx|xxxx|xxxx|xxx|xxx|
```
1. Let $r_\text{min}$ and $r_\text{max}$ be respectively the minimum and maximum values of the entries of the submatrix $M_\text{offsets}$ defined by the columns of the group `offsets`. Let $v$ be the vector of all the values between $r_\text{min}$ and $r_\text{max}$ that are not in $M_\text{offsets}$. If the length of $v$ is not a multiple of three, extend it to the nearest multiple of three using one arbitrary value of $v$.

1. Let $R$ be the last row of $M$, and let $R'$ be the vector that's equal to $R$ except that it has zeroes in entries corresponding to the ordered set of columns `mem_a` and `mem_v`. The set is ordered incrementally by `mem_a`. Let $L_{\text{pub}}$ be the length of the public input (program code). Extend $M$ with additional $L':=\lceil L_{\text{pub}}/4 \rceil$ rows to obtain a matrix $M \in \mathbb{F}^{(L + L')\times 33}$ by appending copies of $R'$ at the bottom (the notation $\lceil x \rceil$ means the _ceiling function_, defined as the smallest integer that is not smaller than $x$).

1. Let $R''$ be the vector that's equal to $R$ except that it has zeroes in entries corresponding to the set of columns `mem_a` and `mem_v`, let $M_\text{addr}$ be the submatrix defined by the columns of the group `addresses`, let $L'' = (L''_0, L''_1, ..., L''_J)^T$ the submatrix that asserts $M_\text{addr,i,j} < L''_\text{0,j}$, $L''_\text{I,j} < M_\text{addr,i+1,j}$ where $M_\text{addr,i+1,j} - M_\text{addr,i,j} > 1$ and $0 \le j \le J$ and $I = |L''_j|$. Extend $M$ with additional $L''$ rows to obtain a matrix $M \in \mathbb{F}^{(L + L' + L'')\times 33}$ by appending copies of $R''$ at the bottom.

1. Pad $M$ with copies of its last row until it has a power of two number of rows. As a result we obtain a matrix $T\in\mathbb{F}^{2^n\times 33}$.

## Extended columns

The verifier sends challenges $\alpha, z \in \mathbb{F}$ (or the prover samples them from the transcript). Additional columns are added to incorporate the memory constraints. To define them the prover follows these steps:
1. Stack the rows of the submatrix of $T$ defined by the columns `pc, dst_addr, op0_addr, op1_addr` into a vector `a` of length $2^{n+2}$ (this means that the first entries of `a` are `pc[0], dst_addr[0], op0_addr[0], op1_addr[0], pc[1], dst_addr[1],...`).
1. Stack the the rows of the submatrix defined by the columns `inst, dst, op0, op1` into a vector `v` of length $2^{n+2}$.
1. Define $M_{\text{Mem}}\in\mathbb{F}^{2^{n+2}\times 2}$ to be the matrix with columns $a$, $v$.
1. Define $M_{\text{MemRepl}}\in\mathbb{F}^{2^{n+2}\times 2}$ to be the matrix that's equal to $M_{\text{Mem}}$ in the first $2^{n+2} - L_{\text{pub}}$ rows, and its last $L_{\text{pub}}$ entries are the addresses and values of the actual public memory (program code).
1. Sort $M_{\text{MemRepl}}$ by the first column in increasing order. The result is a matrix $M_{\text{MemReplSorted}}$ of size $2^{n+2}\times 2$. Denote its columns by $a'$ and $v'$.
1. Compute the vector $p$ of size $2^{n+2}$ with entries 
$$ p_i := \prod_{j=0}^i\frac{z - (a_i' + \alpha v_i')}{z - (a_i + \alpha v_i)}$$
1. Reshape the matrix $M_{\text{MemReplSorted}}$ into a $2^n\times 8$ in row-major. Reshape the vector $p$ into a $2^n \times 4$ matrix in row-major.
1. Concatenate these 12 rows. The result is a matrix $M_\text{MemRAP2}$ of size $2^n \times 12$

The verifier sends challenge $z' \in \mathbb{F}$. Further columns are added to incorporate the range check constraints following these steps:

1. Stack the rows of the submatrix of $T$ defined by the columns in the group `offsets` into a vector $b$ of length $3\cdot 2^n$.
1. Sort the values of $b$ in increasing order. Let $b'$ be the result.
1. Compute the vector $p'$ of size $3\cdot 2^n$ with entries
$$ p_i' := \prod_{j=0}^i\frac{z' - b_i'}{z' - b_i}$$
1. Reshape $b'$ and $p'$ into matrices of size $2^n \times 3$ each and concatenate them into a matrix $M_\text{RangeCheckRAP2}$ of size $2^n \times 6$.
1. Concatenate $M_\text{MemRAP2}$ and $M_\text{RangeCheckRAP2}$ into a matrix $M_\text{RAP2}$ of size $2^n \times 18$.


Using the notation described at the beginning, $m'=33$, $m''=18$ and $m=52$. They are respectively the columns of the first and second part of the rap, and the total number of columns.


Putting all together, the final layout of the trace is the following

```
 A.  flags      (16) : Decoded instruction flags
 B.  res        (1)  : Res value
 C.  pointers   (2)  : Temporary memory pointers (ap and fp)
 D.  mem_a      (4)  : Memory addresses (pc, dst_addr, op0_addr, op1_addr)
 E.  mem_v      (4)  : Memory values (inst, dst, op0, op1)
 F.  offsets    (3)  : (off_dst, off_op0, off_op1)
 G.  derived    (3)  : (t0, t1, mul)
 H.  mem_a'     (4)  : Sorted memory addresses
 I.  mem_v'     (4)  : Sorted memory values
 J.  mem_p      (4)  : Memory permutation argument columns
 K.  offsets_b' (3)  : Sorted offset columns
 L.  offsets_p' (3)  : Range check permutation argument columns

 A                B C  D    E    F   G   H    I    J    K   L
|xxxxxxxxxxxxxxxx|x|xx|xxxx|xxxx|xxx|xxx|xxxx|xxxx|xxxx|xxx|xxx|
```

## Virtual columns and Subcolumns
### Virtual Columns

In previous chapters, we have seen how the registers states and the memory are augmented to generate a provable trace. 

While we have shown a way of doing that, there isn't only one possible provable trace. In fact, there are multiple configurations possible. 

For example, in the Cairo VM, we have 15 flags. These flags include  "DstReg", "Op0Reg", "OpCode" and others. For simplification, let's imagine we have 3 flags with letters from "A" to "C", where "A" is the first flag. 

Now, let's assume we have 4 steps in our trace. If we were to only use plain columns, the layout would look like this:

| FlagA| FlagB| FlagB|
|  --  |  --  | --   |
|  A0  |  B0  |  C0  |
|  A1  |  B1  |  C1  |
|  A2  |  B2  |  C2  |
|  A3  |  B3  |  C3  |

But, we could also organize them like this

| Flags|
|  --  |
|  A0  |
|  B0  |
|  C0  |
|  A1  |
|  B1  |
|  C1  |
|  A2  |
|  B2  |
|  C2  |
|  A3  |
|  B3  |
|  C3  |

The only problem is that now the constraints for each transition of the rows are not the same. We will have to define then a concept called "Virtual Column".

A Virtual Column is like a traditional column, which has its own set of constraints, but it exists interleaved with another one. In the previous example, each row is associated with a column, but in practice, we could have different ratios. We could have 3 rows corresponding to one Virtual Column, and the next one corresponding to another one. For the time being, let's focus on this simpler example.

Each row corresponding to Flag A will have the constraints associated with its own Virtual Column, and the same will apply to Flag B and Flag C.

Now, to do this, we will need to evaluate the multiple rows taking into account that they are part of the same step. For a real case, we will add a dummy flag D, whose purpose is to make the evaluation move in a number that is a power of 2. 

Let's see how it works. If we were evaluating the Frame where the constraints should give 0, the frame movement would look like this:

```diff
+ A0 | B0 | C0
+ A1 | B1 | C1
  A2 | B2 | C2
  A3 | B3 | C3
```
```diff
  A0 | B0 | C0
+ A1 | B1 | C1
+ A2 | B2 | C2
  A3 | B3 | C3
```
```diff
  A0 | B0 | C0
  A1 | B1 | C1
+ A2 | B2 | C2
+ A3 | B3 | C3
```

In the second case, the evaluation would look like this:

```diff 
+ A0 |
+ B0 |
+ C0 |
+ D0 |
+ A1 |
+ B1 |
+ C1 |
+ D1 |
  A2 |
  B2 |
  C2 |
  D2 |
  A3 |
  B3 |
  C3 |
  D3 |
```
```diff
  A0 |
  B0 |
  C0 |
  D0 |
+ A1 |
+ B1 |
+ C1 |
+ D1 |
+ A2 |
+ B2 |
+ C2 |
+ D2 |
  A3 |
  B3 |
  C3 |
  D3 |
```

```diff
  A0 |
  B0 |
  C0 |
  D0 |
  A1 |
  B1 |
  C1 |
  D1 |
+ A2 |
+ B2 |
+ C2 |
+ D2 |
+ A3 |
+ B3 |
+ C3 |
+ D3 |
```

When evaluating the composition polynomial, we will do it over the points on the LDE, where the constraints won't evaluate to 0, but we will use the same spacing. Assume we have three constraints for each flag, $C_{0}$, $C_{1}$, and $C_{2}$, and that they don't involve other trace cells. Let's call the index of the frame evaluation i, starting from 0.

In the first case, the constraint $C_{0}$, $C_{1}$ and $C_{2}$ would be applied over the same rows, giving an equation that looks like this:

$`C_{k}(w^i, w^{i+1})`$

In the second case, the equations would look like:

$`C_{0}(w^{i*4}, w^{i*4+4})`$

$`C_{1}(w^{i*4+1}, w^{i*4+5})`$

$`C_{2}(w^{i*4+2}, w^{i*4+6})`$

### Virtual Subcolumns

Assume now we have 3 columns that share some constraints. For example, let's have three flags that can be either 0 or 1. Each flag will also have its own set of dedicated constraints. 

Let's denote the shared constraint $B$, and the independent constraints $C_{i}$.

What we can do is define a Column for the flags, where the binary constraint $B$ is enforced. Additionally, we will define a subcolumn for each flag, which will enforce each $C_{i}$.

In summary, if we have a set of shared constraints to apply, we will be using a Column. If we want to mix or interleave Columns, we will define them as Virtual Columns. And if we want to apply more constraints to a subset of a Column of Virtual Columns, or share constraints between columns, we will define Virtual Subcolumns.

## Builtins

We can understand the built-in as a small machine, that we can use to efficiently prove a subprogram. For example, it may be able to prove a hash, like Poseidon or Keccak, verify a signature, or check that some variable is in a range, and the cost would be less than what we would have if using the Cairo VM instructions.

For each subprogram we want to prove, we will have a machine, which will have its own set of constraints in the prover. Let's take for example the Range Check built-in. This builtin enforces that a value $X$ is between 0 and $2^{128}$.

The logic behind the built-in is pretty straightforward. We split $X$ into 8 parts. So we will say that $X = X_{0} + X_{1} * 2^{16} + X_{2} * 2^{32} + X_{3} * 2^{48} + ... + X_{7} * 2^{112}$

Then we require that each is in the range $0 < X_{i} < 2^{16}$. The idea here is to reuse the Range Check constraint that checks if the offsets are between $0$ and $2^{16}$. If we can decompose the number in eight limbs of 16 bits, and we don't need any more limbs, it follows that the number will be less than $2^{128}$

The missing ingredient is how we make sure that each value $X$ that should be constrained by the built-in is actually constrained.

The process starts with the VM designating special memory positions for the built-in. You can think of this as a way of communicating the VM with the specific built-in machine by sharing memory. 

The VM won't save any instruction associated with how the built-in gets to the result and will assume the output is correct. You can think of this as an IO device in any computer, which works in a similar fashion. The VM delegates the work to an external device and takes the result from the memory.

Knowing which specific positions of the memory are used by the built-in, the prover can add more constraints that enforce the calculations of the built-in were done correctly. Let's see how it's done.

In the constraint system of the VM, we will treat every memory cell associated with the built-in as any other, treating it as a pair of addresses and values with the usual constraints. Additionally, we will add more that are specific to the builtin. 

Let's say we have multiple values $x_{i}$, such that each $x_{i}$ needs to be range checked by the built-in. Let each value be stored in a memory address $m_{i}$. Let the initial expected memory position for the range check built-in be $r_{0}$. Here $r_{0}$ is a value known and a public input.

We need to enforce then that $m_{0} = r_{0}$, and that the built in $m_{i+1} = m_{i} + 1$. These constraints have to be put on top of the constraints that are used by the memory, and that's the key to all of this. If these constraints weren't in place, there wouldn't be an enforced link between the Builtin and the VM, which would lead to security issues.

As one last detail, since the memory cells share the same constraints, and we add more for the ones in the builtin, we can treat the builtin cells as a subcolumn. In that case, we can assign one cell for the memory every N cell, giving a ratio that will be observable in the layout. 

This gives a better relationship between the number of cells used for the VM, and the builtin, giving an improvement in performance.
