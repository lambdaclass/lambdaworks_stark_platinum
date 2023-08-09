# Layouts

In previous chapters we have seen how the memory registers states and the memory are augmented to generate a provable trace. 

While we have shown a way of doing that, there isn't only one posible provable trace. In fact, there are multiple configurations possible. 

For example, in the Cairo VM we have 15 flags. For example, we have "DstReg", "Op0Reg", "OpCode" and others. For simplification, let's imagine with hae 3 flags them with letters from "A" to "C", where "A" is the first flag. 

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

The only problem, is that now the constraints for the each row of the column is not the same. We will have to define then a concept called "Virtual Column"

Each row corresponding to Flag A will have the constraints associated with it's own Virtual Column, and the same will apply for Flag B and Flag C.

Now, to do this, we will need to evaluate the multiple rows taking in account they are part of the same step. To make things easier, we will add a dummy flag D, whose purpose is to make the evaluation move in a number which is a potency of 2. 

If we were evaluating the Frame where the constraints should give 0, the frame movement would look like this:

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

When generating the trace, we will evaluating over the points on the LDE, where the constraints wont' give 0, but we will use the same spacing. Assume we have three constraints for each flag, C0, C1, C2, and that they don't involve other trace cells. Let's call the index of the frame evaluation i, starting from 0.

In the first case, the constraint C0,C1 and C2 would be applied over the same rows, giving an equation that looks like:

$$ Ck(w^i, w^i+1) $$

In the second case, the equations would look like:

$$`C0(w^{i*4}, w^{i*4+1})`$$

$$`C1(w^{i*4+1}, w^{i*4+2})`$$

$$`C2(w^{i*4+2}, w^{i*4+3})`$$

