`timescale 1ns / 1ps
module divider(
    input [15:0] dividend,
    input [15:0] divisor,
    input wire clk,
    input wire rst,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            quotient <= 16'b0;
            remainder <= 16'b0;
        end else begin
            if (divisor != 16'b0) begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end else begin
                quotient <= 16'b0;
                remainder <= 16'b0;
            end
        end
    end
endmodule


module tb_division;
    parameter WIDTH = 16;
    // Inputs
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    // Outputs
    wire [WIDTH-1:0] Res;
    wire[WIDTH:0] remainder;

    // Instantiate the division module (UUT)
    division #(WIDTH) uut (
        .A(A), 
        .B(B), 
        .Res(Res),
        .remainder(remainder)
    );

    initial begin
        // Initialize Inputs and wait for 100 ns
        A = 0;  B = 0;  #100;  //Undefined inputs
        //Apply each set of inputs and wait for 100 ns.
         $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 798;    B = 11; #100;
          $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 200;    B = 40; #100;
          $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 90; B = 9;  #100;
          $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 70; B = 10; #100;
         $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 16; B = 3;  #100;
          $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
        A = 255;    B = 5;  #100;
          $display("A = %d, B = %d, Res = %d, Remainder =%d", A, B, Res, remainder);
    end
endmodule


