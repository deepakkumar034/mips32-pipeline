module control_unit(
    
    input  [5:0] opcode,
    input  [5:0] funct,
    input  equalD, 
    output regwrite, 
    output memtoreg, 
    output memwrite,
    output branch, 
    output pcsrc, 
    output jump, 
    output alusrc, 
    output regdst, 
    output [3:0] alucontrol
);

    wire [1:0] aluop;

    maindec maindec(
        .opcode(opcode),
        .regwrite(regwrite), 
        .memtoreg(memtoreg), 
        .memwrite(memwrite), 
        .branch(branch), 
        .jump(jump), 
        .alusrc(alusrc), 
        .regdst(regdst),
        .aluop(aluop) 
    );

    aludec aludec(
        .aluop(aluop),
        .funct(funct),
        .alucontrol(alucontrol)
    );

   
    assign pcsrc = branch & (equalD ^ opcode[0]);         // beq + bne 

endmodule