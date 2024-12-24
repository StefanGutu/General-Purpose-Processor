module mix_columns_16(
    input         clk,
    input         rst,      //probably missing control signals
    input  [15:0] data_in,   
    output reg [15:0] data_out 
);
    // Split the 16-bit input into two 8-bit blocks
    wire [7:0] A = data_in[15:8];
    wire [7:0] B = data_in[7:0];

    wire [7:0] two_A, two_B;     // 2 * A and 2 * B
    wire [7:0] three_A, three_B; // 3 * A and 3 * B

    // Function to compute GF(2^8) reduction with AES polynomial
    function [7:0] gf_reduce(input [7:0] val);
        begin
            gf_reduce = (val[7] == 1'b1) ? ((val << 1) ^ 8'h1B) : (val << 1);
        end
    endfunction

    assign two_A = gf_reduce(A);
    assign two_B = gf_reduce(B);

    assign three_A = two_A ^ A; //XOR works as addition, so two_A ^ A is 2 * A + A
    assign three_B = two_B ^ B;

    always @(posedge clk) begin
        if (!rst) begin
            data_out <= 16'b0; 
        end else begin
            data_out[15:8] <= two_A ^ three_B;  // C = 2 * A XOR 3 * B
            data_out[7:0]  <= three_A ^ two_B;  // D = 3 * A XOR 2 * B
        end
    end
endmodule

