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

# Polynomial commitment scheme
A commitment scheme consists of two parts: a commit phase and an open phase. STARK uses a univariate polynomial commitment scheme which internally uses a combination of a vector commitment scheme and a protocol called FRI. Let's begin with this two components and the see how they build up the polynomial commitment scheme.

## Vector commitments
Given a vector $Y = (y_0, \dots, y_M)$, commiting to $Y$ means the following. The prover builds a Merkle tree out of it and sends the root of the tree to the verifier. The verifier can then ask the prover to reveal, or *open*, the value of the vector $Y$ at some index $i$. The prover won't have any choice other than to send the correct value. This is because the verifier will expect not only the corresponding value $y_i$, but also the authentication path to the root of the tree to check its authenticity. The authentication path encodes also the position $i$ and the length $M$ of the vector.

In STARKs, all commited vectors are of the form $Y = (p(d_1), \dots, p(d_M))$ for some polynomial $p$ and some domain fixed domain $D = (d_1, \dots, d_M)$ known to the prover and the verifier.

## FRI
The FRI protocol is a tool to prove that the commitment of a vector $(p(d_1), \dots, p(d_M))$ corresponds to the evaluations of a polynomial of a certain degree.

TODO: Complete.

## Polynomial commitments
Like most of the proving systems, STARK uses a univariate polynomial commitment scheme. This is what is expected from the **commit** and **open** phases.
- *Commit*: given a polynomial $p$, the prover produces a sort of hash of it. We denote it here by $[p]$ and is called the *commitment* of $p$. This hash is unique to $p$. The prover usually sends $[p]$ to the verifier.
- *Open*: this is an interactive protocol between the prover and the verifier. The prover holds the polynomial $p$. The verifier only holds the commitment $[p]$. The verifier sends a value $z$ to the prover at which he wants to know the value $y=p(z)$. The prover sends a value $y$ to the verifier and then they engage in the *Open* protocol. As a result of this, the verifier gets convinced that the polynomial that corresponds to the hash $[p]$ evaluates to $y$ at $z$.

Let's see how both of these phases work in detail. Two configuration parameters are needed: 
- a power of two $N=2^n$
- some vector $D=(d_1,\dots,d_M)$ with $d_i$ elements of $F$ for all $i$ and $d_i\neq d_j$ for all $i\neq j$.
In what follows all polynomials will be of degree at most $N-1$. The commitment scheme will only work for polynomials satisfying that degree bound.

### Commit
Given a polynomial $p$, the commitment $[p]$ is just the commitment of the vector $(p(d_1), \dots, p(d_M))$. That is, $[p]$ is the root of the Merkle tree of the vector of evaluations of $p$ at $D$.

### Open
This is an interactive protocol. So assume there is a prover and a verifier. The prover holds the polynomial $p$ and the verifier only the commitment $[p]$ of it. There is also an element $z$. The prover evaluates $p(z)$ and sends the result to the verifiers. The goal as we mentioned is to generate a proof of the validity the evaluation. Let us denote $y := p(z)$. This is a value now both the prover and verifier have.

Since $p(z) = y$, the polynomial $p$ can be written as $p = y + (x - z) q$ for some polynomial $q$. The prover computes the commitment $[q]$ and sends it to the verifier. Now they engage in a FRI protocol for polynomials of degree at most $N-1$, which convinces the verifier that $[q]$ is the commitment of a polynomial of degree at most $N-1$. 

From the point of view of the verifier. The commitments $[p]$ and $[q]$ are still potentially unrelated. Next there is a check to ensure that $[q]$ was actually computed properly from $p$. To do this the verifier challenges the prover to open $[p]$ and $[q]$ as a vectors. Meaning they use the open phase of the vector commitment scheme to reveal the values $p(d_i)$ and $q(d_i)$ for some random point $d_i \in D$ chosen by the verifier. Next he checks that $p(d_i) = y + (d_i - z) q(d_i) $. They repeat this last part a bunch of times and, as we'll analyze in the next section, this whole thing will convince the verifier that $p = y + (x -z) q$ as polynomials with overwhelming probability. From this equality the verifier deduces that $p(z) = y$.

### Soundness
Let's analyze why the open protocol just described actually convinces the verifier that $p = (x - z) q$.

Keep in mind is that the prover always has to provide a commitment $[q]$ of degree at most $N-1$ that satisfies $p(d_i) = (d_i - z) q(d_i)$ for the chosen values of the verifier. That's the goal. An important but subtle part of the soundness is that $D$ is a vector of length $M>N$. To see why let's see what happens if $N = M$.

