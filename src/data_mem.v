module data_mem(
    
    input  clk,
    input  we, 
    input  [31:0] a,
    input  [31:0] wd,
    output [31:0] rd
);

    reg [31:0] RAM [0:255];

    always @(posedge clk) begin

        if(we)
            RAM[a >> 2] <= wd;
    end
    
    assign rd = RAM[a >> 2];

endmodule