module MOD16bit(
    input wire [15:0] num,    
    input wire [15:0] imp,  
    input wire clk,          
    input wire rst,          
    output reg [15:0] result
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            result <= 16'b0;  
        end else if (imp != 16'b0) begin
            result <= num % imp;                               
        end else begin
            result <= 16'b0;     
        end
    end

endmodule


module MOD16bit_tb;

    reg [15:0] num;        // Numeratorul
    reg [15:0] denom;      // Divizorul
    reg clk, rst;          // Semnale de ceas și reset
    wire [15:0] result;    // Rezultatul operației MOD

    // Instanțierea modulului MOD16bit
    MOD16bit uut (
        .num(num),
        .imp(denom),
        .clk(clk),
        .rst(rst),
        .result(result)
    );

    // Generare semnal de ceas
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Perioadă de 10 unități de timp
    end

    // Teste
    initial begin
        rst = 0;  // Reset activ
        #10 rst = 1;  // Scoaterea resetului după 10 unități de timp

        // Afișarea headerului
        $display("Running MOD16bit tests...");
        $display("-------------------------------------------------------------");
        $display("|    Num    |   Denom   | Expected Result | Result |");
        $display("-------------------------------------------------------------");

        // Teste - cu valori binare simple
        run_test(16'b0000000000000001, 16'b0000000000000010, 16'b0000000000000001);  // 1 % 2 = 1
        run_test(16'b0000000000000010, 16'b0000000000000001, 16'b0000000000000000);  // 2 % 1 = 0
        run_test(16'b0000000000000000, 16'b0000000000000001, 16'b0000000000000000);  // 0 % 1 = 0
        run_test(16'b0000000000001000, 16'b0000000000000011, 16'b0000000000000010);  // 8 % 3 = 2

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_num,
        input [15:0] test_denom,
        input [15:0] expected_result
    );
        begin
            num = test_num;
            denom = test_denom;

            // Așteaptă un ciclu de ceas pentru a obține rezultatul
            #15;

            // Verifică dacă rezultatul obținut este același cu rezultatul așteptat
            if (result == expected_result) begin
                $display("| %16b | %16b | %16b  | %16b  | PASSED  |", num, denom, expected_result, result);
            end else begin
                $display("| %16b | %16b | %16b  | %16b  | FAILED  |", num, denom, expected_result, result);
            end
        end
    endtask

endmodule