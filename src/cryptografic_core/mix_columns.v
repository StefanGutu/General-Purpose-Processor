module mix_columns_16(
    input         clk,
    input         rst,
    input         mix_col,
    input  [15:0] data_in,
    output reg [15:0] data_out
);
    wire [3:0] A = data_in[15:12];
    wire [3:0] B = data_in[11:8];
    wire [3:0] C = data_in[7: 4];
    wire [3:0] D = data_in[3: 0];
  
   
    function [3:0] gf_mul_2(input [3:0] x);
        gf_mul_2 = (x[3] == 1) ? ((x << 1) ^ 4'h3) : (x << 1);  
    endfunction

    function [3:0] gf_mul_3(input [3:0] x);
        gf_mul_3 = gf_mul_2(x) ^ x; 
    endfunction

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_out <= 16'b0;
        end else begin
            if(mix_col == 1'b1) begin
                data_out[15:12] <= A ^ gf_mul_2(B) ^ C ^ gf_mul_3(D); 
                data_out[11:8]  <= gf_mul_3(A) ^ B ^ gf_mul_2(C) ^ D;
                data_out[7:4]   <= A ^ gf_mul_3(B) ^ C ^ gf_mul_2(D);
                data_out[3:0]   <= gf_mul_2(A) ^ B ^ gf_mul_3(C) ^ D; 
            end
        end
    end
endmodule

module tb_mix_columns_16;
    reg clk;
    reg rst;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Instantiate the mix_columns_16 module
    mix_columns_16 uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initial values
        clk = 0;
        rst = 1;
        data_in = 16'h0000;


        // Test with different input values
        data_in = 16'h1234;  // Example input value (A=0x12, B=0x34)
        #10;
        $display("Input: 0x1234, Output: 0x%h", data_out);

        data_in = 16'h9ABC;  // Example input value (A=0x9A, B=0xBC)
        #10;
        $display("Input: 0x9ABC, Output: 0x%h", data_out);

        data_in = 16'hFEDC;  // Example input value (A=0xFE, B=0xDC)
        #10;
        $display("Input: 0xFEDC, Output: 0x%h", data_out);

        data_in = 16'h0000;  // Test with zero input
        #10;
        $display("Input: 0x0000, Output: 0x%h", data_out);

        data_in = 16'hFFFF;  // Test with 0xFF input (A=0xFF, B=0xFF)
        #10;
        $display("Input: 0xFFFF, Output: 0x%h", data_out);

        data_in = 16'h0707;  // Test with alternating bits input
        #10;
        $display("Input: 0x0707, Output: 0x%h", data_out);

        // End the simulation
        $finish;
    end
endmodule
