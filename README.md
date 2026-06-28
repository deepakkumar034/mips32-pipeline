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

The implementation supports standard instructions from the MIPS ISA, including:
```bash
- R-type (Register): add, sub, and, or, slt, xor, xnor — opcode + rs + rt + rd + shamt + funct
```
```bash
- I-type (Immediate): addi, lw, sw, slt, beq, bne — opcode + rs + rt + immediate
```
```bash
- J-type (Jump): j — opcode + address
```
## Features
```bash
* Full forwarding
The processor implements full data forwarding to minimize pipeline stalls caused by RAW (Read After Write) dependencies.

Supported forwarding paths:

EX/MEM → EX
MEM/WB → EX

Forwarding control signals: ForwardAE, ForwardBE

This allows dependent ALU instructions to execute without waiting for register write-back.
```
``` bash
* Load-use hazard detection
It cannot be resolved through forwarding alone because the loaded data becomes available after the MEM stage.

Example:

lw  $t0, 0($t1)
add $t2, $t0, $t3

The Hazard Detection Unit (HDU) automatically:

Stalls the PC and IF/ID register
Inserts a bubble into the EX stage
Introduces a 1-cycle stall

Control signals: stallF, stallD, flushE
```
``` bash
* Branch Handling
Branches are resolved in the Decode stage to reduce branch penalty.

Features:

Early branch comparator (equalD)
Branch target computation in Decode
1-cycle branch penalty

Supported instructions: beq, bne

A unified branch implementation is used through the opcode[0] XOR technique, allowing both instructions to share the same comparison hardware.
```
``` bash
* Jump Instruction : j

The processor supports the MIPS Jump (j) instruction.

Features:

Jump target generated in Decode stage
Immediate PC redirection
1-cycle flush penalty

When a jump is detected, incorrectly fetched instructions are flushed and execution continues from the target address.
```



