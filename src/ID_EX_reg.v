module ID_EX_reg(
    input clk, 
    input reset,
    
    input      regwriteD, memtoregD, memwriteD, alusrcD, regdstD, input [3:0] alucontrolD,
    output reg regwriteE, memtoregE, memwriteE, alusrcE, regdstE, output reg[3:0] alucontrolE,
    
    input      [31:0] rd1D, rd2D,
    output reg [31:0] rd1E, rd2E,

    input      [4:0] rsD, rtD, rdD,
    output reg [4:0] rsE, rtE, rdE,

    input      [31:0] signimmD,
    output reg [31:0] signimmE,

    input flushE
);

    always @(posedge clk) begin

        if(reset) begin
            {regwriteE, memtoregE, memwriteE, alusrcE, regdstE} <= 5'b0;
            alucontrolE <= 4'b0;
            rd1E <= 32'b0; rd2E <= 32'b0;
            rsE <= 5'b0; rtE <= 5'b0; rdE <= 5'b0;
            signimmE <= 32'b0;
        end

        else if (flushE) begin
            {regwriteE, memtoregE, memwriteE, alusrcE, regdstE} <= 5'b0;
            alucontrolE <= 4'b0;
            rd1E <= 32'b0; rd2E <= 32'b0;
            rsE <= 5'b0; rtE <= 5'b0; rdE <= 5'b0;
            signimmE <= 32'b0;
        end

        else begin
            regwriteE <= regwriteD; memtoregE <= memtoregD; memwriteE <= memwriteD; alusrcE <= alusrcD; regdstE <= regdstD;
            alucontrolE <= alucontrolD;
            rd1E <= rd1D; rd2E <= rd2D;
            rsE <= rsD; rtE <= rtD; rdE <= rdD;
            signimmE <= signimmD;

        end
    end
endmodule