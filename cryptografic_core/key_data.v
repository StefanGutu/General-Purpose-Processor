module key_reg(
    input clk,
    input rst,
    input change_key,send_key
    input [15:0] new_key,
    output [15:0] send_key
);

    reg [15:0] key_reg;

    always @(posedge clk,negedge rst) begin
        if(!rst) begin
            key_reg <= 0;
        end
        else begin
            if(change_key) begin
                key_reg <= new_key;
            end
            else if(send_key) begin
                send_key <= key_reg;
            end
        end
    end

endmodule

//---------------------------------------------------------------------------------------------------------------


//Idee pentru key expansion ar fi sa iau Sbox si sa generez si o pozitie de a sti cu cat sa shiftez siru 
//astfel ca doar cel care face sboxul va sti cu cati biti se shifteaza mereu