module aludec(
    input [1:0] aluop,
    input [5:0] funct, 
    output reg [3:0] alucontrol
);

    always @(*) begin
        case (aluop)
            2'b00: alucontrol = 4'b0010; // add (lw/sw)
            2'b01: alucontrol = 4'b0110; // sub (beq/ bne)
            2'b10:  case (funct)
                        6'b100000: alucontrol = 4'b0010; // add
                        6'b100010: alucontrol = 4'b0110; // sub
                        6'b100100: alucontrol = 4'b0000; // and
                        6'b100101: alucontrol = 4'b0001; // or
                        6'b101010: alucontrol = 4'b0111; // slt
                        default:   alucontrol = 4'b0000;
                    endcase
            default: alucontrol = 4'b0000;
        endcase
    end
endmodule
