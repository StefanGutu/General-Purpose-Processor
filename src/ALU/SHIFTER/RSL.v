`timescale 1ns / 1ps
module RSL16bit(
    input wire [15:0] inp,         
    input wire [15:0] shift_value,  
    input wire clk,                
    input wire rst,                
    output reg [15:0] out   
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0; 
        end else begin
            out <= (inp << shift_value[3:0]) | (inp >> (16 - shift_value[3:0]));
        end
    end

endmodule

module RSL16bit_tb;

    reg [15:0] inp;          // Intrare pe 16 biți
    reg [15:0] shift_value;   // Valoare de shift pe 4 biți
    reg clk, rst;            // Semnal de ceas și reset
    wire [15:0] out;         // Ieșire pe 16 biți

    // Instanțierea modulului RSL16bit
    RSL16bit uut (
        .inp(inp),
        .shift_value(shift_value),
        .clk(clk),
        .rst(rst),
        .out(out)
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
        $display("Running tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input    | Shift Value | Expected Output | Output   | Result  |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'd4, 16'b0000000010110000); // PASSED
        run_test(16'b1000000000001011, 16'd4, 16'b0000000010111000); // PASSED
        run_test(16'b0000000000001111, 16'd4, 16'b0000000011110000); // PASSED
        run_test(16'b1111111111111111, 16'd8, 16'b1111111111111111); // PASSED
        run_test(16'b0000000000000001, 16'd1, 16'b0000000000000010); // PASSED

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in,
        input [15:0] shift_val,
        input [15:0] expected_out
    );
        begin
            inp = test_in;
            shift_value = shift_val;

            // Așteaptă pentru a obține rezultatul
            #10;

            if (out == expected_out) begin
                $display("| %16b | %11d | %16b | %16b | PASSED  |", inp, shift_value, expected_out, out);
            end else begin
                $display("| %16b | %11d | %16b | %16b | FAILED  |", inp, shift_value, expected_out, out);
            end
        end
    endtask

endmodule