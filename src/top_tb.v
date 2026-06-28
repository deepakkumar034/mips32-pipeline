`timescale 1ns/1ps
module top_tb;

    reg clk, reset;
    integer passed = 0;
    integer failed = 0;

    top DUT(.clk(clk), .reset(reset));

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


        
        $finish;
    end

    initial begin
        #5000;
        $display("TIMEOUT");
        $finish;
    end
    initial begin
    @(posedge clk); @(posedge clk); // past reset
    repeat(15) begin
        @(posedge clk); #1;
        $display("t=%0t | pcF=%0h | wregE=%0d wregM=%0d wregW=%0d | fwdAE=%0b fwdBE=%0b | rsE=%0d rtE=%0d | srcA=%0d srcB=%0d | aluout=%0d | resultW=%0d",
            $time,
            DUT.pcF,
            DUT.writeregE, DUT.writeregM, DUT.writeregW,
            DUT.forwardAE, DUT.forwardBE,
            DUT.rsE, DUT.rtE,
            DUT.e.srcAE, DUT.e.srcBE,
            DUT.aluoutE,
            DUT.resultW
        );
    end
end

endmodule
