`timescale 1ns / 1ps
module Sub(a,b,res,clk,rst);
input [15:0] a,b;
output [15:0] diff;
input clk;
input rst;

always @(posedge clk or negedge rst) begin
        if (!rst) begin
            diff <= 16'b0; 
        end else begin
            diff <= a - b;  
        end
    end

endmodule

`timescale 1ns / 1ps
module tb_Sub;

    // Declarație semnale
    reg [15:0] a, b;
    reg clk, rst;
    wire [15:0] diff;

    // Instanțierea modulului Sub
    Sub uut (
        .a(a),
        .b(b),
        .res(diff),
        .clk(clk),
        .rst(rst)
    );

    // Generare semnal clock
    always #5 clk = ~clk;

    initial begin
        // Inițializare semnale
        clk = 0;
        rst = 0;
        a = 0;
        b = 0;

        // Reset
        #10 rst = 1;
        #10;

        // Test 1: Scădere simplă
        a = 16'h0005; b = 16'h0003; #10;
        $display("Test 1: a = %h, b = %h, diff = %h", a, b, diff);

        // Test 2: Rezultat negativ
        a = 16'h0003; b = 16'h0005; #10;
        $display("Test 2: a = %h, b = %h, diff = %h", a, b, diff);

        // Test 3: Zero input
        a = 16'h0000; b = 16'h0000; #10;
        $display("Test 3: a = %h, b = %h, diff = %h", a, b, diff);

        // Finalizarea simulării
        $stop;
    end

endmodule