#### Case $M=N$
Suppose the prover is trying to cheat the verifier by sending a value $y$ different from $p(z)$. This means that $p - y$ is not divisible by $x-z$ as polynomials. But as long as $z$ is not in $D$ the prover can interpolate the values $$\frac{p(d_1) - y}{d_1 - z}, \dots, \frac{p(d_N) - y}{d_N - z},$$
at $D$ and obtain some polynomial $q$ of degree at most $N-1$. This polynomial satisfies $p(d_i) = y + (d_i - z) q(d_i)$ for all $d_i \in D$, but the equality of polynomials $p = y + (x - z) q$ does not hold. Mainly because that would imply that $p(z) = y$ and we are assuming the opposite case. Nevertheless, if they continue with the Open phase, FRI will pass since $q$ is truly a polynomial of degree at most $N-1$. All subsequent point checks will also pass since $q$ was crafted specially for that. 

So how can it be that $p$ is different from $y + (x - z) q$ but has the property that $p(d_i) = y + (d_i - z) q(d_i)$ for all $d_i \in D$? The only way for that to happen is that $q$ is of degree exactly $N-1$, so that $y + (x - z) q$ is of degree exactly $N+1$. Then, since $p$ is of degree at most $N-1$, the difference $f := y + (x-z) q - p$ is again of degree exactly $N$. The polynomial $f$ will be the polynomial zero if and only if we can prove that $f(d) = 0$ for $N+1$ points. But the construction of $q$ only shows that $f(d_i) = 0$ for all $d_i \in D$, which is a set of $N$ points. One extra point and the equality would hold. Of course that point doesn't exist, again because that would imply that $p(z) = y$, which we assume not to hold. The moral here is that checking $N+1$ points would be enough for the verifier to get convinced. And that's the spirit of the general case.

#### Case $M=2N$
Let's see one more example where we double de size of $D$ but keep the same bound for the degree of the polynomials. So polynomials are of degree at most $N-1$ and $D$ is of length $M = 2N$.

Again let's assume the prover wants to cheat the verifier in the same way and claims that $y$ is $p(z)$ but actually $y \neq p(z)$. Inevitably, for the Open protocol to succeed, the prover has to send a commitment $[q]$ of some polynomial of degree at most $N-1$. The strategy of the prover is pretty much constrained to be the same. But now he can't interpolate $q$ as before in every element of $D$, because otherwise that would produce a polynomial of degree at most $2N-1$. This most likely won't pass the FRI check.

Alternatively, he can choose some subset of $D' \subset D$ of size $N$ and interpolate only there to get a polynomial $q$ of degree at most $N-1$. That's going to succeed in the FRI phase, but what happens with the point checks? If the verifier chooses a challenge $d_i$ that belongs to $D'$, the check will pass. If $d_i \notin D'$, then the check will inevitably fail. This is because, as we saw in the previous case, one extra successful point to the already $N$ points where $q$ was interpolated was enough to prove that $p(z) = y$, which we assume now does not hold. This means, if $d_i \notin D'$, then $p(d_i)$ does not coincide with $y + (d_i - z) q(d_i)$ and the point check fails. So if the verifier chooses the challenges following a uniform distribution, then the chances of the prover of being caught are $1/2$ for only one challenge. If the verifier performs $k$ challenges, then the chance of not being caught is $1/2^{k}$.

#### General case: the blowup factor
If the ratio between $M$ and $N$ is $2$, then $k$ challenges give $1/2^{k}$ of probability of a malicious prover to succeed. If the ratio is $4$, that is, if $M = 4N$, then that probability is $1/4^k$ for the same number of point checks. This provides another way of improving the soundness error. The larger the ratio, the harder is to cheat in the open protocol. This ratio is what's called *the blowup factor*. It is a security parameter and finding a balance between the number of challenges $k$ and the size of $D$ is part of the configuartion of the protocol. Increasing the size of $D$ makes commiting an expensive operation since it involves building a Merkle tree with for a vector of the size of $D$. But increasing the number of challenges makes the size of the final proof larger.

## Batch
Most protocols commit and open polynomials several times. Doing these operations for each polynomial independently is costly. In this section we'll see how batching polynomials can reduce the amount of computation. Instead of working with a single polynomial $p$, we will commit or open a batch of polynomials $P=\{p_1, \dots, p_n\}$. We note the batch commitment as $[P]$.

