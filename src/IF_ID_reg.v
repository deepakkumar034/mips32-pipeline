module IF_ID_reg(

    input  clk, 
    input  reset, 
    input  [31:0] instrF,
    input  [31:0] pcplus4F,
    input  stallD, 
    input  flushD,
    output reg [31:0] instrD,
    output reg [31:0] pcplus4D
);

    always @(posedge clk) begin
        
        if(reset) begin
            instrD <= 32'b0;
            pcplus4D <= 32'b0;
        end

        else if (flushD) begin               // flushD = pcsrcD | jumpD
            instrD <= 32'b0;
            pcplus4D <= 32'b0;
        end

        else if (!stallD) begin
            instrD <= instrF;
            pcplus4D <= pcplus4F;
        end
    end
endmodule
