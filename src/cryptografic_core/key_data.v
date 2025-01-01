module key_reg(
    input clk,
    input rst,
    input save_key_bus, send_key_bus,
    input get_key, send_key, 
    input [15:0] key_in,
    input [15:0] key_inbus,
    output reg [15:0] key_out,
    output reg [15:0] key_outbus
);

    reg [15:0] key_temp;

    always @(posedge clk,negedge rst) begin
        if(!rst) begin
            key_temp <= 0;
        end
        else begin
            if(save_key_bus == 1'b1) begin
                key_temp <= key_inbus;
            end 
            if(send_key_bus == 1'b1) begin
                key_outbus <= key_temp;
            end
            if(get_key == 1'b1) begin
                key_temp <= key_in;
            end
            if(send_key == 1'b1) begin
                key_out <= key_temp;
            end
        end
    end

endmodule
