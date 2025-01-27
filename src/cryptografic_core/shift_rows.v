module shift_rows(
    input clk, rst, cript, decript,
    input [15:0] data_in,
    output reg [15:0] data_out
);

    always @(posedge clk) begin
        if (!rst) begin
            data_out <= 16'b0;
        end else begin
            if (cript == 1'b1) begin
                data_out <= {data_in[0], data_in[15:1]};
            end 
            else if (decript == 1'b1) begin   
                data_out <= {data_in[14:0], data_in[15]};
            end
        end
    end
endmodule
