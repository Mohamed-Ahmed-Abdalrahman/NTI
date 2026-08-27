`timescale 1ns/1ps

module tb_uart;

    reg clk;
    reg rst_n;
    reg start;
    reg [7:0] tx_data;
    wire tx_out;
    wire busy;
    wire [7:0] rx_data;
    wire rx_done;

    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(tx_data),
        .tx_out(tx_out),
        .busy(busy)
    );

    uart_rx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_in(tx_out),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        start = 0;
        tx_data = 8'h00;

        #100;
        rst_n = 1;
        #100;

        tx_data = 8'hA5;
        start = 1;
        #20;
        start = 0;

        wait(rx_done == 1'b1);

        #100;
        if (rx_data == 8'hA5) begin
            $display("SUCCESS: Sent 8'hA5 and received 8'hA5 correctly!");
        end else begin
            $display("ERROR: Received wrong data!");
        end

        $finish;
    end
endmodule
