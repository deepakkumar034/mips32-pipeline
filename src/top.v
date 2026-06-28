module top(
    input clk, 
    input reset
);
    // IF
    wire [31:0] pcF, pcplus4F, instrF;

    // IF/ID
    wire [31:0] instrD, pcplus4D;

    // ID
    wire        regwriteD, memtoregD, memwriteD, jumpD;
    wire        alusrcD, regdstD, pcsrcD, flushD;
    wire        branchD;               
    wire [3:0]  alucontrolD;
    wire [31:0] rd1D, rd2D;
    wire [4:0]  rsD, rtD, rdD;
    wire [31:0] signimmD, pcbranchD, jumpaddrD;

    // ID/EX
    wire        regwriteE, memtoregE, memwriteE, alusrcE, regdstE;
    wire [3:0]  alucontrolE;
    wire [31:0] rd1E, rd2E;
    wire [4:0]  rsE, rtE, rdE;
    wire [31:0] signimmE;

    // EX
    wire [31:0] aluoutE, writedataE;
    wire [4:0]  writeregE;

    // EX/MEM
    wire        regwriteM, memtoregM, memwriteM;
    wire [31:0] aluoutM, writedataM;
    wire [4:0]  writeregM;

    // MEM
    wire [31:0] readdataM;

    // MEM/WB
    wire        regwriteW, memtoregW;
    wire [31:0] readdataW, aluoutW;
    wire [4:0]  writeregW;

    // WB
    wire [31:0] resultW;

    // Hazard unit
    wire [1:0]  forwardAE, forwardBE;
    wire        forwardAD, forwardBD;
    wire        stallF, stallD, flushE;

    fetch_stage f(
        .clk(clk),
        .reset(reset),
        .stallF(stallF),
        .pcsrcD(pcsrcD),
        .jumpD(jumpD),
        .pcbranchD(pcbranchD),
        .jumpaddrD(jumpaddrD),
        .pcF(pcF),
        .pcplus4F(pcplus4F),
        .instrF(instrF)
    );

    IF_ID_reg IF_ID_reg(
        .clk(clk),
        .reset(reset),
        .instrF(instrF),
        .pcplus4F(pcplus4F),
        .stallD(stallD),
        .flushD(flushD),
        .instrD(instrD),
        .pcplus4D(pcplus4D)
    );

    decode_stage d(
        .clk(clk),
        .instrD(instrD),
        .pcplus4D(pcplus4D),
        .writeregW(writeregW),
        .resultW(resultW),
        .regwriteW(regwriteW),         
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .aluoutM(aluoutM),
        .regwriteD(regwriteD),
        .memtoregD(memtoregD),
        .memwriteD(memwriteD),
        .branchD(branchD),             
        .jumpD(jumpD),
        .alusrcD(alusrcD),
        .regdstD(regdstD),
        .pcsrcD(pcsrcD),
        .flushD(flushD),
        .alucontrolD(alucontrolD),
        .rd1D(rd1D), .rd2D(rd2D),
        .rsD(rsD), .rtD(rtD), .rdD(rdD),
        .signimmD(signimmD),
        .pcbranchD(pcbranchD),
        .jumpaddrD(jumpaddrD)
    );

    ID_EX_reg id(
        .clk(clk),
        .reset(reset),
        .flushE(flushE),
        .regwriteD(regwriteD),
        .memtoregD(memtoregD),
        .memwriteD(memwriteD),
        .alusrcD(alusrcD),
        .regdstD(regdstD),
        .alucontrolD(alucontrolD),
        .rd1D(rd1D), .rd2D(rd2D),
        .rsD(rsD), .rtD(rtD), .rdD(rdD),
        .signimmD(signimmD),
        .regwriteE(regwriteE),
        .memtoregE(memtoregE),
        .memwriteE(memwriteE),
        .alusrcE(alusrcE),
        .regdstE(regdstE),
        .alucontrolE(alucontrolE),
        .rd1E(rd1E), .rd2E(rd2E),
        .rsE(rsE), .rtE(rtE), .rdE(rdE),  
        .signimmE(signimmE)
    );

    execute_stage e(
        .alucontrolE(alucontrolE),
        .alusrcE(alusrcE),
        .regdstE(regdstE),
        .rd1E(rd1E), .rd2E(rd2E),
        .rsE(rsE), .rtE(rtE), .rdE(rdE),
        .resultW(resultW),
        .aluoutM(aluoutM),
        .signimmE(signimmE),
        .forwardAE(forwardAE),
        .forwardBE(forwardBE),
        .aluoutE(aluoutE),
        .writeregE(writeregE),
        .writedataE(writedataE)
    );

    EX_MEM_reg exmem(
        .clk(clk),
        .reset(reset),
        .regwriteE(regwriteE),
        .memtoregE(memtoregE),
        .memwriteE(memwriteE),
        .aluoutE(aluoutE),
        .writedataE(writedataE),
        .writeregE(writeregE),
        .regwriteM(regwriteM),
        .memtoregM(memtoregM),
        .memwriteM(memwriteM),
        .aluoutM(aluoutM),
        .writedataM(writedataM),
        .writeregM(writeregM)
    );

    memory_stage ms(
        .clk(clk),
        .memwriteM(memwriteM),
        .aluoutM(aluoutM),
        .writedataM(writedataM),
        .readdataM(readdataM)
    );

    MEM_WB_reg mem_wb(
        .clk(clk),
        .reset(reset),
        .regwriteM(regwriteM),
        .memtoregM(memtoregM),
        .readdataM(readdataM),
        .aluoutM(aluoutM),
        .writeregM(writeregM),
        .regwriteW(regwriteW),
        .memtoregW(memtoregW),
        .readdataW(readdataW),
        .aluoutW(aluoutW),
        .writeregW(writeregW)
    );

    writeback_stage ws(
        .memtoregW(memtoregW),
        .readdataW(readdataW),
        .aluoutW(aluoutW),
        .resultW(resultW)
    );

    HAZARD_UNIT hu(
        .rsD(rsD), .rtD(rtD),
        .rsE(rsE), .rtE(rtE),
        .writeregE(writeregE),
        .writeregM(writeregM),
        .writeregW(writeregW),
        .regwriteE(regwriteE),
        .regwriteM(regwriteM),
        .regwriteW(regwriteW),
        .memtoregE(memtoregE),
        .branchD(branchD),             
        .jumpD(jumpD),
        .forwardAE(forwardAE),
        .forwardBE(forwardBE),
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .stallF(stallF),
        .stallD(stallD),
        .flushE(flushE)
    );

endmodule