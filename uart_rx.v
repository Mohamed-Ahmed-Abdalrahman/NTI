module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst_n,
    input wire rx_in,
    output reg [7:0] rx_data,
    output reg rx_done
);

    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_cnt;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            rx_done <= 1'b0;
            clk_cnt <= 0;
            bit_index <= 0;
            rx_data <= 8'b0;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 1'b0;
                    clk_cnt <= 0;
                    bit_index <= 0;
                    if (rx_in == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    if (clk_cnt < (BIT_PERIOD / 2)) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (rx_in == 1'b0) begin
                            state <= DATA;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (clk_cnt < BIT_PERIOD - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        shift_reg[bit_index] <= rx_in;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    if (clk_cnt < BIT_PERIOD - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        rx_data <= shift_reg;
                        rx_done <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
