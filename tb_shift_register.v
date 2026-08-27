`timescale 1ns/1ps

module tb_rotate_register;

    reg clk;
    reg Reset_n;
    wire [3:0] Shift_out;

    rotate_register uut (
        .clk(clk),
        .Reset_n(Reset_n),
        .Shift_out(Shift_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        Reset_n = 0;

        #12 Reset_n = 1;

        #50;
        
        $finish;
    end

endmodule
