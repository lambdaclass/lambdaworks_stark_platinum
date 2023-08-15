# Cairo execution trace

## Raw materials
After the execution of a Cairo program in the Cairo VM, three files are generated that are
the core components for the construction of the execution trace, needed for the proving
system:

* **trace file**: Has the information of the state of the three Cairo VM registers `ap`, 
`fp` and `pc` at every cycle of the execution of the program. To reduce ambiguity in terms,
we should call these the *register states* of the Cairo VM, and leave the term *trace* to 
the final product that is passed to the prover in order to generate a proof.
* **memory file**: A file with the information of the VM's memory at the end of the program
run, after the memory has been relocated.
* **public inputs**: A file with all the information that must be publicly available to prover
and verifier, such as the total number of execution steps, public memory, used builtins and 
their respective addresses range in memory.

Next section will explain in detail how this elements are used to build the final execution
trace. 
 
## Construction details

The execution trace is built in two stages. In the first one, the information of the files 
described in the previous section is aggregated in order to build a main trace table.
In the second stage, there is an interaction with the verifier in order to add some extension
columns to the main trace.

### Main trace construction

The layout of the main execution trace is as follows:
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
Each letter from A to G represents some subsection of columns, and the number specifies how many
columns correspond to that subsection.

#### Cairo instructions 
It is important to have in mind the information that each executed Cairo instruction holds, since it
is a key component of the construction of the execution trace. For a detailed explanation of how the
building components of the instruction interact in order to change the VM state, refer to the Cairo
whitepaper, sections 4.4 and 4.5.

Structure of the 63-bit that form the first word of each instruction:
```
 ┌─────────────────────────────────────────────────────────────────────────┐
 │                     off_dst (biased representation)                     │
 ├─────────────────────────────────────────────────────────────────────────┤
 │                     off_op0 (biased representation)                     │
 ├─────────────────────────────────────────────────────────────────────────┤
 │                     off_op1 (biased representation)                     │
 ├─────┬─────┬───────┬───────┬───────────┬────────┬───────────────────┬────┤
 │ dst │ op0 │  op1  │  res  │    pc     │   ap   │      opcode       │ 0  │
 │ reg │ reg │  src  │ logic │  update   │ update │                   │    │
 ├─────┼─────┼───┬───┼───┬───┼───┬───┬───┼───┬────┼────┬────┬────┬────┼────┤
 │  0  │  1  │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 10 │ 11 │ 12 │ 13 │ 14 │ 15 │
 └─────┴─────┴───┴───┴───┴───┴───┴───┴───┴───┴────┴────┴────┴────┴────┴────┘
 ```

#### Columns
The construction of the following columns corresponds to a colloquial explanation of what is done in
the `build_cairo_execution_trace` function.

##### Section A - Flags
The flags section **A** corresponds to the 16 bits that represent the configuration of the `dst_reg`,
`op0_reg`, `op1_src`, `res_logic`, `pc_update`, `ap_update` and `opcode` flags, as well as the zero 
flag. So there is one column for each bit of the flags decomposition. 

##### Section C - Temporary memory pointers
The two columns in this section, as well as the `pc` column from section **D**, are the most trivial.
For each step of the register states, the corresponding values are added to the columns, which are 
pointers to some memory cell in the VM's memory. 

##### Section D - Memory addresses
As already mentioned, the first column of this section, `pc`, is trivially obtained from the register 
states for each cycle.  
Columns `dst_addr`, `op0_addr` and `op1_addr` from section **D** are addresses constructed from pointers
stored at `ap` or `fp` and their respective offsets `off_dst`, `off_op0` and `off_op1`. The exact way these
are computed depends on the particular values of the flags for each instruction.

##### Section E - Memory values 
The `inst` column, is obtained by fetching in memory the value stored at pointer `pc`, which 
corresponds to a 63 bit Cairo instruction.
Columns `dst`, `op0` and `op1` are computed by fetching in memory by their respective addresses.

##### Section F - Offsets/Range-checked values
These columns represent integer values that are used to construct addresses `dst_addr`, `op0_addr` and 
`op1_addr` and are decoded directly from the instruction. 
These values have the property to be numbers in the range from 0 to 2^16.

##### Section B - Res
This column is computed depending on the decoded `opcode` and `res_logic` of every instruction.
In some cases, `res` is unused in the instruction and the value for (`dst`)^(-1) is used in that
place as an optimization.

##### Section G - Derived
In order to have constraints of max degree two, some more columns are derived from the already calculated,
`t0`, `t1` and `mul`:
* `t0` is the product of the values of `dst` and the `PC_JNZ` flag for each step. 
* `t1` is the product of `t0` and `res` for each step.
* `mul` is the product of `op0` and `op1` for each step.
#### Range check and Memory holes

For the values constrained between ranges $0$ and $2^16$, the offsets, the prover uses a permutation argument to optimize enforcing this. In particular, it checks an ordered list with the offsets is the same as the original one, is continuous, the first value is $rc_{min}$, and the last one less than $rc_{max}$.

Since not all values are used, there may be unused values, and so the ordered offset may not be continuos. These unused values are called holes, and they need to be filled with the missing values, so the checks can be done.

This is explained on section 9.9 of the Cairo Paper

In the case of the memory, something similar happen, where the values should be continous, but if there are built-ins, this may not be the case. For example, the built-in may be using addresses in ranges higher than the ones used by the program. 

To fix this, holes in the memory cells are filled, just as the ones of the RC. Dummy memory accesses
#### Dummy memory accesses

As explained in section 9.8 of the Cairo paper, we need to prove that memory used extends the public memory. This public memory contains the bytecode that was executed, outputs, and other data.

The first is critical for the verifier to not only know that something was executed correctly, but to know what was executed.

To make this check, we needs to add dummy accesses on the memory cells with address 0 and value 0, which helps us prove it was used by changing the final value of the constraints that ensure that the memory is continuos and read only.
#### Trace extension / Padding

The last step is padding the trace to a power of two for efficiency. We may also need to pad the trace if for some reasons some unbalance given by the layout.

For this, we will copy the last executed instruction until reaching the desired length. 

But there's a trick. If the last executed instruction is any instruction, and it's copied, the transitiosn constraints won't be sattisfied. To be able to do this, we need to use something call "proof mode". In proof mode, the main function of the program is wrapped in another one, which calls it and returns to an infinite loop. This loop, is a jmp relative to 0.

Since this loop can be executed many times without changing the validity of the trace, it can be copied as many times as we want.
