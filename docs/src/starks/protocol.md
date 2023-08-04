# STARKs protocol

In this section we describe precisely the STARKs protocol used in Lambdaworks.

We begin by fixng notation for most of the relevant objects and values to refer to them later on.

## General notation

- $\mathbb{F}$ denotes a finite field.
- Given a vector $D=(y_1,\dots,y_L)$ and a function $f:\text{set}(D) \to \mathbb{F}$, denote by $f(D)$ the vector $(f(y_1),\dots,f(y_L))$. Here $\text{set}(D)$ denotes the underlying set of $A$.
- A polynomial $p \in \mathbb{F}[X]$ induces a function $f:A \to \mathbb{F}$ for every subset $A$ of $\mathbb{F}$, where $f(a) := p(a)$.
- Let $p, q \in \mathbb{F}[X]$ be two polynomials. A function $f: A \to \mathbb{F}$ can be induce from them for every subset $A$ disjoint from the set of roots of $q$, defined by $f(a) := p(a) q(a)^{-1}$. We abuse notation and denote $f$ by $p/q$.

## Definitions 

We assume the prover has already obtained the trace of the execution of the program. This is a matrix $T$ with entries in a finite field $\mathbb{F}$. We assume the number of rows of $T$ is $2^n$ for some $n$ in $\mathbb{N}$.

#### Values known by the prover and verifier prior to the interactions

These values are determined the program,  the specifications of the AIR being used and the security parameters chosen.

- $m'$ is the number of columns of the trace matrix $T$.
- $r$ the number of RAP challenges.
- $m''$ is the number of extended columns of the trace matrix in the (optional) second round of RAP.
- $m$ is the total number of columns: $m := m' + m''$.
- $P_k^T$ denote the transition constraint polynomials for $k=1,\dots,n_T$. We are assuming these are of degree at most 2.
- $Z_j^T$ denote the transition constraint zerofiers for $k=1,\dots,n_T$.
- $b=2^l$ is the *blowup factor*.
- $Q$ is number of FRI queries.
- We assume there is a fixed hash function from $\mathbb{F}$ to binary strings. We also assume all Merkle trees are constructed using this hash function.

#### Values computed by the prover
These values are computed by the prover from the execution trace and are sent to the verifier along with the proof.
- $2^n$ is the number of rows of the trace matrix after RAP.
- $\omega$ a primitive $2^{n+l}$-th root of unity.
- $g = \omega^{b}$.
- An element $h\in\mathbb{F} \setminus \{\omega^i\}_{i \geq 0}$. This is called the *coset factor*.
- Boundary constraints polynomials $P_j^B$ for $j=1,\dots,m$.
- Boundary constraint zerofiers $Z_j^B$ for $j=1,\dots,m$..

#### Derived values
Both prover and verifier compute the following.

- The interpolation domain: the vector $D_S=(1, g, \dots, g^{2^n-1})$.
- The Low Degree Extension $D_{\text{LDE}} =(h, h\omega, h\omega^2,\dots, h\omega^{2^{n+l} - 1})$. Recall $2^l$ is the blowup factor.
- Let $d_k^T := 2^n (\deg(P_k^T) - 1)$ and let $d^B := 2^n$. Let $d := 2^{n + 1}$. Notice that $d^B \leq d$ and $d_k^T \leq d$ for all $k$. This holds because we assume all transition constraint polynomials are at most cubic.

## Randomized AIR with Preprocessing (RAP)

