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
