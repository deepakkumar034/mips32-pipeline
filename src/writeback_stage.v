module writeback_stage(
    input         memtoregW,
    input  [31:0] readdataW,
    input  [31:0] aluoutW,
    output [31:0] resultW
);
    assign resultW = memtoregW ? readdataW : aluoutW;

endmodule