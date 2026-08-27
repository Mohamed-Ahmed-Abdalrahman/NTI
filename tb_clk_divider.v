`timescale 1ns/1ps

module tb_clk_divider;

    reg  CLK_in;
    reg  Reset_n;
    wire CLK_out;

    clk_divider #(
        .division(4)
    ) uut (
        .CLK_in(CLK_in),
        .Reset_n(Reset_n),
        .CLK_out(CLK_out)
    );

    always #5 CLK_in = ~CLK_in;

    initial begin
        CLK_in  = 0;
        Reset_n = 1;

        #2;
        Reset_n = 0;
        #10;
        Reset_n = 1;

        #200;
        $finish;
    end

endmodule