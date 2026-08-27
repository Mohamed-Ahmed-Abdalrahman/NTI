module up_down_counter #(
    parameter WIDTH = 4
)(
    input clk,
    input reset_n,
    input load_enable,
    input enable,
    input up,
    input [WIDTH-1:0] load_value,
    output reg [WIDTH-1:0] count
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= {WIDTH{1'b0}};
        end else if (load_enable) begin
            count <= load_value;
        end else if (enable) begin
            if (up) begin
                count <= count + 1'b1;
            end else begin
                count <= count - 1'b1;
            end
        end
    end

endmodule