This the process in which the prover uses randomness from the verifier to complete the program trace with additional columns. This is specific to each RAP. See [here](https://hackmd.io/@aztec-network/plonk-arithmetiization-air) for more details.

## Vector commitment scheme

Given a vector $A=(y_0, \dots, y_L)$. The operation $\text{Commit}(A)$ returns the root $r$ of the Merkle tree that has the hash of the elements of $A$ as leaves.

For $i\in[0,2^{n+k})$, the operation $\text{open}(A, i)$ returns $y_i$ and the authentication path $s$ to the Merkle tree root.

The operation $\text{Verify}(i,y,r,s)$ returns _Accept_ or _Reject_ depending on whether the $i$-th element of $A$ is $y$. It checks whether the authentication path $s$ is compatible with $i$, $y$ and the Merkle tree root $r$.


In our cases the sets $A$ will be of the form $A=(f(a), f(ab), f(ab^2), \dots, f(ab^L))$ for some elements $a,b\in\mathbb{F}$. It will be convenient to use the following abuse of notation. We will write $\text{Open}(A, ab^i)$ to mean $\text{Open}(A, i)$. Similarly, we will write $\text{Verify}(ab^i, y, r, s)$ instead of $\text{Verify}(i, y, r, s)$. Note that this is only notation and $\text{Verify}(ab^i, y, r, s)$ is only checking that the $y$ is the $i$-th element of the commited vector. 

## Transcript

The Fiat-Shamir heuristic is used to make the protocol noninteractive. We assume there is a transcript object to which values can be added and from which challenges can be sampled.

## Protocol

### Prover

#### Round 0: Transcript initialization

- Start a new transcript.
- (Strong Fiat Shamir) Add to it all the public values.

#### Round 1: Build RAP

##### Round 1.1: Interpolate main trace

- For each column $M_j$ of the execution trace matrix $T$, interpolate its values at the domain $D_S$ and obtain polynomials $t_j$ such that $t_j(g^i)=M_{i,j}$.
- Compute $[t_j] := \text{Commit}(t_j(D_{\text{LED}}))$ for all $j=1,\dots,m'$.
- Add $[t_j]$ to the transcript in increasing order.

##### Round 1.2: Commit extended trace

- Sample random values $a_1,\dots,a_l$ in $\mathbb{F}$ from the transcript.
- Use $a_1,\dots,a_l$ to build $M_{\text{RAP2}}\in\mathbb{F}^{2^n\times m''}$ following the specifications of the RAP process.
- For each column $\hat M_j$ of the matrix $M_{\text{RAP2}}$, interpolate its values at the domain $D_S$ and obtain polynomials $t_{m'+1}, \dots, t_{m' + m''}$ such that $t_j(g^i)=\hat M_{i,j}$.
- Compute $[t_j] := \text{Commit}(t_j(D_{\text{LED}}))$ for all $j=m'+1,\dots,m'+m''$.
- Add $[t_j]$ to the transcript in increasing order for all $j=m'+1,\dots,m'+m''$.

#### Round 2: Compute composition polynomial

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

#### Round 3: Evaluate polynomials in out of domain element

- Sample from the transcript until obtaining $z\in\mathbb{F}\setminus D_{\text{LDE}}$.
- Compute $H_1(z^2)$, $H_2(z^2)$, and $t_j(z)$ and $t_j(gz)$ for all $j$.
- Add $H_1(z^2)$, $H_2(z^2)$, and $t_j(z)$ and $t_j(gz)$ for all $j$ to the transcript.

#### Round 4: Compute and run FRI on the Deep composition polynomial

- Sample $\gamma$, $\gamma'$, and $\gamma_1,\dots,\gamma_m$, $\gamma_1',\dots,\gamma_m'$ in $\mathbb{F}$ from the transcript.
- Compute $p_0$ as $$\gamma\frac{H_1 - H_1(z^2)}{X - z^2} + \gamma'\frac{H_2 - H_2(z^2)}{X - z^2} + \sum_j \gamma_j\frac{t_j - t_j(z)}{X - z} + \gamma_j'\frac{t_j - t_j(gz)}{X - gz}$$

##### Round 4.1.k: FRI commit phase

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

##### Round 4.2: FRI query phase

- For $s=0,\dots,Q-1$ do the following:
  - Sample random index $\iota_s \in [0, 2^{n+l}]$ from the transcript and let $\upsilon_s := \omega^{\iota_s}$.
  - Compute $\text{Open}(p_0(D_0), \upsilon_s)$.
  - Compute $\text{Open}(p_k(D_k), -\upsilon_s^{2^k})$ for all $k=0,\dots,n-1$.

##### Round 4.3: Open deep composition polynomial components

- Compute $\text{Open}(H_1(D_{\text{LDE}}), \upsilon_0)$, $\text{Open}(H_2(D_{\text{LDE}}), \upsilon_0)$.
- Compute $\text{Open}(t_j(D_{\text{LDE}}), \upsilon_0)$ for all $j=1,\dots, m$.

#### Build proof

- Send the proof to the verifier:
  $$
  \begin{align}
  \Pi = ( &\\
  &\{[t_j], t_j(z), t_j(gz): 0\leq j < m\}, \\
  &[H_1], H_1(z^2),[H_2], H_2(z^2), \\
  &\{[p_k]: 0\leq k < n\}, \\
  &p_n, \\
  &\{\text{Open}(p_0(D_0), \upsilon_s): 0\leq s < Q\}), \\
  &\{\text{Open}(p_k(D_k), -\upsilon_s^{2^k}): 0\leq k< n, 0\leq s < Q\}, \\
  &\text{Open}(H_1(D_{\text{LDE}}), \upsilon_0), \\
  &\text{Open}(H_2(D_{\text{LDE}}), \upsilon_0), \\
  &\{\text{Open}(t_j(D_{\text{LDE}}), \upsilon_0): 0 \leq j< m\}, \\
  ) &
  \end{align}
  $$

### Verifier

#### Notation

- Bold capital letters refer to commitments. For example $\mathbf{H}_1$ is the claimed commitment $[H_1]$.
- Greek letters with superscripts refer to claimed function evaluations. For example $\tau_j^z$ is the claimed evaluation $t_j(z)$.
- Gothic letters refer to authentication paths (e.g. $\mathfrak{H}_1$ is the authentication path of the opening of $H_1$).

#### Input

