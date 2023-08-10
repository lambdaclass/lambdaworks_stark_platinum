# Protocol Overview

In this section we start diving a little bit deeper before showing the formal protocol. If you haven't done so, we recommend first reading the "Recap" section. As mentioned in that section, the trace is a table containing the state of the system at every step. In this section we will denote the trace as $T$. A trace can have several columns to store different aspects or features of a particular state at a particular moment. We will refer to the $j$-th column as $T_j$. You can think of a trace as a matrix $T$ where the entry $T_{ij}$ is the $j$-th element of the $i$-th state.

# Arithmetization
The main tool in most proving systems is that of polynomials over a finite field  $\mathbb{F}$. Each column $T_j$ of the trace $T$ will be interpreted as evaluations of such a polynomial $t_j$. A consequence of this is that any type of information about the states must be encoded somehow as an element in $\mathbb{F}$.

To ease notation we will assume here and in the protocol that the constraints encoding transition rules depend only on a state and the previous one. Everything can be easily generalized to transitions that depend on many preceeding states. Then, constraints can be expressed as multivariate polynomials in $2m$ variables
$$P_k^T(X_1, \dots, X_m, Y_1, \dots, Y_m)$$
A transition from state $i$ to state $i+1$ will be valid if and only if when we plug row $i$ of $T$ in the first $m$ variables and row $i+1$ in the second $m$ variables of $P_k^T$ we get $0$ for all $k$. In mathematical notation, this is
$$P_k^T(T_{i, 0}, \dots, T_{i, m}, T_{i+1, 0}, \dots, T_{i+1, m}) = 0 \text{    for all }k$$

These are called *transition constraints* and they check local properties of the trace, where local means relative to a specific row. There is another type of constraint, called *boundary constraint* and denoted $P_j^B$. These enforce parts of the trace to take particular values. It is useful for example to verify the initial states.

So far, these constraints can only express local properties of the trace. There are situations where global properties of the trace need to be checked for consistency. For example a column may need to take all values in a range but not in any predefined way. There are several methods to express these global properties as local by adding redundant columns. Usually they need to involve randomness from the verifier to make sense and they turn into an interactive protocol on their own called *Randomized AIR with Preprocessing*.

# Commitments
In STARKs the prover *commits* to several vectors. Specifically, given a vector $Y = (y_0, \dots, y_L)$, commiting to $Y$ means the following. The prover builds a Merkle tree out of it and sends the root of the tree to the verifier. The verifier can then ask the prover to reveal, or *open*, the value of the vector $Y$ at some index $i$. The prover won't have any choice other than to send the correct value. This is because the verifier will expect not only the corresponding value $y_i$, but also the authentication path to the root of the tree to check its authenticity. The authentication path encodes also the position $i$ and the length $L$ of the vector, which we always assume it's a power of $2$.

## Polynomial commitments
In STARKs, all commited vectors are of the form $Y = (f(d_1), \dots, f(d_L))$ for some polynomial $f$ and some domain fixed domain $D = (d_1, \dots, d_L)$ known to the prover and the verifier. But here's the catch. If $L$ is less than the number of points in the finite field $\mathbb{F}$, any vector $Y = (y_1, \dots, y_L)$ is the vector of evaluations at $D$ of some polynomial $f$ of degree at most $L$. In other words, for any $Y = (y_1, \dots, y_L)$ there is a polynomial $f$ such that $f(d_i) = y_i$. This follows from Lagrange interpolation. So vector commitments and univariate polynomial commitments are pretty much the same thing.

## FRI
The FRI protocol is a tool to prove that a commitment corresponds to a polynomial of a certain degree. This is run at the end of the STARKs protocol. So during the first interactions the verifier receives a bunch of vector commitments and only at the very end he will be convinced that these vectors are actually evaluations at $D$ of polynomials of low degree.

# High level description of the protocol
The protocol is split into rounds. Each round more or less represents an interaction with the verifier. This means that each round will generally start by getting a challenge from the verifier. 

The prover will need to interpolate polynomials and he will always do it over the set $D_S = \{g^i \}_{i=0}^{2^n-1} \subseteq \mathbb{F}$ with $g$ is a $2^n$ root of unity in $\mathbb{F}$. Also, most commitments will be done over the set $D_{LDE} = (h, h \omega, h \omega^2, \dots, h \omega^{2^{n + l}})$ where $\omega$ is a $2^{n + l}$ root of unity.

## Round 1
In **round 1**, the prover commits to the columns of the trace $T$. He does so by interpolating each column $j$ and obtaining univariate polynomials $t_j$.
Then the prover commits to $t_j$ over $D_{LDE}$. In this way, we have $T_{i,j}=t_j(g^i)$.
From now on, the prover won't be able to change the values of the trace $T$. The verifier will leverage this and send challenges to the prover. The prover cannot know in advance what these challenges will be, thus he cannot handcraft a trace to deceive the verifier.

