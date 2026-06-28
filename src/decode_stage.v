module decode_stage(
    input         clk,
    input  [31:0] instrD,
    input  [31:0] pcplus4D,
    input  [4:0]  writeregW,
    input  [31:0] resultW,
    input         regwriteW,
    input         forwardAD, forwardBD,
    input  [31:0] aluoutM,

    output        regwriteD, memtoregD, memwriteD,
    output        branchD,             
    output        jumpD, alusrcD, regdstD, pcsrcD, flushD,
    output [3:0]  alucontrolD,
    output [31:0] rd1D, rd2D,
    output [4:0]  rsD, rtD, rdD,
    output [31:0] signimmD, pcbranchD, jumpaddrD
);
    wire        equalD;
    wire [31:0] sl2out;                 
    wire [31:0] equal1, equal2;

    control_unit c(
        .opcode(instrD[31:26]),
        .funct(instrD[5:0]),
        .equalD(equalD),
        .regwrite(regwriteD),
        .memtoreg(memtoregD),
        .memwrite(memwriteD),
        .branch(branchD),               
        .pcsrc(pcsrcD),
        .jump(jumpD),
        .alusrc(alusrcD),
        .regdst(regdstD),
        .alucontrol(alucontrolD)
    );

    register_file r(
        .clk(clk),
        .a1(instrD[25:21]),
        .a2(instrD[20:16]),
        .a3(writeregW),
        .we3(regwriteW),
        .wd3(resultW),
        .rd1(rd1D),
        .rd2(rd2D)
    );

    sign_extend se(instrD[15:0], signimmD);
    shift_left2 shiftsl2(signimmD, sl2out);  
    adder add(sl2out, pcplus4D, pcbranchD);  

    assign jumpaddrD = {pcplus4D[31:28], instrD[25:0], 2'b00};

    mux2 #(32) for1_mux(rd1D, aluoutM, forwardAD, equal1);
    mux2 #(32) for2_mux(rd2D, aluoutM, forwardBD, equal2);

    assign equalD = (equal1 == equal2);

    assign rsD = instrD[25:21];
    assign rtD = instrD[20:16];
    assign rdD = instrD[15:11];

    assign flushD = pcsrcD | jumpD;

endmodule