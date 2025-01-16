module Add(a,b,sum,clk,rst);
input [15:0] a,b;
output reg [15:0] sum;
input clk;
input rst;

always @(posedge clk or negedge rst) begin
        if (!rst) begin
            sum <= 16'b0; 
        end else begin
            sum <= a + b;  
        end
    end

endmodule

module tb_Add;

    // Declarație semnale
    reg [15:0] a, b;
    reg clk, rst;
    wire [15:0] sum;

    // Instanțierea modulului Add
    Add uut (
        .a(a),
        .b(b),
        .sum(sum),
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

        // Test 1: Adunare simplă
        a = 16'h0003; b = 16'h0004; #10;
        $display("Test 1: a = %h, b = %h, sum = %h", a, b, sum);

        // Test 2: Depășirea limitei de 16 biți
        a = 16'hFFFF; b = 16'h0001; #10;
        $display("Test 2: a = %h, b = %h, sum = %h", a, b, sum);

        // Test 3: Zero input
        a = 16'h0000; b = 16'h0000; #10;
        $display("Test 3: a = %h, b = %h, sum = %h", a, b, sum);

        // Finalizarea simulării
        $stop;
    end

endmodule
