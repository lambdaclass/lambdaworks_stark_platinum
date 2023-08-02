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
described in the previous section is aggregated in order to build a main trace table or matrix.
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

The pointers (section **C**) and the column `pc` from section **D**, are the most trivial. For each 
step of the register states, the corresponding values are added to the columns, which are all pointers
to some memory cell in the VM memory. 
The `inst` column, is obtained by fetching in memory the value stored at pointer `pc`, which 
corresponds to a 63 bit Cairo instruction.

Pretty much all the other columns, with the exception of the derived (section **G**), are obtained from
the instruction decoding at each cycle of the program execution.

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

 The flags section (**A**) correspond to the 16 bit that represent the configuration of the `dst_reg`,
 `op0_reg`, `op1_src`, `res_logic`, `pc_update`, `ap_update` and `opcode` flags, and the zero flag. So
 we have one column for each bit of the flags decomposition. 

`dst_addr`, `op0_addr` and `op1_addr` are obtained from
