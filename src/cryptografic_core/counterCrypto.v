module Counter(
    input clk,
    input rst,
    input add,
    input show_c,
    input show_d,
    output reg counter_out
);

    reg [2:0] store_counter;


    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            store_counter <= 3'b0;
        end
        else begin
            if(add == 1'b1) begin
                store_counter <= store_counter + 1'b1;
            end
            if(show_c == 1'b1 && store_counter == 3'b100) begin
                counter_out <= 1'b1;
            end
            else if(show_c == 1'b1 && store_counter < 3'b100) begin
                counter_out <= 1'b0;
            end
            if(show_d == 1'b1 && store_counter == 3'b100) begin
                counter_out <= store_counter;
            end
            else if(show_d == 1'b1 && store_counter < 3'b100) begin
                counter_out <= 1'b0;
            end
        end
    end

endmodule