module EX_MEM_reg(

    input clk, reset, 
    input      regwriteE, memtoregE, memwriteE,
    output reg regwriteM, memtoregM, memwriteM, 
 

    input      [31:0] aluoutE, 
    output reg [31:0] aluoutM,

    input      [31:0] writedataE, 
    output reg [31:0] writedataM,
    
    input      [4:0] writeregE, 
    output reg [4:0] writeregM
    
);

    always @(posedge clk) begin

        if(reset) begin

            {regwriteM, memtoregM, memwriteM} <= 3'b0;
            aluoutM <= 32'b0; 
            writedataM <= 32'b0;
            writeregM <= 5'b0;
        end

        else begin
            regwriteM <= regwriteE;
            memtoregM <= memtoregE;
            memwriteM <= memwriteE;
            aluoutM   <= aluoutE;
            writedataM <= writedataE;
            writeregM <= writeregE;

        end 

    end
endmodule