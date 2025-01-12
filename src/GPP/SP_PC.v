module ProgramCounter (
    input clk,
    input reset,

    input [15:0] address_from_instr_mem,            //address from instr memory
    input [15:0] address_from_data_mem,             //address from data memory
    input [15:0] address_from_counter_pc,           //address from PC counter

    input save_address_from_instr_mem,              //signal to save address from instr memory
    input save_address_from_data_mem,               //signal to save address from data memory
    input save_address_from_counter,                //signal to save address from PC counter


    output reg [15:0] pc_out
);

    reg [15:0] address_data;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            address_data <= 16'h0000; 
        end
        else begin
            //For PC Counter
            if (save_address_from_counter == 1'b1) begin
                address_data <= address_from_counter_pc;
            end

            //For Instr memory
            else if (save_address_from_instr_mem == 1'b1) begin
                address_data <= address_from_instr_mem;
            end 

            //For data memory
            else if (save_address_from_data_mem == 1'b1) begin
                address_data <= address_from_data_mem;
            end
            
            else begin
                pc_out <= address_data;
            end
        end     
    end

endmodule


module pc_counter(
    input clk,
    input rst,
    input get_address,
    input increment_address,
    input [15:0] address_from_pc,
    output reg [15:0] address_to_pc
);

    reg [15:0] temp_address;

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            temp_address <= 16'b0;
        end
        else begin
            if(get_address == 1'b1) begin
                temp_address <= address_from_pc;
            end
            else if (increment_address == 1'b1) begin
                temp_address <= temp_address + 1'b1;
            end
            else begin
                address_to_pc <= temp_address;
            end
        end
    end
endmodule


module StackPointer (
    input clk,
    input reset,
    input push,
    input pop,
    output reg [15:0] sp_out
);

    reg [15:0] sp_reg;

    always @(posedge clk or negedge reset) begin
        if (!reset)
            sp_reg <= 16'h018F; 
        else begin
            if (push == 1'b1) begin
                sp_reg <= sp_reg - 16'b0001 ; 
            end
            else if (pop == 1'b1) begin
                sp_reg <= sp_reg + 16'b0001 ; 
            end
            else begin
                sp_out <= sp_reg;
            end
        end
    end
endmodule

