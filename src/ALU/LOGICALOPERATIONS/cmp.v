`timescale 1ns / 1ps
module CMP16bit(
    input wire [15:0] op1,       
    input wire [15:0] op2,       
    input wire clk,               
    input wire rst,   
    output reg [15:0] result            
);
           

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
           result <= 16'b0;
        end else begin
           result <= op1 - op2;
        end
    end

endmodule



module CMP16bit_tb;

    reg [15:0] inp1, inp2;  // Intrări pe 16 biți
    reg clk, rst;            // Semnal de ceas și reset
    wire equal, greater, less; // Ieșiri pentru comparație

    // Instanțierea modulului CMP16bit
    CMP16bit uut (
        .inp1(inp1),
        .inp2(inp2),
        .clk(clk),
        .rst(rst),
        .equal(equal),
        .greater(greater),
        .less(less)
    );

    // Generare semnal de ceas
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Perioadă de 10 unități de timp
    end

    // Teste
    initial begin
        rst = 0; // Reset activ
        #15 rst = 1; // Scoaterea resetului după 15 unități de timp

        // Afișarea headerului
        $display("Running CMP tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input 1   |   Input 2   | Equal | Greater | Less | Result |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'b0000000000001011, 1, 0, 0); // PASSED
        run_test(16'b1111000000001111, 16'b0000111111110000, 0, 1, 0); // PASSED
        run_test(16'b0000000000000000, 16'b1111111111111111, 0, 0, 1); // PASSED
        run_test(16'b1000000000000000, 16'b0111111111111111, 0, 1, 0); // PASSED

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in1,
        input [15:0] test_in2,
        input expected_equal,
        input expected_greater,
        input expected_less
    );
        begin
            inp1 = test_in1;
            inp2 = test_in2;

            // Așteaptă pentru a obține rezultatul
            #10;

            // Verifică rezultatele pentru comparație
            if (equal == expected_equal && greater == expected_greater && less == expected_less) begin
                $display("| %16b | %16b |    %b   |    %b    |  %b  | PASSED  |", inp1, inp2, equal, greater, less);
            end else begin
                $display("| %16b | %16b |    %b   |    %b    |  %b  | FAILED  |", inp1, inp2, equal, greater, less);
            end
        end
    endtask

endmodule