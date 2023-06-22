# Watcher - Dispatcher

## Description

This is the watcher - dispatcher service for the proving system.

The architecture consists of a watcher thats monitors the blockchain for new transactions and a dispatcher that sends these new transactions to the provers. It could be pluged to any blockchain that supports smart contracts.

When the watcher finds a new transaction with a program, it first calls [cairo-rs](https://github.com/lambdaclass/cairo-rs/) to run the Cairo program and generate the trace. This trace is then sent to lambdaworks prover that creates the proof. The proof is then put in a later block in the blockchain.

At the beggining, this operations will be done sequentially. But in the future, the goal is to make them in parallel, scalling horizontally.

By running provers in parallel, throughput of the proving system will be as high as the throughput of the blockchain. However, there is a latency of the prover and the inclusion of the proofs in blocks.
