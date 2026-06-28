module memory_stage(
    
    input clk, 
    input memwriteM,
    input [31:0] aluoutM,
    input [31:0] writedataM,

    output [31:0] readdataM 
);

    data_mem dmem(
        .clk(clk),
        .we(memwriteM),
        .a(aluoutM),
        .wd(writedataM),
        .rd(readdataM)
    );

endmodule