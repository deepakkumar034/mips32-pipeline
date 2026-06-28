module register_file(

    input clk, 
    input [4:0] a1, 
    input [4:0] a2, 
    input [4:0] a3, 
    input we3,
    input [31:0] wd3,
    output [31:0] rd1, 
    output [31:0] rd2
);

    reg [31:0] rf [31:0];

    initial begin
        for(int i = 0; i < 32; i++)
            rf[i] = 32'b0;
    end

    always @(posedge clk) begin 
        
        if(we3) 
            rf[a3] <= wd3;
    end

     assign rd1 = (a1 == 0) ? 32'b0 : rf[a1];
     assign rd2 = (a2 == 0) ? 32'b0 : rf[a2];
     
endmodule

