module HAZARD_UNIT(
    // Register addresses for forwarding
    input  [4:0] rsD, rtD,          
    input  [4:0] rsE, rtE,          
    input  [4:0] writeregE,         
    input  [4:0] writeregM,         
    input  [4:0] writeregW,        

    // Control signals
    input        regwriteE,
    input        regwriteM,
    input        regwriteW,
    input        memtoregE,         
    input        branchD,           
    input        jumpD,              

    // Forwarding outputs (to Execute stage muxes)
    output reg [1:0] forwardAE,     // 00=regfile 01=WB 10=MEM
    output reg [1:0] forwardBE,

    // Branch forwarding outputs 
    output       forwardAD,
    output       forwardBD,

    // Stall / flush outputs
    output       stallF,
    output       stallD,
    output       flushE
);

    // EX forwarding 
    // Priority: MEM result over WB result
    always @(*) begin
        // ForwardAE
        if      (regwriteM && writeregM != 5'd0 && writeregM == rsE)
            forwardAE = 2'b10;   // forward from MEM stage
        else if (regwriteW && writeregW != 5'd0 && writeregW == rsE)
            forwardAE = 2'b01;   // forward from WB stage
        else
            forwardAE = 2'b00;   // no forwarding — use regfile

        // ForwardBE
        if      (regwriteM && writeregM != 5'd0 && writeregM == rtE)
            forwardBE = 2'b10;
        else if (regwriteW && writeregW != 5'd0 && writeregW == rtE)
            forwardBE = 2'b01;
        else
            forwardBE = 2'b00;
    end

    // Branch forwarding (MEM → Decode comparator) 
    assign forwardAD = regwriteM && (writeregM != 5'd0) && (writeregM == rsD);
    assign forwardBD = regwriteM && (writeregM != 5'd0) && (writeregM == rtD);

    // Load-use hazard 
    wire lwstall = memtoregE && (rtE == rsD || rtE == rtD);

    // Branch hazard
    // stall if branch source reg being written by instr in Execute
    wire branchstall = branchD && regwriteE &&
                       (writeregE == rsD || writeregE == rtD);

    // Stall / Flush logic 
    assign stallF  = lwstall | branchstall;
    assign stallD  = lwstall | branchstall;
    assign flushE  = lwstall | branchstall | jumpD;
    

endmodule