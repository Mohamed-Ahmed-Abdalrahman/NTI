module ram_512x16 (
    input wire clk,
    input wire reset,
    input wire W_R,
    input wire [15:0] WR_Data,
    input wire [8:0] WR_ADDR,
    input wire [8:0] RD_ADDR1,
    input wire [8:0] RD_ADDR2,
    output wire [15:0] RD_Data_1,
    output wire [15:0] RD_Data_2
);

    reg [15:0] memory [0:511];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 512; i = i + 1) begin
                memory[i] <= 16'b0;
            end
        end else if (W_R) begin
            memory[WR_ADDR] <= WR_Data;
        end
    end

    assign RD_Data_1 = (!W_R) ? memory[RD_ADDR1] : 16'b0;
    assign RD_Data_2 = (!W_R) ? memory[RD_ADDR2] : 16'b0;

endmodule