As mentioned before, if some constraints cannot be expressed locally, more columns can be added with the goal of making a constraint-friendly trace. This is done by first committing to the first set of columns, then sampling challenges from the verifier and repeating round 1. The sampling of challenges serves to add new constraints. These constraints will make sure the new columns have some common structure with the original trace. In the protocol this is extended columns are referred to as the *RAP2* (Randomized AIR with Preprocessing). The matrix of the extended columns is denoted $M_{\text{RAP2}}$.

## Round 2
The goal of **round 2** is to build the composition polynomial $H$. This function will have the property that it is a polynomial if and only if the trace that the prover committed to at **round 1** is valid and satisfies the agreed polynomial constraints. That is, $H$ will be a polynomial if and only if $T$ is a trace that satisfies all the transition and boundary constraints.

Note that we can compose the polynomials $t_j$, the ones that interpolate the columns of the trace $T$, with the multivariate constraint polynomials as follows.
$$Q_k^T(x) = P_k^T(t_1(x), \dots, t_m(x), t_1(g x), \dots, t_m(\omega x))$$
These result in univariate polynomials. And the same can be done for the boundary constraints. Since $T_{i,j} = t_j(g^i)$, we have that these univariate polynomials vanish at every element of $D$ if and only if the trace $T$ is valid.

As we already mentioned, this is assuming that transitions only depend on the current and previous state. But it can be generalized to include *frames* with three or more rows or more context for each constraint. For example, in the Fibonacci case the most natural way is to encode it as one transition constraint that depend on a row and the two preceeding it as we already did in the Recap section. The STARK protocol checks whether the function $\frac{Q_k^T}{X^{2^n} - 1}$ is a polynomial instead of checking that the polynomial is zero over the domain $D =\{g_i\}_{i=0}^{2^n-1}$. The two statements are equivalent.

The verifier could check that all $\frac{Q_k^T}{X^{2^n} - 1}$ are polynomials one by one, and the same for the polynomials coming from the boundary constraints. But this is inefficient and the same can be obtained with a single polynomial. To do this, the prover samples challenges and obtains a random linear combination of these polynomials. The result of this is denoted by $H$ and is called the composition polynomial. It integrates all the constraints by adding them up. So after computing $H$, the prover commits to it and sends the commitment to the verifier. The rest of the protocol are efforts to prove that $H$ was properly constructed and that it is in fact a polynomial, which can only be true if the prover actually has a valid extension of the original trace.
## Round 3
The verifier needs to check that $H$ was constructed according the the rules of the protocol. That is, $H$ has to be a linaer combination of all the functions $\frac{Q_k^T}{X^{2^n}-1}$ and the similar terms for the boundary constraints. To do so, in **round 3** the verifier chooses a random point $z\in\mathbb{F}$ and the prover computes $H(z)$, $t_j(z)$ and $t_j(g z)$ for all $j$. With all these the verifier can check that $H$ and the expected linaer combination coincide at least when evaluated at $z$. Since $z$ was chosen at random, this proves with overwhelming probability that $H$ was properly constructed.

The problem with this is that the verifier still needs to check that the evaluations $H(z)$, $t_j(z)$ and $t_j(g z)$ were properly computed and correspond to the already commited functions. And after that, the problem of checking that $H$ is a polynomial still remains. All of this is achieved at the same time in the next round

## Round 4
This round makes an extensive use of the FRI protocol. This protocol is run to prove that a vector of evaluations is actually the vector of evaluations of a polynomial of at most a predefined degree. The two remaining checks will be validated using this. That is, that the evaluations at $z$ were properly computed and that all of the commited functions are polynomials of bounded degree.

Suppose $f$ is any of the functions involved here. Either $H$, or $t_j$, or the shifts of the $t_j$. The prover has already commited to $f$ and gave the verifier also a value $y$ (at which supposedly $f(z) = y$). Further suppose the prover wants to convince the verifier that $f$ is a polynomial and that actually $f(z) = y$. Both of these are checked by running the FRI protocol over the function $$g(x) := \frac{f(x) - y}{x - z}.$$
This is because if $g$ is a polynomial, then $f(x) = y + g(x) (x - z)$, which is then also a polynomial and evaluating that expression at $z$ we get $f(z) = y$.

The prover and the verifier could engage in a FRI protocol for $f=H$, then again for $f=t_0$ and so on for $f=t_j$ for all $j$. But this is terribly inefficient. The random linear combination trick also can be used here to reduce this to a single FRI protocol for all of them. That random linear combination is the deep composition polynomial.

