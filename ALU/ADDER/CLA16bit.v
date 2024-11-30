`include "ADDER/CLA4bit.v"
`timescale 1ns / 1ps
module CLA16bit(a,b, cin, sum,cout, clk, rst);
input [15:0] a,b;
input wire clk;
input wire rst;
input cin;
output reg [15:0] sum;
output reg cout;
wire c1,c2,c3;

    wire [15:0]temp_sum;
    wire temp_cout;

    CLA4bit cla1 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(temp_sum[3:0]), .cout(c1));
    CLA4bit cla2 (.a(a[7:4]), .b(b[7:4]), .cin(c1), .sum(temp_sum[7:4]), .cout(c2));
    CLA4bit cla3 (.a(a[11:8]), .b(b[11:8]), .cin(c2), .sum(temp_sum[11:8]), .cout(c3));
    CLA4bit cla4 (.a(a[15:12]), .b(b[15:12]), .cin(c3), .sum(temp_sum[15:12]), .cout(temp_cout));

    always @(posedge clk or negedge rst) begin

        if (!rst) begin

            sum <= 16'b0;

        end else begin
            sum <= temp_sum;
            cout <= temp_cout;
        end
        
    end

endmodule

module carry_look_ahead_16bit_tb;
    reg [15:0] a, b;
    reg clk, rst;
    reg cin;
    wire [15:0] sum;
    wire cout;
    reg [16:0] expected_result; // 16 biți pentru sum + 1 bit pentru carry

    // Instanțierea modulului CLA16bit
    CLA16bit uut(
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout), 
        .clk(clk), 
        .rst(rst)
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
        $display("|   A       |   B       | Cin |   Sum     | Cout | Result  |");
        $display("-------------------------------------------------------------");

        // Testele sunt sincronizate cu semnalul de ceas
        run_test(16'd0, 16'd0, 1'd0, 16'd0, 1'd0);
        run_test(16'd14, 16'd1, 1'd0, 16'd15, 1'd0);
        run_test(16'd14, 16'd1, 1'd1, 16'd16, 1'd0);
        run_test(16'd65535, 16'd1, 1'd0, 16'd0, 1'd1);
        run_test(16'd32768, 16'd32768, 1'd0, 16'd0, 1'd1);
        run_test(16'd12345, 16'd54321, 1'd0, 16'd66666, 1'd0);
        run_test(16'd0, 16'd9999, 1'd1, 16'd10000, 1'd0);
        run_test(16'd40000, 16'd30000, 1'd0, 16'd70000, 1'd1);
        run_test(16'd40000, 16'd40000, 1'd1, 16'd14465, 1'd1);
        run_test(16'd32767, 16'd32767, 1'd1, 16'd65535, 1'd0);
        run_test(16'd1, 16'd1, 1'd1, 16'd3, 1'd0);
        run_test(16'd500, 16'd500, 1'd0, 16'd1000, 1'd0);
        run_test(16'd0, 16'd0, 1'd1, 16'd1, 1'd0);
        run_test(16'd9999, 16'd9999, 1'd0, 16'd19998, 1'd0);
        run_test(16'd9999, 16'd9999, 1'd1, 16'd19999, 1'd0);

        $display("-------------------------------------------------------------");
        $stop; // Oprește simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_a, test_b,
        input test_cin,
        input [15:0] expected_sum,
        input expected_cout
    );
        begin
            a = test_a;
            b = test_b;
            cin = test_cin;
            expected_result = {expected_cout, expected_sum}; // Concatenează cout + sum

            @(posedge clk); // Așteaptă frontul crescător al ceasului
            #1; // Mică întârziere pentru propagare

            if ({cout, sum} == expected_result) begin
                $display("| %8d | %8d |  %1d  | %8d |   %1d  | PASSED  |", a, b, cin, sum, cout);
            end else begin
                $display("| %8d | %8d |  %1d  | %8d |   %1d  | FAILED  |", a, b, cin, sum, cout);
            end
        end
    endtask
endmodule