module instruction_mem (
    
    input  [31:0] a,
    output [31:0] instr
);

    reg [31:0] RAM [0:255];

    initial begin
        $readmemh("Machine_Code.txt",RAM); 
    end

    assign instr = RAM[a >> 2];

endmodule
