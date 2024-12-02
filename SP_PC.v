module ProgramCounter (
    input clk,
    input reset,
    input [15:0] jump_address,
    input jump_enable,
    output reg [15:0] pc_out
);
    always @(posedge clk or negedge reset) begin
        if (!reset)
            pc_out <= 16'h0000; 
        else if (jump_enable)
            pc_out <= jump_address; 
        else
            pc_out <= pc_out + 16'h0001; 
    end
endmodule


module StackPointer (
    input clk,
    input reset,
    input push,
    input pop,
    output reg [15:0] sp_out
);
    always @(posedge clk or negedge reset) begin
        if (!reset)
            sp_out <= 16'h0190; 
        else if (push)
            sp_out <= sp_out - 16'h0001; 
        else if (pop)
            sp_out <= sp_out + 16'h0001; 
    end
endmodule

