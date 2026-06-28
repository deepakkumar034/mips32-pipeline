module fetch_stage(
    input clk,
    input reset,
    input stallF,

    input pcsrcD,
    input jumpD,

    input [31:0] pcbranchD,
    input [31:0] jumpaddrD,

    output reg [31:0] pcF,
    output [31:0] pcplus4F,
    output [31:0] instrF
);

    wire [31:0] pcnextbr;
    wire [31:0] pcnext;

    mux2 #(32) branchmux(pcplus4F, pcbranchD, pcsrcD, pcnextbr);

    mux2 #(32) jumpmux(pcnextbr, jumpaddrD, jumpD, pcnext);

    adder add(pcF, 32'd4, pcplus4F);

    always @(posedge clk) begin
        
        if(reset) begin
            pcF <= 32'b0;
        end
        
        else if(!stallF)begin
            pcF <= pcnext;
        end
    end

    instruction_mem imem(pcF, instrF);

endmodule
