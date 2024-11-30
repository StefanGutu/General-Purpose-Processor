`timescale 1ns / 1ps
module TST16bit (
    input wire [15:0] inp1,      
    input wire [15:0] inp2,     
    input wire clk,              
    input wire rst,              
    output reg zero_flag,        
    output reg negative_flag,    
    output reg carry_flag,      
    output reg overflow_flag     
);


    reg [15:0] and_result;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            zero_flag <= 0;
            negative_flag <= 0;
            carry_flag <= 0;
            overflow_flag <= 0;
        end else begin
            and_result <= inp1 & inp2;
            zero_flag <= (and_result == 16'b0);
            negative_flag <= and_result[15];
            carry_flag <= carry_flag;
            overflow_flag <= overflow_flag;
        end
    end
endmodule

module TST16bit_tb;

    reg [15:0] inp1;  // Primul operand
    reg [15:0] inp2;  // Al doilea operand
    reg clk, rst;      // Semnale de ceas și reset
    wire zero_flag;    // Zero flag
    wire negative_flag; // Negative flag
    wire carry_flag;   // Carry flag
    wire overflow_flag; // Overflow flag

    // Instanțierea modulului TST16bit
    TST16bit uut (
        .inp1(inp1),
        .inp2(inp2),
        .clk(clk),
        .rst(rst),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );

    // Generare semnal de ceas
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Perioadă de 10 unități de timp
    end

    // Teste
    initial begin
        rst = 0;  // Reset activ
        #15 rst = 1;  // Scoaterea resetului după 15 unități de timp

        // Afișarea headerului
        $display("Running TST16bit tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input1   |   Input2   | Zero | Negative | Carry | Overflow |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'b0000000000001100, 1'b0, 1'b0, 1'b0, 1'b0); // Așteptat: Zero=0, Negative=0
        run_test(16'b0000000000000000, 16'b0000000000000000, 1'b1, 1'b0, 1'b0, 1'b0); // Așteptat: Zero=1, Negative=0
        run_test(16'b1111111111111111, 16'b1111111111111111, 1'b0, 1'b1, 1'b0, 1'b0); // Așteptat: Zero=0, Negative=1
        run_test(16'b1010101010101010, 16'b0101010101010101, 1'b0, 1'b0, 1'b0, 1'b0); // Așteptat: Zero=0, Negative=0

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in1,
        input [15:0] test_in2,
        input expected_zero,
        input expected_negative,
        input expected_carry,
        input expected_overflow
    );
        begin
            inp1 = test_in1;
            inp2 = test_in2;

            // Așteaptă un ciclu de ceas pentru a obține rezultatul
            #10;

            if (zero_flag == expected_zero && negative_flag == expected_negative &&
                carry_flag == expected_carry && overflow_flag == expected_overflow) begin
                $display("| %16b | %16b |  %b   |    %b    |   %b  |    %b    | PASSED  |", inp1, inp2, zero_flag, negative_flag, carry_flag, overflow_flag);
            end else begin
                $display("| %16b | %16b |  %b   |    %b    |   %b  |    %b    | FAILED  |", inp1, inp2, zero_flag, negative_flag, carry_flag, overflow_flag);
            end
        end
    endtask

endmodule

