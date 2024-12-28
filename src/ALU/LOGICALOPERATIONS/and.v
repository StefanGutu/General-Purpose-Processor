`timescale 1ns / 1ps
module AND16bit(
    input wire [15:0] inp1, 
    input wire [15:0] inp2, 
    input wire clk,          
    input wire rst,        
    output reg [15:0] out
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0; 
        end else begin
            out <= inp1 & inp2; 
        end
    end

endmodule

module AND16bit_tb;

    reg [15:0] inp1, inp2;  // Intrări pe 16 biți
    reg clk, rst;            // Semnal de ceas și reset
    wire [15:0] and_out;     // Ieșire pentru operația AND

    // Instanțierea modulului AND16bit
    AND16bit uut_and (
        .inp1(inp1),
        .inp2(inp2),
        .clk(clk),
        .rst(rst),
        .out(and_out)
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
        $display("Running AND tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input 1   |   Input 2   | AND Output | Result |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'b0000000000001101, 16'b0000000000001001); // PASSED
        run_test(16'b1111000000001111, 16'b0000111111110000, 16'b0000000000000000); // PASSED
        run_test(16'b0000000000000000, 16'b1111111111111111, 16'b0000000000000000); // PASSED
        run_test(16'b1111111111111111, 16'b0000000000000000, 16'b0000000000000000); // PASSED

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in1,
        input [15:0] test_in2,
        input [15:0] expected_and_out
    );
        begin
            inp1 = test_in1;
            inp2 = test_in2;

            // Așteaptă pentru a obține rezultatul
            #10;

            // Verifică rezultatele pentru AND
            if (and_out == expected_and_out) begin
                $display("| %16b | %16b | %16b | PASSED  |", inp1, inp2, and_out);
            end else begin
                $display("| %16b | %16b | %16b | FAILED  |", inp1, inp2, and_out);
            end
        end
    endtask

endmodule