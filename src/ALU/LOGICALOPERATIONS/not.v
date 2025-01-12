module NOT16bit(
    input wire [15:0] inp,  
    input wire clk,         
    input wire rst,         
    output reg [15:0] out
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 16'b0;
        end else begin
            out <= ~inp;
        end
    end

endmodule

module NOT16bit_tb;

    reg [15:0] inp;    // Intrare pe 16 biți
    reg clk, rst;       // Semnal de ceas și reset
    wire [15:0] out;    // Ieșire pe 16 biți

    // Instanțierea modulului NOT16bit
    NOT16bit uut (
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
        rst = 0; // Reset activ
        #15 rst = 1; // Scoaterea resetului după 15 unități de timp

        // Afișarea headerului
        $display("Running tests...");
        $display("-------------------------------------------------------------");
        $display("|   Input    | Expected Output | Output   | Result  |");
        $display("-------------------------------------------------------------");

        // Teste
        run_test(16'b0000000000001011, 16'b1111111111110100); // PASSED
        run_test(16'b1111000000001111, 16'b0000111111110000); // PASSED
        run_test(16'b0000000000000000, 16'b1111111111111111); // PASSED
        run_test(16'b1111111111111111, 16'b0000000000000000); // PASSED

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