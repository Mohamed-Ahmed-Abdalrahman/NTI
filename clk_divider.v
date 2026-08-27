module clk_divider #(
    parameter division = 4
)(
    input  wire CLK_in,
    input  wire Reset_n,
    output reg  CLK_out
);

    integer count;

    always @(posedge CLK_in or negedge Reset_n) begin
        if (!Reset_n) begin
            count   <= 0;
            CLK_out <= 0;
        end else if (count == ((division/2) - 1)) begin
            count   <= 0;
            CLK_out <= ~CLK_out;
        end else begin
            count   <= count + 1;
        end
    end

endmodule