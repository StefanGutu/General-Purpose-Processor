`include "../ALU/SUBSTRACTOR/FSC4bit.v"
module FullSubtractor16bit(a, b, bin, diff, bout, clk, rst);
    input [15:0] a, b;     
    input wire clk;
    input wire rst;
    input bin;             
    output reg [15:0] diff;    
    output reg bout;           

    wire b1, b2, b3;  
    wire [15:0] temp_diff;
    wire temp_bout;

    FSC4bit fs0 (.a(a[3:0]),   .b(b[3:0]),   .bin(bin),   .diff(temp_diff[3:0]),   .bout(b1));
    FSC4bit fs1 (.a(a[7:4]),   .b(b[7:4]),   .bin(b1),    .diff(temp_diff[7:4]),   .bout(b2));
    FSC4bit fs2 (.a(a[11:8]),  .b(b[11:8]),  .bin(b2),    .diff(temp_diff[11:8]),  .bout(b3));
    FSC4bit fs3 (.a(a[15:12]), .b(b[15:12]), .bin(b3),    .diff(temp_diff[15:12]), .bout(temp_bout));

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            diff <= 16'b0;
            bout <= 0;
        end else begin
            diff <= temp_diff;
            bout <= temp_bout;
        end
    end
endmodule


module FullSubtractor16bit_tb;
    reg [15:0] a, b;
    reg bin, clk, rst;
    wire [15:0] diff;
    wire bout;
    reg [16:0] expected_result; // Include carry out (bout) și diff

    // Instanțiere modul de testat
    FullSubtractor16bit uut (
        .a(a),
        .b(b),
        .bin(bin),
        .diff(diff),
        .bout(bout),
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
        rst = 0; 
        #10 rst = 1; // Activare reset după 10 unități de timp

        $display("Running tests...");
        $display("-------------------------------------------------------------------");
        $display("|      A       |      B       | Bin |      Diff      | Bout | Result |");
        $display("-------------------------------------------------------------------");

        // Lista testelor
        run_test(16'd10, 16'd5, 1'b0, 16'd5, 1'b0);   // PASSED
        run_test(16'd50, 16'd20, 1'b0, 16'd30, 1'b0); // PASSED
        run_test(16'd100, 16'd100, 1'b0, 16'd0, 1'b0); // PASSED
        run_test(16'd0, 16'd1, 1'b0, 16'd65535, 1'b1); // PASSED
        run_test(16'd1000, 16'd500, 1'b1, 16'd499, 1'b0); // PASSED
        run_test(16'd32768, 16'd32768, 1'b0, 16'd0, 1'b0); // PASSED
        run_test(16'd65535, 16'd1, 1'b0, 16'd65534, 1'b0); // PASSED
        run_test(16'd0, 16'd0, 1'b1, 16'd65535, 1'b1); // PASSED
        run_test(16'd2357, 16'd9832, 1'b0, 16'd58061, 1'b1); // PASSED
        run_test(16'd6000, 16'd1000, 1'b1, 16'd4999, 1'b0); // PASSED
        run_test(16'd65535, 16'd65535, 1'b0, 16'd0, 1'b0); // PASSED
        run_test(16'd12345, 16'd54321, 1'b0, 16'd23560, 1'b1); // FAILED
        run_test(16'd4000, 16'd4000, 1'b0, 16'd0, 1'b0); // PASSED
        run_test(16'd1, 16'd2, 1'b1, 16'd65534, 1'b1); // FAILED
        run_test(16'd50000, 16'd25000, 1'b0, 16'd25000, 1'b0); // PASSED

        $display("-------------------------------------------------------------------");
        $stop; // Termină simularea
    end

    // Task pentru rularea fiecărui test
    task run_test(
        input [15:0] test_a,
        input [15:0] test_b,
        input test_bin,
        input [15:0] expected_diff,
        input expected_bout
    );
        begin
            a = test_a;
            b = test_b;
            bin = test_bin;
            expected_result = {expected_bout, expected_diff}; // Bout și diferența așteptată

            @(posedge clk); // Așteaptă frontul crescător al semnalului de ceas
            #1; // Mică întârziere pentru propagare

            if ({bout, diff} == expected_result) begin
                $display("| %12d | %12d |  %1b  | %12d |   %1b  | PASSED |", a, b, bin, diff, bout);
            end else begin
                $display("| %12d | %12d |  %1b  | %12d |   %1b  | FAILED |", a, b, bin, diff, bout);
            end
        end
    endtask
endmodule