As mentioned earlier, to commit a single polynomial $p$ we choose a domain $D$ and construct a Merkle tree over the vector $(p(d_1), \dots, p(d_m))$. When committing a batch of polynomials, the leaves of the Merkle tree instead contain the concatenation of the polynomial evaluations, that is $(p_1(d_1)||\dots||p_n(d_1), \dots, p_1(d_m)||\dots||p_n(d_m))$. The commitment $[P]$ is the root of this Merkle tree. This reduces the proof size: we only need one Merkle tree for $n$ polynomials. It also reduces the computational time. By traversing the Merkle tree one time, it can verify several commits.

The open operation proceeds similarly to the case of a single polynomial. The prover will try to convince the verifier that the committed polynomials $P$ at $z$ evaluate to some values. In the "batch" case the prover will construct the following polynomial:

$$
H(x)=\sum_{i=1}^{N}\gamma_i\frac{p_i(x)-p_i(z)}{x-z}
$$

Where $\gamma_i$ are challenges provided by the verifier. Let's see how this polynomial helps to convince the verifier. The prover should provided $n$ values that should be $y_i=p_i(z)$. For a malicious prover of course, that may not be the case. However, the prover and the verifier will engage in the FRI protocol over polynomial $[H]$. This will convince the verifier that $H$ is, in fact, a polynomial degree at most $N$, as seen in the soundness section. Later, with the help of the commitment $[P]$, the verifier will reconstruct the polynomial $H$ evaluated at some random challenge $\upsilon$ and will check that, in fact, $H$ and the committed polynomials $p_i$ are, in fact, related. As the prover is not lying about $H$ being a polynomial, the verifier concludes that $y_i=p_i(z)$, because $(x-z)$ divides $(p_i(x)-y_i)$ for each polynomial $p_i$. 

Note that this optimization makes a huge difference, as we only need to run the FRI protocol once instead of running it one time for each polynomial.

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
The verifier needs to check that $H$ was constructed according the the rules of the protocol. That is, $H$ has to be a linear combination of all the functions $\frac{Q_k^T}{X^{2^n}-1}$ and the similar terms for the boundary constraints. To do so, in **round 3** the verifier chooses a random point $z\in\mathbb{F}$ and the prover computes $H(z)$, $t_j(z)$ and $t_j(g z)$ for all $j$. With all these the verifier can check that $H$ and the expected linear combination coincide at least when evaluated at $z$. Since $z$ was chosen at random, this proves with overwhelming probability that $H$ was properly constructed.

The problem with this is that the verifier still needs to check that the evaluations $H(z)$, $t_j(z)$ and $t_j(g z)$ were properly computed and correspond to the already commited functions. And after that, the problem of checking that $H$ is a polynomial still remains. All of this is achieved at the same time in the next round

## Round 4
This round makes an extensive use of the FRI protocol. This protocol is run to prove that a vector of evaluations is actually the vector of evaluations of a polynomial of at most a predefined degree. The two remaining checks will be validated using this. That is, that the evaluations at $z$ were properly computed and that all of the commited functions are polynomials of bounded degree.

Suppose $f$ is any of the functions involved here. Either $H$, or $t_j$, or the shifts of the $t_j$. The prover has already commited to $f$ and gave the verifier also a value $y$ (at which supposedly $f(z) = y$). Further suppose the prover wants to convince the verifier that $f$ is a polynomial and that actually $f(z) = y$. Both of these are checked by running the FRI protocol over the function $$g(x) := \frac{f(x) - y}{x - z}.$$
This is because if $g$ is a polynomial, then $f(x) = y + g(x) (x - z)$, which is then also a polynomial and evaluating that expression at $z$ we get $f(z) = y$.

The prover and the verifier could engage in a FRI protocol for $f=H$, then again for $f=t_0$ and so on for $f=t_j$ for all $j$. But this is terribly inefficient. The random linear combination trick also can be used here to reduce this to a single FRI protocol for all of them. That random linear combination is the deep composition polynomial.

# FAQ

## Why use roots of unity?

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

## What is a primitive root of unity?

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

## Why use Cosets?

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

Note that, because $w^2 = g$, some of the elements on this set (actually, half of them) are powers of $g$. If while doing `FRI` we evalaute `H` on them, the zerofier could vanish and we'd be dividing by zero. We introduce the offset to make sure this can't happen.

NOTE: a careful reader might note that we can actually evaluate `H` on the elements $g^i$, since on a valid trace the zerofiers will actually divide the polynomials on their numerator. The problem still remains, however, because of performance. We don't want to do polynomial division if we don't need to, it's much cheaper to just evaluate numerator and denominator and then divide. Of course, this only works if the denominator doesn't vanish; hence, cosets.

----------

TODO:
- What's the ce blowup factor?
- What's the out of domain frame?
