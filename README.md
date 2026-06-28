# mips32-pipeline
32-bit MIPS processor in Verilog featuring a 5-stage pipeline, forwarding unit, hazard detection, branch handling, and memory interface.

<img width="1280" height="771" alt="image" src="https://github.com/user-attachments/assets/eb54e2f1-9046-43ae-a196-7d560b79b114" />

## Pipeline Stages

The processor is divided into the following stages:
* Instruction Fetch (IF)        : PC update, instruction fetch
* Instruction Decode (ID)       : Register read, control decode, branch resolve
* Execute (EX)                  : ALU operation, forwarding muxes
* Memory Access (MEM)           : Data memory read/write
* Write Back (WB)               : Result mux, register writeback

## Features
* Full forwarding — EX→EX and MEM→EX data forwarding
* Load-use hazard detection — 1-cycle stall with bubble insertion
* Branch resolved in Decode — early comparator (equalD), 1-cycle penalty
* beq and bne — unified using opcode[0] XOR trick
* Jump (j) — target computed in Decode, 1-cycle flush
* Branch forwarding — MEM→Decode comparator (forwardAD, forwardBD)

