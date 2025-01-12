module MOV16bit(
    input wire [15:0] src,     
    input wire clk,             
    input wire rst,            
    input wire mov_enable,     
    output reg [15:0] dest
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            dest <= 16'b0;
        end else if (mov_enable) begin
            dest <= src;  
        end
    end

endmodule

module MOV16bit_tb;

    reg [15:0] src;      
    reg clk, rst;       
    reg mov_enable;     
    wire [15:0] dest;     

    MOV16bit uut (
        .src(src),
        .clk(clk),
        .rst(rst),
        .mov_enable(mov_enable),
        .dest(dest)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        rst = 0;         
        #10 rst = 1;       

        $display("Running MOV16bit tests...");
        $display("-------------------------------------------------------------");
        $display("|    Src    |   Dest    | MOV Enable | Expected Dest |");
        $display("-------------------------------------------------------------");

       
        run_test(16'b0000000000001010, 16'b0000000000000000, 1'b1, 16'b0000000000001010);
        run_test(16'b1111000000001100, 16'b0000000000000000, 1'b1, 16'b1111000000001100); 
        run_test(16'b0000000000000001, 16'b1111111111111111, 1'b0, 16'b1111111111111111); 
        run_test(16'b1111111111111111, 16'b0000000000000000, 1'b1, 16'b1111111111111111); 

        $display("-------------------------------------------------------------");
        $stop; 
    end

    
    task run_test(
        input [15:0] test_src,
        input [15:0] test_dest,
        input test_mov_enable,
        input [15:0] expected_dest
    );
        begin
            src = test_src;
            mov_enable = test_mov_enable;

            
            #10;

            if (dest == expected_dest) begin
                $display("| %16b | %16b |     %b     |  %16b  | PASSED  |", src, test_dest, mov_enable, expected_dest);
            end else begin
                $display("| %16b | %16b |     %b     |  %16b  | FAILED  |", src, test_dest, mov_enable, expected_dest);
            end
        end
    endtask

endmodule