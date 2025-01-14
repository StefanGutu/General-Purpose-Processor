module reg_data(
    input clk,
    input rst,
    input save_info_bus, send_info_bus,
    input save_info_reg,
    input [15:0] save_data_reg,
    input [15:0] save_data_bus,
    output reg [15:0] send_data_reg,
    output reg [15:0] send_data_bus
);

    reg [15:0] data;

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            data <= 16'b0;
        end
        else begin
            if(save_info_reg == 1'b1) begin
                data <= save_data_reg;
            end
            else begin
                send_data_reg <= data;
            end
            if(save_info_bus == 1'b1) begin
                data <= save_data_bus;
            end
            if(send_info_bus == 1'b1) begin
                send_data_bus <= data;
            end
        end
    end


endmodule

