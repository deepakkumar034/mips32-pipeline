module execute_stage(

    input [3:0] alucontrolE,
    input alusrcE, regdstE,
    
    input [31:0] rd1E, rd2E,
    input [4:0] rsE, rtE, rdE,
    input [31:0] resultW, aluoutM,

    input [31:0] signimmE,

    output [31:0] aluoutE, 
    output [4:0] writeregE,
    output [31:0] writedataE,

    input [1:0] forwardAE, forwardBE
);

    wire [31:0] srcAE, srcBE;  
    wire zero;

    mux3 forA_mux(rd1E, resultW, aluoutM, forwardAE, srcAE);
    mux3 forB_mux(rd2E, resultW, aluoutM, forwardBE, writedataE);

    mux2 #(32) btw_mux(writedataE, signimmE, alusrcE, srcBE);

    mux2 #(5) rd_mux(rtE, rdE, regdstE, writeregE);

    alu alu(
        .a(srcAE), 
        .b(srcBE),
        .alucontrol(alucontrolE),
        .result(aluoutE),
        .zero(zero)
    );

endmodule