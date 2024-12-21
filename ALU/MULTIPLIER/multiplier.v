`timescale 1ns / 1ps
module multiplier(
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] out,
    input wire clk,
    input wire rst
);
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0;
        end else begin
            out <= a * b;
        end
    end
endmodule


module Testbench;

    parameter N = 16;

    reg [N-1:0] a_in;        // Multiplicand
    reg [N-1:0] b_in;        // Multiplier
    reg clk;                 // Semnal de ceas
    reg start;               // Semnal de start
    reg reset;               // Semnal de reset
    wire [N-1:0] out;        // Rezultatul
    wire finish;             // Semnal de finalizare

    // Instanțierea modulului `multiplier`
    multiplier #(N) uut (
        .out(out),
        .a_in(a_in),
        .b_in(b_in),
        .clk(clk),
        .start(start),
        .reset(reset),
        .finish(finish)
    );

    integer i;

    // Setarea cazurilor de test
    reg [N-1:0] test_a_in[0:10];
    reg [N-1:0] test_b_in[0:10];
    reg [N-1:0] expected_out[0:10];

    initial begin
        // Inițializarea semnalelor
        clk = 0;
        reset = 0;
        start = 0;

        // Inițializarea cazurilor de test
        test_a_in[0] = 16'd1;   test_b_in[0] = 16'd1;   expected_out[0] = 16'd1;
        test_a_in[1] = 16'd2;   test_b_in[1] = 16'd3;   expected_out[1] = 16'd6;
        test_a_in[2] = 16'd5;   test_b_in[2] = 16'd4;   expected_out[2] = 16'd20;
        test_a_in[3] = 16'd10;  test_b_in[3] = 16'd10;  expected_out[3] = 16'd100;
        test_a_in[4] = 16'd15;  test_b_in[4] = 16'd2;   expected_out[4] = 16'd30;
        test_a_in[5] = 16'd128; test_b_in[5] = 16'd256; expected_out[5] = 16'd32768; // Trunchiere
        test_a_in[6] = 16'd32767; test_b_in[6] = 16'd2; expected_out[6] = 16'd65534;
        test_a_in[7] = 16'd0;   test_b_in[7] = 16'd123; expected_out[7] = 16'd0;
        test_a_in[8] = 16'd50;  test_b_in[8] = 16'd20;  expected_out[8] = 16'd1000;
        test_a_in[9] = 16'd100; test_b_in[9] = 16'd0;   expected_out[9] = 16'd0;
        test_a_in[10] = 16'd258; test_b_in[10] = 16'd258;   expected_out[10] = 16'd1028;

        // Parcurgerea cazurilor de test
        for (i = 0; i < 11; i = i + 1) begin
            reset = 1; #10; // Reset activ
            reset = 0; #10; // Reset dezactivat

            // Setarea intrărilor
            a_in = test_a_in[i];
            b_in = test_b_in[i];
            start = 0; #10;
            start = 1; #10; // Pornire calcul

            // Așteptare până la finalizare
            while (!finish) #10;

            // Verificare rezultat
            if (out === expected_out[i]) begin
                $display("Test %d PASSED: a_in=%d, b_in=%d, out=%d", i, a_in, b_in, out);
            end else begin
                $display("Test %d FAILED: a_in=%d, b_in=%d, expected=%d, got=%d",
                    i, a_in, b_in, expected_out[i], out);
            end
        end

        $finish;
    end

    // Generare semnal de ceas
    always #5 clk = ~clk;

endmodule


