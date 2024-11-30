`timescale 1ns / 1ps
module LSL16bit(
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
            out <= inp << shift_value[3:0];
        end
    end

endmodule

module LSL16bit_tb;
    reg [15:0] inp;            // Intrare pe 16 biți
    reg [15:0] shift_value;    // Valoare de deplasare pe 16 biți
    reg clk, rst;              // Semnale de ceas și reset
    wire [15:0] out;           // Ieșire pe 16 biți

    // Instanțierea modulului LSL16bit
    LSL16bit uut (
        .inp(inp),
        .shift_value(shift_value),
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Generare semnal de ceas
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Semnal de ceas cu perioadă de 10 unități
    end

    // Teste
    initial begin
        rst = 0;  // Reset activ
        #10 rst = 1;  // Scoatem resetul după 10 unități de timp

        $display("Running tests...");
        $display("-------------------------------------------------------------");
        $display("|      Input      | Shift Value | Expected Output |   Output   | Result  |");
        $display("-------------------------------------------------------------");

        // Teste pentru numere pozitive
        run_test(16'b0000000000001011, 16'b0000000000000001, 16'b0000000000010110); // 11 << 1 = 22
        run_test(16'b0000000000110000, 16'b0000000000000010, 16'b0000000011000000); // 48 << 2 = 192
        run_test(16'b0000111100000000, 16'b0000000000000100, 16'b1111000000000000); // 3840 << 4 = 61440

        // Teste pentru numere negative
        run_test(16'b1000000000001011, 16'b0000000000000001, 16'b0000000000010110); // -32757 << 1 (modulo)
        run_test(16'b1111111110000000, 16'b0000000000000011, 16'b1111100000000000); // -128 << 3 = -1024 (în mod direct)
        run_test(16'b1000111100000000, 16'b0000000000000100, 16'b1111000000000000); // -29248 << 4

        // Teste fără deplasare
        run_test(16'b0000000000001011, 16'b0000000000000000, 16'b0000000000001011); // Fără schimbare
        run_test(16'b1111111111111111, 16'b0000000000000000, 16'b1111111111111111); // Fără schimbare (număr negativ)

        // Teste cu deplasare maximă (15 poziții)
        run_test(16'b0000000000110000, 16'b0000000000001111, 16'b0000000000000000); // 48 << 15 = 0 (se pierde tot)
        run_test(16'b1000000000000001, 16'b0000000000001111, 16'b0000000000000000); // -32767 << 15 = 0 (trunchiat)

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_inp,
        input [15:0] test_shift,
        input [15:0] expected_out
    );
        begin
            inp = test_inp;
            shift_value = test_shift;

            @(posedge clk); // Așteptăm o secvență de ceas
            #1; // Mică întârziere pentru propagare

            if (out == expected_out) begin
                $display("| %16b |     %4b     | %16b | %16b | PASSED  |", inp, shift_value[3:0], expected_out, out);
            end else begin
                $display("| %16b |     %4b     | %16b | %16b | FAILED  |", inp, shift_value[3:0], expected_out, out);
            end
        end
    endtask

endmodule





