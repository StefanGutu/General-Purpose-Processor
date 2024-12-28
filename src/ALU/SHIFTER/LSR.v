`timescale 1ns / 1ps
module LSR16bit(
    input wire [15:0] inp,
    input wire [15:0] shift_value, 
    input wire clk,          
    input wire rst,          
    output reg [15:0] out
);

    wire is_inp_negative;

    assign is_inp_negative = inp[15];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0;
        end else begin
            if (is_inp_negative) begin
                out <= $signed(inp) >>> shift_value[3:0];
            end else begin
                out <= inp >> shift_value[3:0];
            end
        end
    end

endmodule


module LSR16bit_tb;

    reg [15:0] inp;           // Intrare pe 16 biți
    reg [15:0] shift_value;    // Valoarea de deplasare (4 biți, maxim 15 poziții)
    reg clk, rst;             // Semnale de ceas și reset
    wire [15:0] out;          // Ieșire pe 16 biți

    // Instanțierea modulului LSR16bit
    LSR16bit uut (
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

        $display("Running tests...");
        $display("-------------------------------------------------------------");
        $display("|      Input      | Shift Value | Expected Output |   Output   | Result  |");
        $display("-------------------------------------------------------------");

        // Teste pentru numere pozitive (deplasare logică dreapta)
        run_test(16'b0000000000001011, 16'd1, 16'b0000000000000101); // LSR: 11 >> 1 = 5
        run_test(16'b0000000000110000, 16'd2, 16'b0000000000001100); // LSR: 48 >> 2 = 12
        run_test(16'b0000111100000000, 16'd4, 16'b0000000011110000); // LSR: 3840 >> 4 = 240

        // Teste pentru numere negative (deplasare aritmetică dreapta)
        run_test(16'b1000000000001011, 16'd1, 16'b1100000000000101); // ASR: -32757 >> 1 = -16379
        run_test(16'b1111111110000000, 16'd3, 16'b1111111111110000); // ASR: -128 >> 3 = -16
        run_test(16'b1000111100000000, 16'd4, 16'b1111100011110000); // ASR: -29248 >> 4 = -1828

        // Teste cu `shift_value = 0` (fără deplasare)
        run_test(16'b0000000000001011, 16'd0, 16'b0000000000001011); // Fără schimbare
        run_test(16'b1111111111111111, 16'd0, 16'b1111111111111111); // Fără schimbare (număr negativ)

        // Teste cu deplasare maximă (15 poziții)
        run_test(16'b0000000000110000, 16'd15, 16'b0000000000000000); // LSR: 48 >> 15 = 0
        run_test(16'b1000000000000001, 16'd15, 16'b1111111111111111); // ASR: -32767 >> 15 = -1

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in,
        input [15:0] test_shift,
        input [15:0] expected_out
    );
        begin
            inp = test_in;
            shift_value = test_shift;

            // Așteaptă pentru a obține rezultatul
            #10;

            if (out == expected_out) begin
                $display("| %16b |     %4b     | %16b | %16b | PASSED  |", inp, shift_value, expected_out, out);
            end else begin
                $display("| %16b |     %4b     | %16b | %16b | FAILED  |", inp, shift_value, expected_out, out);
            end
        end
    endtask

endmodule