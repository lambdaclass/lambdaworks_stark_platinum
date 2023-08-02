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
 