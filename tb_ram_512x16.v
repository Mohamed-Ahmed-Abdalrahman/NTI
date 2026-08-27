`timescale 1ns/1ps

module tb_ram_512x16;

    reg clk;
    reg reset;
    reg W_R;
    reg [15:0] WR_Data;
    reg [8:0] WR_ADDR;
    reg [8:0] RD_ADDR1;
    reg [8:0] RD_ADDR2;
    wire [15:0] RD_Data_1;
    wire [15:0] RD_Data_2;

    ram_512x16 uut (
        .clk(clk),
        .reset(reset),
        .W_R(W_R),
        .WR_Data(WR_Data),
        .WR_ADDR(WR_ADDR),
        .RD_ADDR1(RD_ADDR1),
        .RD_ADDR2(RD_ADDR2),
        .RD_Data_1(RD_Data_1),
        .RD_Data_2(RD_Data_2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        W_R = 0;
        WR_Data = 0;
        WR_ADDR = 0;
        RD_ADDR1 = 0;
        RD_ADDR2 = 0;

        #12 reset = 0;

        #10 W_R = 1;
        WR_ADDR = 9'd10;
        WR_Data = 16'hAAAA;

        #10 WR_ADDR = 9'd500;
        WR_Data = 16'h5555;

        #10 W_R = 0;
        RD_ADDR1 = 9'd10;
        RD_ADDR2 = 9'd500;

        #20;
        $finish;
    end

endmodule