module maindec(
    
    input  [5:0] opcode,
    output regwrite, 
    output memtoreg, 
    output memwrite, 
    output branch, 
    output jump, 
    output alusrc, 
    output regdst, 
    output [1:0] aluop
);
    reg [8:0] controls;

    assign {regwrite, memtoreg, memwrite, branch, jump, alusrc, regdst, aluop} = controls;

    always @ (*) begin 
        case(opcode) 
            
            6'b000000: controls = 9'b1_0_0_0_0_0_1_10; // R-type
            6'b100011: controls = 9'b1_1_0_0_0_1_0_00; // lw
            6'b101011: controls = 9'b0_0_1_0_0_1_0_00; // sw
            6'b000100: controls = 9'b0_0_0_1_0_0_0_01; // beq
            6'b000101: controls = 9'b0_0_0_1_0_0_0_01; // bne
            6'b000010: controls = 9'b0_0_0_0_1_0_0_00; // j
            6'b001000: controls = 9'b1_0_0_0_0_1_0_00; // addi
            6'b001101: controls = 9'b1_0_0_0_0_1_0_11; // ori
            default:   controls = 9'bx_x_x_x_x_x_x_xx;
        endcase
    end

endmodule