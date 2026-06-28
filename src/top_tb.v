`timescale 1ns/1ps

module top_tb;

    reg clk;
    reg reset;

    top DUT (
        .clk(clk),
        .reset(reset)
    );

    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    
    initial begin
        $dumpfile("mips_pip.vcd");
        $dumpvars(0, top_tb);
        $dumpvars(0, DUT);

        reset = 1'b1;

        @(posedge clk);
        @(posedge clk);

        reset = 1'b0;
    end

    initial begin

        wait(reset == 0);

        $display("\n===== PIPELINE TRACE =====\n");

        repeat (30) begin

            @(posedge clk);
            #1;

            $display(
            "t=%0t | PC=%h | rsE=%0d rtE=%0d | wrE=%0d wrM=%0d wrW=%0d | FwdAE=%b FwdBE=%b | StallD=%b StallF=%b FlushE=%b | ALU=%0d",
            $time,
            DUT.pcF,
            DUT.rsE,
            DUT.rtE,
            DUT.writeregE,
            DUT.writeregM,
            DUT.writeregW,
            DUT.forwardAE,
            DUT.forwardBE,
            DUT.stallD,
            DUT.stallF,
            DUT.flushE,
            DUT.aluoutE
            );

        end

    end

    initial begin
        #1000;
        $display("\n===== SIMULATION COMPLETE =====");
        $finish;
    end

endmodule