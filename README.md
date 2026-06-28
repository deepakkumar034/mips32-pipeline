# mips32-pipeline
32-bit MIPS processor in Verilog featuring a 5-stage pipeline, forwarding unit, hazard detection, branch handling, and memory interface.

<img width="1280" height="771" alt="image" src="https://github.com/user-attachments/assets/eb54e2f1-9046-43ae-a196-7d560b79b114" />

## 5-stage pipelined datapath

* Instruction Fetch (IF)        : PC update, instruction fetch
* Instruction Decode (ID)       : Register read, control decode, branch resolve
* Execute (EX)                  : ALU operation, forwarding muxes
* Memory Access (MEM)           : Data memory read/write
* Write Back (WB)               : Result mux, register writeback

IF/ID, ID/EX, EX/MEM, and MEM/WB pipeline registers

## Features
```bash
Full forwarding —  The processor implements full data forwarding to minimize pipeline stalls caused by RAW (Read After Write) dependencies.

Supported forwarding paths:

EX/MEM → EX
MEM/WB → EX

Forwarding control signals:

ForwardAE
ForwardBE

This allows dependent ALU instructions to execute without waiting for register write-back.
```
* Load-use hazard detection — 1-cycle stall with bubble insertion
* Branch resolved in Decode — early comparator (equalD), 1-cycle penalty
* beq and bne — unified using opcode[0] XOR trick
* Jump (j) — target computed in Decode, 1-cycle flush



