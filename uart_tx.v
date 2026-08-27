module uart_tx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] tx_data,
    output reg tx_out,
    output reg busy
);

    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_cnt;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            tx_out <= 1'b1;
            busy <= 1'b0;
            clk_cnt <= 0;
            bit_index <= 0;
            data_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx_out <= 1'b1;
                    busy <= 1'b0;
                    clk_cnt <= 0;
                    bit_index <= 0;
                    if (start) begin
                        data_reg <= tx_data;
                        busy <= 1'b1;
                        state <= START;
                    end
                end

                START: begin
                    tx_out <= 1'b0;
                    if (clk_cnt < BIT_PERIOD - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx_out <= data_reg[bit_index];
                    if (clk_cnt < BIT_PERIOD - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx_out <= 1'b1;
                    if (clk_cnt < BIT_PERIOD - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        busy <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
