//Idea pt reg8 ar fi ca pentru 
//input sa am un MUX cu cele 3 date de intrare (reg_data,SBOX,MIXCOL)
//output sa fie un DEMUX cu semnalu din reg8 si sa aleaga unde sa il transmita mai departe

module reg8_data(
    input clk,
    input rst,
    input save_info_reg8, send_info_reg8
    input [7:0] save_data_reg8,
    output reg [7:0] send_data_reg8
);

    reg [15:0] data;

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            data <= 8'b0;
        end
        else begin
            if(save_info_reg8) begin
                data <= save_data_reg8;
            end 
            else if(send_info_reg8) begin
                send_data_reg8 <= data;
            end
        end
    end

endmodule


//---------------------------------------------------------------------------------------------------------------

module reg_data(
    input clk,
    input rst,
    input save_info, send_info                  // this are signal to save and read data that are saved in the register
    input [15:0] save_data,
    output reg [15:0] send_data
);

    reg [15:0] data;

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            data <= 16'b0;
        end
        else begin
            if(save_info) begin                 //when save_info singal is active will save the info in data
                data <= save_data;
            end
            else if(send_info) begin            //when send_info singal is active will send the information out
                send_data <= data;
            end
        end
    end


endmodule

