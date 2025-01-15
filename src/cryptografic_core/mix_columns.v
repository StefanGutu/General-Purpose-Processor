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
    reg mix_col;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Instantiate the mix_columns_16 module
    mix_columns_16 uut (
        .clk(clk),
        .rst(rst),
        .mix_col(mix_col),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        mix_col = 0;
        data_in = 16'h0000;

        // Reset the system
        #10 rst = 0;
        #10 rst = 1;

        // Enable mix_columns operation
        mix_col = 1;

        // Test cases
        data_in = 16'h1234;
        #10;
        $display("Input: 0x1234, Output: 0x%h", data_out);

        data_in = 16'h9ABC;
        #10;
        $display("Input: 0x9ABC, Output: 0x%h", data_out);

        data_in = 16'hFEDC;
        #10;
        $display("Input: 0xFEDC, Output: 0x%h", data_out);

        data_in = 16'h0000;
        #10;
        $display("Input: 0x0000, Output: 0x%h", data_out);

        data_in = 16'hFFFF;
        #10;
        $display("Input: 0xFFFF, Output: 0x%h", data_out);

        data_in = 16'h0707;
        #10;
        $display("Input: 0x0707, Output: 0x%h", data_out);

        data_in = 16'h1111;
        #10;
        $display("Input: 0x1111, Output: 0x%h", data_out);

        data_in = 16'h2222;
        #10;
        $display("Input: 0x2222, Output: 0x%h", data_out);

        data_in = 16'h3333;
        #10;
        $display("Input: 0x3333, Output: 0x%h", data_out);

        data_in = 16'h4444;
        #10;
        $display("Input: 0x4444, Output: 0x%h", data_out);

        data_in = 16'h5555;
        #10;
        $display("Input: 0x5555, Output: 0x%h", data_out);

        data_in = 16'h6666;
        #10;
        $display("Input: 0x6666, Output: 0x%h", data_out);

        data_in = 16'h7777;
        #10;
        $display("Input: 0x7777, Output: 0x%h", data_out);

        data_in = 16'h8888;
        #10;
        $display("Input: 0x8888, Output: 0x%h", data_out);

        data_in = 16'h9999;
        #10;
        $display("Input: 0x9999, Output: 0x%h", data_out);

        data_in = 16'hAAAA;
        #10;
        $display("Input: 0xAAAA, Output: 0x%h", data_out);

        data_in = 16'hBBBB;
        #10;
        $display("Input: 0xBBBB, Output: 0x%h", data_out);

        data_in = 16'hCCCC;
        #10;
        $display("Input: 0xCCCC, Output: 0x%h", data_out);

        data_in = 16'hDDDD;
        #10;
        $display("Input: 0xDDDD, Output: 0x%h", data_out);

        data_in = 16'hEEEE;
        #10;
        $display("Input: 0xEEEE, Output: 0x%h", data_out);

        data_in = 16'hFFFF;
        #10;
        $display("Input: 0xFFFF, Output: 0x%h", data_out);

        data_in = 16'h0F0F;
        #10;
        $display("Input: 0x0F0F, Output: 0x%h", data_out);

        data_in = 16'hF0F0;
        #10;
        $display("Input: 0xF0F0, Output: 0x%h", data_out);

        data_in = 16'h1234;
        #10;
        $display("Input: 0x1234, Output: 0x%h", data_out);

        data_in = 16'h5678;
        #10;
        $display("Input: 0x5678, Output: 0x%h", data_out);

        data_in = 16'h9ABC;
        #10;
        $display("Input: 0x9ABC, Output: 0x%h", data_out);

        data_in = 16'hDEF0;
        #10;
        $display("Input: 0xDEF0, Output: 0x%h", data_out);

        data_in = 16'h1357;
        #10;
        $display("Input: 0x1357, Output: 0x%h", data_out);

        data_in = 16'h2468;
        #10;
        $display("Input: 0x2468, Output: 0x%h", data_out);

        data_in = 16'h369C;
        #10;
        $display("Input: 0x369C, Output: 0x%h", data_out);

        data_in = 16'h48BD;
        #10;
        $display("Input: 0x48BD, Output: 0x%h", data_out);

        data_in = 16'h5AEF;
        #10;
        $display("Input: 0x5AEF, Output: 0x%h", data_out);

        data_in = 16'h6CF1;
        #10;
        $display("Input: 0x6CF1, Output: 0x%h", data_out);

        data_in = 16'h7E02;
        #10;
        $display("Input: 0x7E02, Output: 0x%h", data_out);

        // End the simulation
        //$finish;
    end
endmodule
