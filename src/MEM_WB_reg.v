module MEM_WB_reg(

    input clk, 
    input reset,

    input      regwriteM, 
    output reg regwriteW,

    input      memtoregM,
    output reg memtoregW,
    
    input      [31:0] readdataM,
    output reg [31:0] readdataW,
    
    input      [31:0] aluoutM,
    output reg [31:0] aluoutW,

    input      [4:0] writeregM,
    output reg [4:0] writeregW

);

    always @(posedge clk) begin
        
        if(reset) begin
            regwriteW <= 1'b0;
            memtoregW <= 1'b0;
            readdataW <= 32'b0;
            aluoutW   <= 32'b0;
            writeregW <= 5'b0;
        end

        else begin
            regwriteW <= regwriteM;
            memtoregW <= memtoregM;
            readdataW <= readdataM;
            aluoutW   <= aluoutM;
            writeregW <= writeregM;
        end
    end
endmodule