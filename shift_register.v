module rotate_register (
    input clk,
    input Reset_n,
    output reg [3:0] Shift_out
);

    always @(posedge clk or negedge Reset_n) begin
        if (!Reset_n) begin
            Shift_out <= 4'b1000;
        end else begin
            Shift_out <= {Shift_out[0], Shift_out[3:1]};
        end
    end

endmodule
