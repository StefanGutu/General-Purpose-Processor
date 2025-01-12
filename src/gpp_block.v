`include "../ALU/ALU.v"
`include "../cryptografic_core/crypto_block.v"
`include "../GPP/data_mem.v"
`include "../GPP/instr_mem.v"
`include "../GPP/general_p_register.v"
`include "../GPP/SP_PC.v"
`include "../control_unit.v"

//18

module cpu_block(
    input clk,
    input rst,
    input bgn,
    input [15:0] key_inbus,
    output reg c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,
    output reg fin_file_out,
    output reg fin_cript,
    output reg [15:0] key_outbus
);

    //SP,PC and PC Counter wires
    wire [15:0] wire_from_sp;
    wire [15:0] wire_from_pc;
    wire [15:0] wire_from_pc_counter;

    //Wires from general p register
    wire [15:0] wire_from_general_p_reg_registers;
    wire [15:0] wire_from_general_p_reg_acc;

    //Wires from crypto data reg
    wire [15:0] wire_from_crypto_block_reg;

    //Wire key crypto
    wire [15:0] wire_from_crypto_block_key;

    //Wires from data mem
    wire [15:0] wire_from_data_mem_for_reg_x_y;
    wire [15:0] wire_from_data_mem_for_reg_acc;
    wire [15:0] wire_from_data_mem_for_pc;
    wire [15:0] wire_from_data_mem_for_crypto;

    //Wires from instr mem
    wire [15:0] wire_from_instr_mem;    //opcode | reg | address

    //Wires from ALU
    wire [3:0] wire_from_alu_flags;
    wire [15:0] wire_frm_alu_result_to_acc;
    wire [15:0] wire_from_alu_remainder;
    wire wire_from_alu_bout;
    wire wire_from_alu_cout;
    wire wire_from_alu_busy;


    //Independent signals
    wire bin, cin;     

    wire fin_file;
    wire fin_crypto;

    //General p reg
    wire [3:0] wire_from_control_unit_reg_signal;                           //c4,c5,c6,c7
    wire wire_from_control_unit_sta_signal;                                 //c10
    wire wire_from_control_unit_lda_signal;                                 //c11
    //Crypto core reg
    wire wire_from_control_unit_load_data;                                  //c20
    wire wire_from_control_unit_store_data;                                 //c19
    //Data mem
    wire wire_from_control_unit_mem_read;                                   //c9
    wire wire_from_control_unit_mem_write;                                  //c8
    //Crypto core C.U.
    wire wire_from_control_unit_start_crypt;                                //c21
    wire wire_from_control_unit_start_decrypt;                              //c22
    wire wire_from_control_unit_start_execute_crypto;                       //c23
    //Instr mem
    wire wire_from_control_unit_read_file;                                  //c0
    wire wire_from_control_unit_read_memory;                                //c1
    //SP
    wire wire_from_control_unit_push;                                       //c15
    wire wire_from_control_unit_pop;                                        //c16
    //PC
    wire wire_from_control_unit_pc_save_address_from_instr_mem;             //c12
    wire wire_from_control_unit_pc_save_address_from_data_mem;              //c13
    wire wire_from_control_unit_pc_save_address_from_counter;               //c14
    //PC Counter
    wire wire_from_control_unit_increm_pc;                                  //c3
    wire wire_from_control_unit_get_address_from_pc;                        //c2
    //ALU
    wire wire_from_control_unit_start_alu_operation;                        //c17
    wire wire_from_control_unit_mov_enable;                                 //c18


    always @(posedge clk) begin
            //General p reg
            {c4,c5,c6,c7}  <= wire_from_control_unit_reg_signal;                            //c4,c5,c6,c7
            c10 <=  wire_from_control_unit_sta_signal;                                      //c10
            c11 <= wire_from_control_unit_lda_signal;                                       //c11
            //Crypto core reg
            c20 <= wire_from_control_unit_load_data;                                        //c20
            c19 <= wire_from_control_unit_store_data;                                       //c19
            //Data mem
            c9 <= wire_from_control_unit_mem_read;                                          //c9
            c8 <= wire_from_control_unit_mem_write;                                         //c8
            //Crypto core C.U.
            c21 <= wire_from_control_unit_start_crypt;                                      //c21
            c22 <= wire_from_control_unit_start_decrypt;                                    //c22
            c23 <= wire_from_control_unit_start_execute_crypto;                             //c23
            //Instr mem
            c0 <= wire_from_control_unit_read_file;                                         //c0
            c1 <= wire_from_control_unit_read_memory;                                       //c1
            //SP
            c15 <= wire_from_control_unit_push;                                             //c15
            c16 <= wire_from_control_unit_pop;                                              //c16
            //PC
            c12 <= wire_from_control_unit_pc_save_address_from_instr_mem;                   //c12
            c13 <= wire_from_control_unit_pc_save_address_from_data_mem;                    //c13
            c14 <= wire_from_control_unit_pc_save_address_from_counter;                     //c14
            //PC Counter
            c3 <= wire_from_control_unit_increm_pc;                                         //c3
            c2 <= wire_from_control_unit_get_address_from_pc;                               //c2
            //ALU
            c17 <= wire_from_control_unit_start_alu_operation;                              //c17
            c18 <= wire_from_control_unit_mov_enable;                                       //c18

            fin_file_out <= fin_file;
            fin_cript <= fin_crypto;
    end

    StackPointer StackPointer_i(
        .clk(clk), .reset(rst),
        .push(wire_from_control_unit_push), 
        .pop(wire_from_control_unit_pop),
        .sp_out(wire_from_sp)
    );

    pc_counter pc_counter_i(
        .clk(clk), .rst(rst),
        .get_address(wire_from_control_unit_get_address_from_pc), 
        .increment_address(wire_from_control_unit_increm_pc),
        .address_from_pc(wire_from_pc),
        .address_to_pc(wire_from_pc_counter)
    );

    ProgramCounter ProgramCounter_i(
        .clk(clk), .reset(rst),
        .save_address_from_instr_mem(wire_from_control_unit_pc_save_address_from_instr_mem),
        .save_address_from_data_mem(wire_from_control_unit_pc_save_address_from_data_mem),
        .save_address_from_counter(wire_from_control_unit_pc_save_address_from_counter),

        .address_from_instr_mem(wire_from_instr_mem),
        .address_from_data_mem(wire_from_data_mem_for_pc),
        .address_from_counter_pc(wire_from_pc_counter),

        .pc_out(wire_from_pc)
    );


    instr_mem instr_mem_i(
        .clk(clk), .rst(rst),
        .read_file(wire_from_control_unit_read_file), 
        .read_memory(wire_from_control_unit_read_memory),
        .fin_file(fin_file),
        .pos(wire_from_pc[8:0]),
        .return_instr_line(wire_from_instr_mem)
    );


    data_mem data_mem_i(
        .clk(clk),

        .address(wire_from_instr_mem[8:0]),

        .write_data(wire_from_general_p_reg_registers),
        .mem_write(wire_from_control_unit_mem_writ),
        .read_data(wire_from_data_mem_for_reg_x_y),

        .signal_acc_data_write(wire_from_control_unit_sta_signal),
        .acc_data(wire_from_general_p_reg_acc),
        .acc_read_data(wire_from_data_mem_for_reg_acc),

        .signal_pc_data_write(wire_from_control_unit_pop),
        .sp_address(wire_from_sp[8:0]),
        .pc_data(wire_from_pc),
        .pc_read_data(wire_from_data_mem_for_pc),


        .signal_crypto_data_write(fin_crypto),
        .crypto_data(wire_from_crypto_block_reg),
        .crypto_read_data(wire_from_data_mem_for_crypto)
    ); 


    FSM16bit FSM16bit_i(
        .clk(clk),.rst(rst),
        .start(wire_from_control_unit_start_alu_operation),
        .mov_enable(wire_from_control_unit_mov_enable),
        .op_code(wire_from_instr_mem[15:10]),
        .a(wire_from_general_p_reg_acc),
        .b(wire_from_general_p_reg_registers),
        .bin(bin),
        .cin(cin),
        .result(wire_frm_alu_result_to_acc),
        .remainder(wire_from_alu_remainder),
        .bout(wire_from_alu_bout),
        .cout(wire_from_alu_cout),
        .busy(wire_from_alu_busy),
        .overflow_flag(wire_from_alu_flags[0]),
        .carry_flag(wire_from_alu_flags[1]),
        .negative_flag(wire_from_alu_flags[2]),
        .zero_flag(wire_from_alu_flags[3])
    );

    control_unit control_unit_i(
        .clk(clk), .rst(rst),
        .bgn(bgn), 
        .fin_crypto(fin_crypto),
        .fin_file(fin_file),
        .opcode(wire_from_instr_mem[15:10]),
        .flags(wire_from_alu_flags),
        .Alu_busy(wire_from_alu_busy),
        .register(wire_from_instr_mem[9]),

        .reg_signal(wire_from_control_unit_reg_signal),
        .STA_signal(wire_from_control_unit_sta_signal),
        .LDA_signal(wire_from_control_unit_lda_signal),

        .Load_data(wire_from_control_unit_load_data),
        .Store_data(wire_from_control_unit_store_data),

        .mem_read(wire_from_control_unit_mem_read),
        .mem_write(wire_from_control_unit_mem_write),

        .start_crypt(wire_from_control_unit_start_crypt),
        .start_decrypt(wire_from_control_unit_start_decrypt),
        .start_execute_crypto(wire_from_control_unit_start_execute_crypto),

        .read_file(wire_from_control_unit_read_file),
        .read_memory(wire_from_control_unit_read_memory),

        .PUSH(wire_from_control_unit_push),
        .POP(wire_from_control_unit_pop),

        .pc_save_address_from_instr_mem(wire_from_control_unit_pc_save_address_from_instr_mem),
        .pc_save_address_from_data_mem(wire_from_control_unit_pc_save_address_from_data_mem),
        .pc_save_address_from_counter(wire_from_control_unit_pc_save_address_from_counter),

        .Increm_PC(wire_from_control_unit_increm_pc),
        .get_address_from_pc(wire_from_control_unit_get_address_from_pc),

        .Start_ALU_operation(wire_from_control_unit_start_alu_operation),
        .mov_enable(wire_from_control_unit_mov_enable)
    );


    crypto_block crypto_block_i(
        .clk(clk), .rst(rst),
        .key_inbus(key_inbus),
        .data_inbus(wire_from_data_mem_for_crypto),
        .cript_or_decript_signal({wire_from_control_unit_start_decrypt, wire_from_control_unit_start_crypt}),
        .bgn(wire_from_control_unit_start_execute_crypto),
        .fin(fin_crypto),
        .key_outbus(wire_from_crypto_block_key),
        .data_outbus(wire_from_crypto_block_reg)
    );


endmodule



module cpu_block_tb();

    reg clk;
    reg rst;
    reg bgn;
    reg [15:0] key_inbus;
    wire fin_file_out;
    wire fin_cript;
    wire [15:0] key_outbus;


    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;
    wire c16, c17, c18, c19, c20, c21, c22, c23;

    cpu_block uut (
        .clk(clk),
        .rst(rst),
        .bgn(bgn),
        .key_inbus(key_inbus),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4),
        .c5(c5), .c6(c6), .c7(c7), .c8(c8), .c9(c9),
        .c10(c10), .c11(c11), .c12(c12), .c13(c13), .c14(c14),
        .c15(c15), .c16(c16), .c17(c17), .c18(c18), .c19(c19),
        .c20(c20), .c21(c21), .c22(c22), .c23(c23),
        .fin_file_out(fin_file_out),
        .fin_cript(fin_cript),
        .key_outbus(key_outbus)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end


    initial begin

        rst = 1;
        bgn = 0;
        key_inbus = 16'h0000;

        #20 rst = 0;


        #30;
        rst = 1; 
        bgn = 1;
        key_inbus = 16'h1234; 


        #3000;
        $stop; 
    end

endmodule
