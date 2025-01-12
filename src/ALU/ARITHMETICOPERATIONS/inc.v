module INC16bit(
    input wire [15:0] inp, 
    input wire clk,          
    input wire rst,        
    output reg [15:0] out
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0; 
        end else begin
            out <= inp + 1;  
        end
    end

endmodule

module INC16bit_tb;

    reg [15:0] inp;   // Intrarea pe 16 biți
    reg clk, rst;      // Semnalele de ceas și reset
    wire [15:0] out;   // Ieșirea pe 16 biți

    // Instanțierea modulului INC16bit
    INC16bit uut (
        .inp(inp),
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
        rst = 0;  // Reset activ
        #15 rst = 1;  // Scoaterea resetului după 15 unități de timp

        // Afișarea headerului
        $display("Running INC16bit tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input    | Expected Output | Output   | Result  |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'b0000000000001100); // Așteptat: 12 (11 + 1)
        run_test(16'b1111111111111111, 16'b0000000000000000); // Așteptat: 0 (overflow)
        run_test(16'b0000000000000000, 16'b0000000000000001); // Așteptat: 1
        run_test(16'b0000000000001111, 16'b0000000000010000); // Așteptat: 16 (15 + 1)

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_in,
        input [15:0] expected_out
    );
        begin
            inp = test_in;

            // Așteaptă pentru a obține rezultatul
            #10;

            if (out == expected_out) begin
                $display("| %16b | %16b | %16b | PASSED  |", inp, expected_out, out);
            end else begin
                $display("| %16b | %16b | %16b | FAILED  |", inp, expected_out, out);
            end
        end
    endtask

endmodule