module inv_mix_columns_16(
    input         clk,
    input         rst,
    input         inv_mix_col,
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
            if(inv_mix_col == 1'b1) begin
                data_out[15:12] <= A ^ gf_mul_3(B) ^ C ^ gf_mul_2(D); 
                data_out[11:8]  <= gf_mul_2(A) ^ B ^ gf_mul_3(C) ^ D;
                data_out[7:4]   <= A ^ gf_mul_2(B) ^ C ^ gf_mul_3(D);
                data_out[3:0]   <= gf_mul_3(A) ^ B ^ gf_mul_2(C) ^ D; 
            end
        end
    end
endmodule

module tb_inv_mix_columns_16;
    reg clk;
    reg rst;
    reg inv_mix_col;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Instanța modulului de testat
    inv_mix_columns_16 uut (
        .clk(clk),
        .rst(rst),
        .inv_mix_col(inv_mix_col),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Declarații la nivel de modul
    integer i;
    reg [15:0] test_inputs[0:31];
    reg [15:0] expected_outputs[0:31];

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Inițializare vectori de test
        test_inputs[0]  = 16'hA3C1; expected_outputs[0]  = 16'h1234;
        test_inputs[1]  = 16'h2B49; expected_outputs[1]  = 16'h9ABC;
        test_inputs[2]  = 16'hA98B; expected_outputs[2]  = 16'hFEDC;
        test_inputs[3]  = 16'h0000; expected_outputs[3]  = 16'h0000;
        test_inputs[4]  = 16'hFFFF; expected_outputs[4]  = 16'hFFFF;
        test_inputs[5]  = 16'h7070; expected_outputs[5]  = 16'h0707;
        test_inputs[6]  = 16'h1111; expected_outputs[6]  = 16'h1111;
        test_inputs[7]  = 16'h2222; expected_outputs[7]  = 16'h2222;
        test_inputs[8]  = 16'h3333; expected_outputs[8]  = 16'h3333;
        test_inputs[9]  = 16'h4444; expected_outputs[9]  = 16'h4444;
        test_inputs[10] = 16'h5555; expected_outputs[10] = 16'h5555;
        test_inputs[11] = 16'h6666; expected_outputs[11] = 16'h6666;
        test_inputs[12] = 16'h7777; expected_outputs[12] = 16'h7777;
        test_inputs[13] = 16'h8888; expected_outputs[13] = 16'h8888;
        test_inputs[14] = 16'h9999; expected_outputs[14] = 16'h9999;
        test_inputs[15] = 16'hAAAA; expected_outputs[15] = 16'hAAAA;
        test_inputs[16] = 16'hBBBB; expected_outputs[16] = 16'hBBBB;
        test_inputs[17] = 16'hCCCC; expected_outputs[17] = 16'hCCCC;
        test_inputs[18] = 16'hDDDD; expected_outputs[18] = 16'hDDDD;
        test_inputs[19] = 16'hEEEE; expected_outputs[19] = 16'hEEEE;
        test_inputs[20] = 16'hFFFF; expected_outputs[20] = 16'hFFFF;
        test_inputs[21] = 16'hF0F0; expected_outputs[21] = 16'h0F0F;
        test_inputs[22] = 16'h0F0F; expected_outputs[22] = 16'hF0F0;
        test_inputs[23] = 16'h5FBD; expected_outputs[23] = 16'h5678;
        test_inputs[24] = 16'hD735; expected_outputs[24] = 16'hDEF0;
        test_inputs[25] = 16'hBDF9; expected_outputs[25] = 16'h1357;
        test_inputs[26] = 16'h76B2; expected_outputs[26] = 16'h2468;
        test_inputs[27] = 16'h1EB4; expected_outputs[27] = 16'h369C;
        test_inputs[28] = 16'h8CD3; expected_outputs[28] = 16'h48BD;
        test_inputs[29] = 16'hE5BE; expected_outputs[29] = 16'h5AEF;
        test_inputs[30] = 16'h1AC3; expected_outputs[30] = 16'h6CF1;
        test_inputs[31] = 16'hE522; expected_outputs[31] = 16'h7E02;

        // Inițializări
        clk = 0;
        rst = 1;
        inv_mix_col = 1; // Activăm operația
        #10 rst = 0; // Ieșim din reset
        #10 rst = 1;

        // Testăm fiecare pereche input-output
        for (i = 0; i < 32; i = i + 1) begin
            data_in = test_inputs[i];
            #20; // Așteptăm suficient timp pentru stabilizare

            if (data_out !== expected_outputs[i]) begin
                $display("ERROR: Input: 0x%h, Expected Output: 0x%h, Actual Output: 0x%h", 
                          test_inputs[i], expected_outputs[i], data_out);
            end else begin
                $display("PASS: Input: 0x%h, Output: 0x%h", test_inputs[i], data_out);
            end
        end

        //$finish; // Terminăm simularea
    end
endmodule





