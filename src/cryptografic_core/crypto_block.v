`include "../cryptografic_core/counterCrypto.v"
`include "../cryptografic_core/crypto_ControlUnit.v"
`include "../cryptografic_core/inv_mix_columns.v"
`include "../cryptografic_core/key_data.v"
`include "../cryptografic_core/mix_columns.v"
`include "../cryptografic_core/reg_data.v"
`include "../cryptografic_core/S_Box.v"
`include "../cryptografic_core/shift_rows.v"

module crypto_block(
    input clk,
    input rst,
    input [15:0] key_inbus,
    input [15:0] data_inbus,
    input [1:0] cript_or_decript_signal,
    input bgn,
    // output reg c00,c01,c02,c03,c04,c05,c06,c07,c08,c09,c010,c011,c012,c013,c014,c015,c016,c017,c018,c019,c020,c021,
    // output reg [2:0] counter,
    output reg fin,
    output reg [15:0] key_outbus,
    output reg [15:0] data_outbus
);

    //Wire for output
    wire [15:0] wire_key_outbus_cript;
    wire [15:0] wire_key_outbus_decript;
    wire [15:0] wire_data_outbus;



    //data
    reg [15:0] reg_to_reg_data_cript;
    wire [15:0] wire_to_reg_data_decript;
    

    wire [15:0] wire_from_reg_data_cript;
    wire [15:0] wire_from_reg_data_decript;
    wire [15:0] wire_from_reg_data_decript_for_outbus;

    //Key reg
    wire [15:0] wire_from_key_reg_cript;
    wire [15:0] wire_from_key_reg_decript;


    //Xor
    reg [15:0]  xor_decript;
    reg [15:0]  xor_decript_outbus;

    reg [15:0] wire_to_get_out_key;
    wire [15:0] wire_to_get_out_sbox;

    //Sbox
    wire[15:0] wire_from_sbox_data_cript;
    wire[15:0] wire_from_sbox_key_cript;

    wire[15:0] wire_from_sbox_data_decript;
    wire[15:0] wire_from_sbox_key_decript;

    //Shift
    wire [15:0] wire_from_shift_cript;
    wire [15:0] wire_from_shift_decript;
    reg [15:0] wire_to_shift_xor_or_reg;

    //Counter
    wire wire_from_counter;


    //MixCol
    wire [15:0] wire_from_mixcol_cript;
    wire [15:0] wire_from_mixcol_decript;
    

    //Signals
    wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21;

    always @(posedge clk) begin
        // {c00,c01,c02,c03,c04,c05,c06,c07,c08,c09,c010,c011,c012,c013,c014,c015,c016,c017,c018,c019,c020,c021} <= {c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21};
        // counter <= wire_from_counter;
        fin <= c21;
    end

    //Control Unit ----------------------------------------------------------------

    ControlUnit ControlUnit_i(
        .clk(clk), .rst(rst), 
        .cript_or_decript(cript_or_decript_signal),
        .bgn(bgn),
        .fin_counter(wire_from_counter),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4),
        .c5(c5), .c6(c6), .c7(c7), .c8(c8), .c9(c9),
        .c10(c10), .c11(c11), .c12(c12), .c13(c13), .c14(c14),
        .c15(c15), .c16(c16), .c17(c17), .c18(c18), .c19(c19), .c20(c20), .c21(c21)
    );

    //Key reg ---------------------------------------------------------------------


    //Cript
    key_reg key_reg_cript(
        .clk(clk), .rst(rst), 
        .save_key_bus(c0), .send_key_bus(c20),
        .get_key(c8),
        .key_in(wire_from_sbox_key_cript), .key_inbus(key_inbus),
        .key_out(wire_from_key_reg_cript), .key_outbus(wire_key_outbus_cript)
    );


    //Decript
    key_reg key_reg_decript(
        .clk(clk), .rst(rst), 
        .save_key_bus(c0), .send_key_bus(c20),
        .get_key(c15),
        .key_in(wire_from_sbox_key_decript), .key_inbus(key_inbus),
        .key_out(wire_from_key_reg_decript), .key_outbus(wire_key_outbus_decript)
    );

    always @(posedge clk) begin
        // if(c8 == 1'b1) begin
        //     $monitor("At time %0t:c8 key_cript = %h", $time, wire_from_sbox_key_cript);
        // end
        // if (c15) begin
        //     $monitor("At time %0t: key_decript = %h", $time, wire_from_sbox_key_decript);
        // end
        if(cript_or_decript_signal == 2'b01 && c21 == 1'b1) begin
            key_outbus <= wire_key_outbus_cript;
            $display("At time %0t:cript_or_decript_signal:%b | wire_key_outbus_cript = %h\n", $time,cript_or_decript_signal, wire_key_outbus_cript);
        end
        if(cript_or_decript_signal == 2'b10 && c20 == 1'b1) begin
            key_outbus <= wire_key_outbus_decript;
            $display("At time %0t:cript_or_decript_signal:%b | wire_key_outbus_decript = %h\n", $time,cript_or_decript_signal, wire_to_get_out_sbox);
        end
    end


    //XOR operation between key and data ------------------------------------------------


    always @(posedge clk) begin
        //Cript
        if(c1 == 1'b1) begin   
            reg_to_reg_data_cript <= data_inbus ^ key_inbus;
            // reg_to_reg_data_cript <= data_inbus;
        end
        if(c8 == 1'b1 && wire_from_counter == 3'b100) begin
            reg_to_reg_data_cript <= wire_from_shift_cript ^ wire_from_sbox_key_cript;
            // reg_to_reg_data_cript <= wire_from_shift_cript;
        end
        if(c8 == 1'b1 && wire_from_counter < 3'b100) begin
            reg_to_reg_data_cript <= wire_from_mixcol_cript ^ wire_from_sbox_key_cript;
            // reg_to_reg_data_cript <= wire_from_mixcol_cript;
        end
        //Decript
        if(c9 == 1'b1) begin
            wire_to_shift_xor_or_reg <= data_inbus ^ key_inbus;
            // wire_to_shift_xor_or_reg <= data_inbus;
        end 
        if(c15 == 1'b1) begin
            xor_decript <= wire_from_sbox_key_decript ^ wire_from_sbox_data_decript;
            // xor_decript <= wire_from_sbox_data_decript;
        end 
        if(c18 == 1'b1) begin
            xor_decript_outbus <= wire_to_get_out_sbox ^ wire_from_sbox_data_decript;
            // xor_decript_outbus <= wire_from_sbox_data_decript;
        end
        if(c10 == 1'b1) begin
            wire_to_shift_xor_or_reg <= wire_from_mixcol_decript;
        end
        if(c12 == 1'b1) begin
            wire_to_get_out_key <= wire_from_key_reg_decript;
        end
    end

    always @(posedge clk) begin
        // if (c0) begin
        //     $display("At time %0t: data_in = %h | key_in = %h",$time,data_inbus, key_inbus);
        // end
        if(cript_or_decript_signal == 2'b10 && c20 == 1'b1) begin
            data_outbus <= xor_decript_outbus;
            $display("At time %0t: wire_data_outbus_decript = %h", $time, xor_decript_outbus);

        end
        if(cript_or_decript_signal == 2'b01 && c20 == 1'b1) begin
            data_outbus <= reg_to_reg_data_cript;
            $display("At time %0t: wire_data_outbus_cript = %h", $time, reg_to_reg_data_cript);
        end
    end


    // always @(posedge clk) begin
    //     //Cript
    //     if (c0) begin
    //         $display("At time %0t: data_in = %h | key_in = %h",$time,data_inbus, key_inbus);
    //     end
    //     if (c2) begin
    //         $display("At time %0t: reg_to_reg_data_cript = %h",$time,reg_to_reg_data_cript);
    //     end
    //     if (c3) begin
    //         $display("At time %0t: reg_data = %h",$time,wire_from_reg_data_cript);
    //     end
    //     if (c4) begin
    //         $display("At time %0t: subbox = %h",$time,wire_from_sbox_data_cript);
    //     end
    //     if (c7) begin
    //         $display("At time %0t: shift = %h",$time,wire_from_shift_cript);
    //         $display("At time %0t: mixcol = %h",$time,wire_from_mixcol_cript);
    //     end


    //     //Decript
    //     if (c11) begin
    //         $display("At time %0t: xor_sau_mixcol = %h",$time,wire_to_shift_xor_or_reg);
    //     end
    //     if (c12) begin
    //         $display("At time %0t: shift = %h",$time,wire_from_shift_decript);
    //     end
    //     if (c5 == 1'b1 || c17 == 1'b1) begin
    //         $display("At time %0t: sbox_decript = %h",$time,wire_from_sbox_data_decript);
    //     end
    //     if (c16) begin
    //         $display("At time %0t: xor_decript = %h",$time,xor_decript);
    //     end
    //     if (c10) begin
    //         $display("At time %0t: mixcol_decript = %h",$time,wire_from_mixcol_decript);
    //     end
    //     if (c20) begin
    //         $display("At time %0t: xor_decript_outbus = %h",$time,xor_decript_outbus);
    //     end
    // end

    //reg with data ------------------------------------------------------------

    //Cript
    reg_data reg_data_cript(
        .clk(clk), .rst(rst), 
        .save_info_bus(c0), .send_info_bus(c19),
        .save_info_reg(c2),
        .save_data_reg(reg_to_reg_data_cript), .save_data_bus(data_inbus),
        .send_data_reg(wire_from_reg_data_cript), .send_data_bus(wire_data_outbus)
    );

    //Decript
    reg_data reg_data_decript(
        .clk(clk), .rst(rst), 
        .save_info_bus(c0), .send_info_bus(c17),
        .save_info_reg(c10),
        .save_data_reg(wire_from_mixcol_decript), .save_data_bus(data_inbus),
        .send_data_reg(wire_from_reg_data_decript), .send_data_bus(wire_from_reg_data_decript_for_outbus)
    );


    //Sbox ---------------------------------------------------------------------

    //Cript data
    S_Box S_Box_cript_data_i(
        .clk(clk), .rst(rst),
        .cript(c3), .decript(1'b0),
        .old_val(wire_from_reg_data_cript[15:8]),
        .new_val(wire_from_sbox_data_cript[15:8])
    );

    S_Box S_Box_cript_data_ii(
        .clk(clk), .rst(rst),
        .cript(c3), .decript(1'b0),
        .old_val(wire_from_reg_data_cript[7:0]),
        .new_val(wire_from_sbox_data_cript[7:0])
    );

    //Cript key
    S_Box S_Box_cript_key_i(
        .clk(clk), .rst(rst),
        .cript(c7), .decript(1'b0),
        .old_val(wire_from_key_reg_cript[15:8]),
        .new_val(wire_from_sbox_key_cript[15:8])
    );

    S_Box S_Box_cript_key_ii(
        .clk(clk), .rst(rst),
        .cript(c7), .decript(1'b0),
        .old_val(wire_from_key_reg_cript[7:0]),
        .new_val(wire_from_sbox_key_cript[7:0])
    );

    //Decript data
    S_Box S_Box_decript_data_i(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c12),
        .old_val(wire_from_shift_decript[15:8]),
        .new_val(wire_from_sbox_data_decript[15:8])
    );

    S_Box S_Box_decript_data_ii(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c12),
        .old_val(wire_from_shift_decript[7:0]),
        .new_val(wire_from_sbox_data_decript[7:0])
    );

    //Decript key
    S_Box S_Box_decript_key_i(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c14),
        .old_val(wire_from_key_reg_decript[15:8]),
        .new_val(wire_from_sbox_key_decript[15:8])
    );

    S_Box S_Box_decript_key_ii(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c14),
        .old_val(wire_from_key_reg_decript[7:0]),
        .new_val(wire_from_sbox_key_decript[7:0])
    );

    S_Box S_Box_decript_key_2i(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c17),
        .old_val(wire_to_get_out_key[15:8]),
        .new_val(wire_to_get_out_sbox[15:8])
    );

    S_Box S_Box_decript_key_2ii(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c17),
        .old_val(wire_to_get_out_key[7:0]),
        .new_val(wire_to_get_out_sbox[7:0])
    );



    //Shift --------------------------------------------------------------------

    //Cript
    shift_rows shift_rows_cript(
        .clk(clk), .rst(rst),
        .cript(c4), .decript(1'b0),
        .data_in(wire_from_sbox_data_cript),
        .data_out(wire_from_shift_cript)
    );

    //Decript
    shift_rows shift_rows_decript(
        .clk(clk), .rst(rst),
        .cript(1'b0), .decript(c11),
        .data_in(wire_to_shift_xor_or_reg),
        .data_out(wire_from_shift_decript)
    );

    //Counter ----------------------------------------------------------------------------


    Counter Counter_i(
        .clk(clk), .rst(rst), 
        .add(c5), .show_c(c4), .show_d(c12), .counter_out(wire_from_counter)
    );

    

    //MixCol -----------------------------------------------------------------------------

    //Cript
    mix_columns_16 mix_columns_16_cript_i(
        .clk(clk), .rst(rst),
        .mix_col(c6),
        .data_in(wire_from_shift_cript),
        .data_out(wire_from_mixcol_cript)
    );

    //Decript
    inv_mix_columns_16 inv_mix_columns_16_i(
        .clk(clk), .rst(rst),
        .inv_mix_col(c16),
        .data_in(xor_decript),
        .data_out(wire_from_mixcol_decript)
    );


endmodule


module crypto_block_tb();


    reg clk;
    reg rst;
    reg [15:0] key_inbus;
    reg [15:0] data_inbus;
    reg [1:0] cript_or_decript_signal;
    reg bgn;

    wire [15:0] key_outbus;
    wire [15:0] data_outbus;
    wire [2:0] counter;
    wire c00,c01,c02,c03,c04,c05,c06,c07,c08,c09,c010,c011,c012,c013,c014,c015,c016,c017,c018,c019,c020,c021;

    crypto_block uut (
        .clk(clk),
        .rst(rst),
        .cript_or_decript_signal(cript_or_decript_signal),
        .bgn(bgn),
        .key_inbus(key_inbus),
        .data_inbus(data_inbus),
        .key_outbus(key_outbus),
        .data_outbus(data_outbus),
        .counter(counter),
        .c00(c00), .c01(c01), .c02(c02), .c03(c03), .c04(c04),
        .c05(c05), .c06(c06), .c07(c07), .c08(c08), .c09(c09),
        .c010(c010), .c011(c011), .c012(c012), .c013(c013), .c014(c014),
        .c015(c015), .c016(c016), .c017(c017), .c018(c018), .c019(c019), .c020(c020), .c021(c021)
    );


    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end


    initial begin
        rst = 1;
        bgn = 0;
        cript_or_decript_signal = 2'b01;
        data_inbus = 16'h59B3;
        key_inbus =  16'h1325;

        #50;
        rst = 0;

        
        #50;
        rst = 1;
        bgn = 1;

        #200;
        bgn = 0;
        #1600;


        cript_or_decript_signal = 2'b10;
        data_inbus = 16'h36cb;
        key_inbus = 16'ha058;

        #50;
        rst = 0;
        #50;

        
        #50;
        rst = 1;
        bgn = 1;

        #200;
        bgn = 0;
        #1600;

        cript_or_decript_signal = 2'b01;
        data_inbus = 16'h36cb;
        key_inbus = 16'ha058;

        #50;
        rst = 0;
        #50;

        
        #50;
        rst = 1;
        bgn = 1;

        #200;
        bgn = 0;
        #1600;


        cript_or_decript_signal = 2'b10;
        data_inbus = 16'h5cfe;
        key_inbus = 16'h83e6;

        #50;
        rst = 0;
        #50;

        
        #50;
        rst = 1;
        bgn = 1;

        #200;
        bgn = 0;
        #1600;

        $stop;
    end


endmodule