$$
\begin{align}
\Pi = ( &\\
&\{\mathbf{T}_j, \tau_j^z, \tau_j^{gz}: 0\leq j < m\}, \\
&\mathbf{H}_1, \eta_1^{z^2},\mathbf{H}_2, \eta_2^{z^2}, \\
&\{\mathbf{P}_k: 0\leq k < n\}, \\
&\pi, \\
&\{(\pi_0^{\upsilon_s}, \mathfrak{P}_0): 0\leq s < Q\}, \\
&\{(\pi_k^{-\upsilon_s^{2^k}}, \mathfrak{P}_k): 0\leq k< n, 0\leq s < Q\}, \\
&(\eta_1^{\upsilon_0}, \mathfrak{H}_1)\\
&(\eta_2^{\upsilon_0}, \mathfrak{H}_2)\\
&\{(\tau_j^{\upsilon_0}, \mathfrak{T}_j): 0 \leq j< m\}, \\
) &
\end{align}
$$

#### Step 1: Replay interactions and recover challenges

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
- For $s=0, \dots, Q-1$:
  -- Sample random index $\iota_s \in [0, 2^{n+l}]$ from the transcript and let $\upsilon_s := \omega^{\iota_s}$.

#### Step 2: Verify claimed composition polynomial

- Compute $h := \eta_1^{z^2} + z \eta_2^{z^2}$
- Compute $b_j := \frac{\tau_j^z - P^B_j(z)}{Z_j^B(z)}$
- Compute $c_k := \frac{P^T_k(\tau_1^z, \dots, \tau_m^z, \tau_1^{gz}, \dots, \tau_m^{gz})}{Z_k^T(z)}$
- Verify
  $$h = \sum_{k} (\alpha_k^T z^{d - d_k^T} + \beta_k^T)c_k + \sum_j (\alpha_j^B z^{d - d^B}+\beta_j^B)b_j$$

#### Step 3: Verify FRI

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

#### Step 4: Verify deep composition polynomial is FRI first layer

- Check that the following are all _Accept_:
  - $\text{Verify}((\upsilon_0, \eta_1^{\upsilon_0}), \mathbf{H}_1, \mathfrak{h}_1)$.
  - $\text{Verify}((\upsilon_0, \eta_2^{\upsilon_0}), \mathbf{H}_2, \mathfrak{h}_2)$.
  - $\text{Verify}((\upsilon_0, \tau_j^{\upsilon_0}), \mathbf{T}_j, \mathfrak{T}_j)$ for all $0\leq j < m$.
- Check that $\pi_0^{\upsilon_0}$ is equal to the following:

$$
\gamma\frac{\eta_1^{\upsilon_0} - \eta_1^{z^2}}{\upsilon_0 - z^2} + \gamma'\frac{\eta_2^{\upsilon_0} - \eta_2^{z^2}}{\upsilon_0 - z^2} + \sum_j \gamma_j\frac{\tau_j^{\upsilon_0} - \tau_j^{z}}{\upsilon_0 - z} + \gamma_j'\frac{\tau_j^{\upsilon_0} - \tau_j^{gz}}{\upsilon_0 - gz}
$$

# Cairo's RAP
The execution of a Cairo program produces a memory vector $V$ and a matrix $M$ of size $L \times 3$ with the evolution of the three registers `pc`, `ap`, `fp`. All of them with entries in $\mathbb{F}$.

## Construction of execution trace $T$:
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
## Extended columns:

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

# Other

## Notes on Cairo Public Inputs
The verifier and the prover share common information.

An example of this is the **public memory**, which essentially represents the initial state of the virtual machine. The memory at the initial state stores important information such as the instructions of the program. This is public because the verifier needs to check what program was executed. The rest of the memory will only be known to the prover, and the verifier will check that is a valid extention of the initial state, following the specification of the Cairo VM.

Other examples of shared information are the parameters **rc_min** and **rc_max**. These are not known before executing the program, so they are not chosen by the verifier, but will be attached to the proof. These parameters describe the minimum and maximum memory address used by the prover in the virtual machine.

One of the initial steps of the verifier is to validate this shared information.

[1] https://eprint.iacr.org/2021/1063.pdf

## Notes on Optimizations

- Divisions: One of the most computationally intensive operations performed is division. These divisions can be optimized by utilizing [Fast Fourier Transform](http://web.cecs.pdx.edu/~maier/cs584/Lectures/lect07b-11-MG.pdf) (FFT) to divide each field element in Lagrange form. In specific scenarios, such as dividing by a polynomial of the form (x-a), the Ruffini algorithm can be employed to further enhance performance.

- Commitments: Another resource-intensive operation involves commitments of polynomials. In the context of STARKs, this is accomplished by computing multiple Merkle trees, each corresponding to a different function. A key optimization arises when several function commitments $f_1, f_2, \dots, f_n$ need to be opened at the same location $\gamma$. In such scenarios, the leaf nodes of the Merkle tree can be set as the hash of the tuple $(f_1(i), f_2(i), \dots, f_n(i))$, allowing for a consolidated Merkle tree operation.``
