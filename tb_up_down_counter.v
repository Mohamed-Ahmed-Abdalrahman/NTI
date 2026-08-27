`timescale 1ns/1ps

module tb_up_down_counter;

    parameter WIDTH = 4;

    reg clk;
    reg reset_n;
    reg load_enable;
    reg enable;
    reg up;
    reg [WIDTH-1:0] load_value;
    wire [WIDTH-1:0] count;

    up_down_counter #(
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .load_enable(load_enable),
        .enable(enable),
        .up(up),
        .load_value(load_value),
        .count(count)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;
        load_enable = 0;
        enable = 0;
        up = 0;
        load_value = 0;

        #12 reset_n = 1;

        load_value = 4'b0101;
        load_enable = 1;
        #10 load_enable = 0;

        enable = 1;
        up = 1;
        #50;

        up = 0;
        #50;

        enable = 0;
        #20;

        $finish;
    end

endmodule