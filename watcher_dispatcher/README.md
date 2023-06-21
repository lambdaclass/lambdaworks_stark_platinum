# Watcher - Dispatcher

## Description

This is the watcher - dispatcher service for the proving system.

The architecture consists of a watcher thats monitors the blockchain for new transactions and a dispatcher that sends these new transactions to the provers. It could be pluged to any blockchain that supports smart contracts.

The provers acts as workers and execute an instance of:
    - Cairo VM ([cairo-rs](https://github.com/lambdaclass/cairo-rs/)) to run the Cairo program and create the trace
    - The prover that creates the proof from that trace.

This new instances are created in paralell, and the goal is that the system can scale horizontally.
