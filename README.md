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
- [STARKs](#stark-prover)
    - [Recap](#recap)
    - [Protocol overview](#protocol-overview)

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


# STARK Prover

The goal of this document is to give a good a understanding of our stark prover code. To this end, in the first section we go through a recap of how the proving system works at a high level mathematically; then we dive into how that's actually implemented in our code.

## Recap

## Verifying Computation through Polynomials

In general, we express computation in our proving system by providing an *execution trace* satisfying certain *constraints*. The execution trace is a table containing the state of the system at every step of computation. This computation needs to follow certain rules to be valid; these rules are our *constraints*.

The constraints for our computation are expressed using an `Algebraic Intermediate Representation` or `AIR`. This representation uses polynomials to encode constraints, which is why sometimes they are called `polynomial constraints`.

To make all this less abstract, let's go through two examples.

### Fibonacci numbers

Throughout this section and the following we will use this example extensively to have a concrete example. Even though it's a bit contrived (no one cares about computing fibonacci numbers), it's simple enough to be useful. STARKs and proving systems in general are very abstract things; having an example in mind is essential to not get lost.

Let's say our computation consists of calculating the `k`-th number in the fibonacci sequence. This is just the sequence of numbers \\(a_n\\) satisfying

\\[
    a_0 = 1 
\\]
\\[
    a_1 = 1
\\]
\\[
    a_{n+2} = a_{n + 1} + a_n
\\]

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

Below we go through a step by step explanation of a STARK prover. We will assume the trace of the fibonacci sequence mentioned above; it consists of only one column of length \\(2^n\\). In this case, we'll take `n=3`. The trace looks like this

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

The first step is to interpolate these values to generate the `trace polynomial`. This will be a polynomial encoding all the information about the trace. The way we do it is the following: in the finite field we are working in, we take an `8`-th primitive root of unity, let's call it `g`. It being a primitive root means two things:

- `g` is an `8`-th root of unity, i.e., \\(g^8 = 1\\).
- Every `8`-th root of unity is of the form \\(g^i\\) for some \\(0 \leq i \leq 7\\).

With `g` in hand, we take the trace polynomial `t` to be the one satisfying

$$
t(g^i) = a_i
$$

From here onwards, we will talk about the validity of the trace in terms of properties that this polynomial must satisfy. We will also implicitly identify a certain power of \\(g\\) with its corresponding trace element, so for example we sometimes think of \\(g^5\\) as \\(a_5\\), the fifth row in the trace, even though technically it's \\(t\\) *evaluated in* \\(g^5\\) that equals \\(a_5\\).

We talked about two different types of constraints the trace must satisfy to be valid. They were:

- The first two rows are `1`.
- The value on any other row is the sum of the two preceding ones.

In terms of `t`, this translates to

- \\(t(g^0) = 1\\) and \\(t(g) = 1\\).
- \\(t(x g^2) - t(xg) - t(x) = 0\\) for all \\(x \in \{g^0, g^1, g^2, g^3, g^4, g^5\}\\). This is because multiplying by `g` is the same as advancing a row in the trace.

### Composition Polynomial

To convince the verifier that the trace polynomial satisfies the relationships above, the prover will construct another polynomial that shows that both the boundary and transition constraints are satisfied and commit to it. We call this polynomial the `composition polynomial`, and usually denote it with \\(H\\). Constructing it involves a lot of different things, so we'll go step by step introducing all the moving parts required.

#### Boundary polynomial

To show that the boundary constraints are satisfied, we construct the `boundary polynomial`. Recall that our boundary constraints are \\(t(g^0) = t(g) = 1\\). Let's call \\(P\\) the polynomial that interpolates these constraints, that is, \\(P\\) satisfies:

$$
P(1) = 1 \\
P(g) = 1
$$

The boundary polynomial \\(B\\) is defined as follows:

$$
B(x) = \dfrac{t(x) - P(x)}{(x - 1) (x - g)}
$$

The denominator here is called the `boundary zerofier`, and it's the polynomial whose roots are the elements of the trace where the boundary constraints must hold.

How does \\(B\\) encode the boundary constraints? The idea is that, if the trace satisfies said constraints, then

$$
t(1) - P(1) = 1 - 1 = 0 \\
$$
$$
t(g) - P(g) = 1 - 1 = 0
$$

so \\(t(x) - P(x)\\) has \\(1\\) and \\(g\\) as roots. Showing these values are roots is the same as showing that \\(B(x)\\) is a polynomial instead of a rational function, and that's why we construct \\(B\\) this way.

#### Transition constraint polynomial
To convince the verifier that the transition constraints are satisfied, we construct the `transition constraint polynomial` and call it \\(C(x)\\). It's defined as follows:

$$
C(x) = \dfrac{t(xg^2) - t(xg) - t(x)}{\prod_{i = 0}^{5} (x - g^i)}
$$

How does \\(C\\) encode the transition constraints? We mentioned above that these are satisfied if the polynomial in the numerator vanishes in the elements \\(\{g^0, g^1, g^2, g^3, g^4, g^5\}\\). As with \\(B\\), this is the same as showing that \\(C(x)\\) is a polynomial instead of a rational function.

#### Constructing \\(H\\)
With the boundary and transition constraint polynomials in hand, we build the `composition polynomial` \\(H\\) as follows: The verifier will sample four numbers \\(\alpha_1, \alpha_2, \beta_1, \beta_2\\) and \\(H\\) will be

$$
H(x) = B(x) (\alpha_1 x^{D - deg(B)} + \beta_1) + C(x) (\alpha_2 x^{D - deg(C)} + \beta_2)
$$

where \\(D\\) is the smallest power of two greater than the degrees of both \\(B\\) and \\(C\\), so for example if \\(deg(B) = 3\\) and \\(deg(C) = 6\\), then \\(D = 8\\).

Why not just take \\(H(x) = B(x) + C(x)\\)? The reason for the alphas and betas is to make the resulting \\(H\\) be always different and unpredictable for the prover, so they can't precompute stuff beforehand. The \\(x^{D - deg(...)}\\) term is there to adjust the degree of the constraints. This ensures the soundness of the protocol according to the [ethSTARK documentation](https://eprint.iacr.org/2021/582.pdf).

With what we discussed above, showing that the constraints are satisfied is equivalent to saying that `H` is a polynomial and not a rational function (we are simplifying things a bit here, but it works for our purposes).

### Commiting to \\(H\\)

To show \\(H\\) is a polynomial we are going to use the `FRI` protocol, which we treat as a black box. For all we care, a `FRI` proof will verify if what we committed to is indeed a polynomial. Thus, the prover will provide a `FRI` commitment to `H`, and if it passes, the verifier will be convinced that the constraints are satisfied.

There is one catch here though: how does the verifier know that `FRI` was applied to `H` and not any other polynomial? For this we need to add an additional step to the protocol. 


### Consistency check
After commiting to `H`, the prover needs to show that `H` was constructed correctly according to the formula above. To do this, it will ask the prover to provide an evaluation of `H` on some random point `z` and evaluations of the trace at the points \\(t(z), t(zg)\\) and \\(t(zg^2)\\).

Because the boundary and transition constraints are a public part of the protocol, the verifier knows them, and thus the only thing it needs to compute the evaluation \\((z)\\) by itself are the three trace evaluations mentioned above. Because it asked the prover for them, it can check both sides of the equation:

$$
H(z) = B(z) (\alpha_1 z^{D - deg(B)} + \beta_1) + C(z) (\alpha_2 z^{D - deg(C)} + \beta_2)
$$

and be convinced that \\(H\\) was constructed correctly.

We are still not done, however, as the prover could have now cheated on the values of the trace or composition polynomial evaluations.

### Deep Composition Polynomial

There are two things left the prover needs to show to complete the proof:

- That \\(H\\) effectively is a polynomial, i.e., that the constraints are satisfied.
- That the evaluations the prover provided on the consistency check were indeed evaluations of the trace polynomial and composition polynomial on the out of domain point `z`.

Earlier we said we would use the `FRI` protocol to commit to `H` and show the first item in the list. However, we can slightly modify the polynomial we do `FRI` on to show both the first and second items at the same time. This new modified polynomial is called the `DEEP` composition polynomial. We define it as follows:

$$
Deep(x) = \gamma_1 \dfrac{H(x) - H(z)}{x - z} + \gamma_2 \dfrac{t(x) - t(z)}{x - z} + \gamma_3 \dfrac{t(x) - t(zg)}{x - zg} + \gamma_4 \dfrac{t(x) - t(zg^2)}{x - zg^2}
$$

where the numbers \\(\gamma_i\\) are randomly sampled by the verifier.

The high level idea is the following: If we apply `FRI` to this polynomial and it verifies, we are simultaneously showing that

- \\(H\\) is a polynomial and the prover indeed provided `H(z)` as one of the out of domain evaluations. This is the first summand in `Deep(x)`.
- The trace evaluations provided by the prover were the correct ones, i.e., they were \\(t(z)\\), \\(t(zg)\\), and \\(t(zg^2)\\). These are the remaining summands of the `Deep(x)`.

#### Consistency check
The prover needs to show that `Deep` was constructed correctly according to the formula above. To do this, the verifier will ask the prover to provide:

- An evaluation of `H` on `z` and `x_0`
- Evaluations of the trace at the points \\(t(z)\\), \\(t(zg)\\), \\(t(zg^2)\\) and \\(t(x_0)\\)

Where `z` is the same random, out of domain point used in the consistency check of the composition polynomial, and `x_0` is a random point that belongs to the trace domain.

With the values provided by the prover, the verifier can check both sides of the equation:

$$
Deep(x_0) = \gamma_1 \dfrac{H(x_0) - H(z)}{x_0 - z} + \gamma_2 \dfrac{t(x_0) - t(z)}{x_0 - z} + \gamma_3 \dfrac{t(x_0) - t(zg)}{x_0 - zg} + \gamma_4 \dfrac{t(x_0) - t(zg^2)}{x_0 - zg^2}
$$

The prover also needs to show that the trace evaluation \\(t(x_0)\\) belongs to the trace. To achieve this, it needs to commit the merkle roots of `t` and the merkle proof of \\(t(x_0)\\).

### Summary

We summarize below the steps required in a STARK proof for both prover and verifier.

#### Prover side

- Compute the trace polynomial `t` by interpolating the trace column over a set of \\(2^n\\)-th roots of unity \\(\{g^i : 0 \leq i < 2^n\}\\).
- Compute the boundary polynomial `B`.
- Compute the transition constraint polynomial `C`.
- Construct the composition polynomial `H` from `B` and `C`.
- Sample an out of domain point `z` and provide the evaluations \\(H(z)\\), \\(t(z)\\), \\(t(zg)\\), and \\(t(zg^2)\\) to the verifier.
- Sample a domain point `x_0` and provide the evaluations \\(H(x_0)\\) and \\(t(x_0)\\) to the verifier.
- Construct the deep composition polynomial `Deep(x)` from `H`, `t`, and the evaluations from the item above.
- Do `FRI` on `Deep(x)` and provide the resulting FRI commitment to the verifier.
- Provide the merkle root of `t` and the merkle proof of \\(t(x_0)\\).

#### Verifier side

- Take the evaluations \\(H(z)\\), \\(H(x_0)\\), \\(t(z)\\), \\(t(zg)\\), \\(t(zg^2)\\) and \\(t(x_0)\\) the prover provided.
- Reconstruct the evaluations \\(B(z)\\) and \\(C(z)\\) from the trace evaluations we were given. Check that the claimed evaluation \\(H(z)\\) the prover gave us actually satisfies
    $$
    H(z) = B(z) (\alpha_1 z^{D - deg(B)} + \beta_1) + C(z) (\alpha_2 z^{D - deg(C)} + \beta_2)
    $$
- Check that the claimed evaluation \\(Deep(x_0)\\) the prover gave us actually satisfies
    $$
    Deep(x_0) = \gamma_1 \dfrac{H(x_0) - H(z)}{x_0 - z} + \gamma_2 \dfrac{t(x_0) - t(z)}{x_0 - z} + \gamma_3 \dfrac{t(x_0) - t(zg)}{x_0 - zg} + \gamma_4 \dfrac{t(x_0) - t(zg^2)}{x_0 - zg^2}
    $$
- Using the merkle root and the merkle proof the prover provided, check that \\(t(x_0)\\) belongs to the trace.
- Take the provided `FRI` commitment and check that it verifies.

## Simplifications and Omissions

The walkthrough above was for the fibonacci example which, because of its simplicity, allowed us to sweep under the rug a few more complexities that we'll have to tackle on the implementation side. They are:

#### Multiple trace columns

Our trace contained only one column, but in the general setting there can be multiple (the Cairo `AIR` has around 30). This means there isn't just *one* trace polynomial, but several; one for each column. This also means there are multiple boundary constraint polynomials.

The general idea, however, remains the same. The deep composition polynomial `H` is now the sum of several terms containing the boundary constraint polynomials \\(B_1(x), \dots, B_k(x)\\) (one per column), and each \\(B_i\\) is in turn constructed from the \\(i\\)-th trace polynomial \\(t_i(x)\\).

#### Multiple transition constraints

Much in the same way, our fibonacci `AIR` had only one transition constraint, but there could be several. We will therefore have multiple transition constraint polynomials \\(C_1(x), \dots, C_n(x)\\), each of which encodes a different relationship between rows that must be satisfied. Also, because there are multiple trace columns, a transition constraint can mix different trace polynomials. One such constraint could be

$$
C_1(x) = t_1(gx) - t_2(x)
$$

which means "The first column on the next row has to be equal to the second column in the current row".

Again, even though this seems way more complex, the ideas remain the same. The composition polynomial `H` will now include a term for every \\(C_i(x)\\), and for each one the prover will have to provide out of domain evaluations of the trace polynomials at the appropriate values. In our example above, to perform the consistency check on \\(C_1(x)\\) the prover will have to provide the evaluations \\(t_1(zg)\\) and \\(t_2(z)\\).

#### Composition polynomial decomposition

In the actual implementation, we won't commit to \\(H\\), but rather to a decomposition of \\(H\\) into an even term \\(H_1(x)\\) and an odd term \\(H_2(x)\\), which satisfy

$$
H(x) = H_1(x^2) + x H_2(x^2)
$$

This way, we don't commit to \\(H\\) but to \\(H_1\\) and \\(H_2\\). This is just an optimization at the code level; once again, the ideas remain exactly the same.

#### FRI, low degree extensions and roots of unity

We treated `FRI` as a black box entirely. However, there is one thing we do need to understand about it: low degree extensions.

When applying `FRI` to a polynomial of degree \\(n\\), we need to provide evaluations of it over a domain with *more* than \\(n\\) points. In our case, the `DEEP` composition polynomial's degree is around the same as the trace's, which is, at most, \\(2^n - 1\\) (because it interpolates the trace containing \\(2^n\\) points).

The domain we are going to choose to evaluate our `DEEP` polynomial on will be a set of *higher* roots of unity. In our fibonacci example, we will take a primitive \\(16\\)-th root of unity \\(\omega\\). As a reminder, this means:

- \\(\omega\\) is an \\(16\\)-th root of unity, i.e., \\(\omega^{16} = 1\\).
- Every \\(16\\)-th root of unity is of the form \\(\omega^i\\) for some \\(0 \leq i \leq 15\\).

Additionally, we also take it so that \\(\omega\\) satisfies \\(\omega^2 = g\\) (\\(g\\) being the \\(8\\)-th primitive root of unity we used to construct `t`).

The evaluation of \\(t\\) on the set \\(\{\omega^i : 0 \leq i \leq 15\}\\) is called a *low degree extension* (`LDE`) of \\(t\\). Notice this is not a new polynomial, they're evaluations of \\(t\\) on some set of points. Also note that, because \\(\omega^2 = g\\), the `LDE` contains all the evaluations of \\(t\\) on the set of powers of \\(g\\). In fact,

$$
    \{t(\omega^{2i}) : 0 \leq i \leq 15\} = \{t(g^i) : 0 \leq i \leq 7\}
$$

This will be extremely important when we get to implementation.

For our `LDE`, we chose \\(16\\)-th roots of unity, but we could have chosen any other power of two greater than \\(8\\). In general, this choice is called the `blowup factor`, so that if the trace has \\(2^n\\) elements, a blowup factor of \\(b\\) means our LDE evaluates over the \\(2^{n} * b\\) roots of unity (\\(b\\) needs to be a power of two). The blowup factor is a parameter of the protocol related to its security.

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

The prover will need to interpolate polynomials and he will always do it over the set $D_S = \{ g^i \}_{ i=0 }^{ 2^n-1 } \subseteq \mathbb{F}$, where $g$ is a $2^n$ root of unity in $\mathbb{F}$. Also, the vector commitments will be performed over the set $D_{LDE} = (h, h \omega, h \omega^2, \dots, h \omega^{2^{n + l}})$ where $\omega$ is a $2^{n + l}$ root of unity and $h$ is some field element. This is the set we denoted $D$ in the commitment scheme section. The specific choices for the shapes of these sets are motivated by optimizations at a code level.

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


