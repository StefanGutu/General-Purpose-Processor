module ControlUnit(
    input clk,
    input rst,
    input [1:0] cript_or_decript,
    input bgn,
    input [2:0] fin_counter,
    output reg c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21
);

    reg [5:0] next_state, reg_state;

    parameter IDLE =                    6'b000000;
    parameter START =                   6'b000001;
    parameter GET_DATA_KEY =            6'b000010;
    parameter CHECK_TYPE =              6'b000011;
    
    parameter CRIPT_FIRST_XOR =         6'b000100;
    parameter DELAY_CRIPT_FIRST_XOR =   6'b100100;

    parameter CRIPT_SAVE_REG =          6'b000101;
    parameter DELAY_CRIPT_SAVE_REG =    6'b100101;

    parameter CRIPT_SUBBOX =            6'b000110;
    parameter DELAY_CRIPT_SUBBOX =      6'b100110;

    parameter CRIPT_SHIFT =             6'b000111;
    parameter DELAY_CRIPT_SHIFT =       6'b100111;

    parameter CRIPT_CHECK_COUNTER =     6'b001000;

    parameter CRIPT_ADD_COUNTER =       6'b001001;

    parameter CRIPT_MIXCOL =            6'b001010;
    parameter DELAY_CRIPT_MIXCOL =      6'b101010;

    parameter CRIPT_SUBBOX_KEY =        6'b001011;
    parameter DELAY_CRIPT_SUBBOX_KEY =  6'b101011;

    parameter CRIPT_XOR_KEY =           6'b001100;
    parameter DELAY_CRIPT_XOR_KEY =     6'b101100;



    parameter DECRIPT_SAVE_REG =        6'b001101;
    parameter DELAY_DECRIPT_SAVE_REG =  6'b101101;

    parameter DECRIPTFIRST_XOR =        6'b001110;
    parameter DELAY_DECRIPT_F_XOR =     6'b101110;

    parameter DECRIPT_SHIFT =           6'b001111;
    parameter DELAY_DECRIPT_SHIFT =     6'b101111;

    parameter DECRIPT_SUBBOX =          6'b010000;
    parameter DELAY_DECRIPT_SUBBOX =    6'b110000;

    parameter DECRIPT_CHECK_COUNT =     6'b010001;

    parameter DECRIPT_SUB_COUNTER =     6'b010010;

    parameter DECRIPT_SUBBOX_KEY =      6'b010011;
    parameter DELAY_DECRIPT_SUBB_KEY =  6'b110011;

    parameter DECRIPT_XOR_KEY =         6'b010100;
    parameter DELAY_DECRIPT_XOR_KEY =   6'b110100;

    parameter DECRIPT_MIXCOL =          6'b010101;
    parameter DELAY_DECRIPT_MIXCOL =    6'b110101;

    parameter DECRIPT_LST_SUB_KEY =     6'b010110;
    parameter DELAY_DECRIPT_LST_S_KEY = 6'b110110;

    parameter DECRIPT_LST_XOR_KEY =     6'b010111;
    parameter DELAY_DECRIPT_LST_X_KEY = 6'b110111;

    parameter CRIPT_CHECK_END     =     6'b011000;
    parameter OUT_DATA            =     6'b011001;
    parameter OUT_KEY             =     6'b011010;
    parameter FIN                 =     6'b011011;



    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            reg_state <= IDLE;
            {c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21} <= 22'b0;
        end
        else begin
            reg_state <= next_state;
        end
    end


    always @(*) begin
        next_state = reg_state;

        case(reg_state)

            IDLE : begin
                if(bgn == 1'b0) begin
                    next_state <= IDLE;
                end
                else if(bgn == 1'b1) begin
                    next_state <= START;
                end
            end
            START : begin
                next_state <= GET_DATA_KEY;
            end
            GET_DATA_KEY : begin
                next_state <= CHECK_TYPE;
            end
            CHECK_TYPE : begin
                if(cript_or_decript == 2'b01) begin
                    next_state <= CRIPT_FIRST_XOR;
                end 
                else if(cript_or_decript == 2'b10) begin
                    next_state <= DECRIPTFIRST_XOR;
                end
            end
            //Part with CRIPT -----------------------------------------------------------------------
            CRIPT_FIRST_XOR : begin
                next_state <= DELAY_CRIPT_FIRST_XOR;
            end
            DELAY_CRIPT_FIRST_XOR : begin
                next_state <= CRIPT_SAVE_REG;
            end
            CRIPT_SAVE_REG : begin
                next_state <= DELAY_CRIPT_SAVE_REG;
            end
            DELAY_CRIPT_SAVE_REG : begin
                next_state <= CRIPT_SUBBOX;
            end
            CRIPT_SUBBOX : begin
                next_state <=  DELAY_CRIPT_SUBBOX;
            end
            DELAY_CRIPT_SUBBOX : begin
                next_state <= CRIPT_SHIFT;
            end
            CRIPT_SHIFT : begin
                next_state <= DELAY_CRIPT_SHIFT;
            end
            DELAY_CRIPT_SHIFT : begin
                next_state <= CRIPT_CHECK_COUNTER;
            end
            CRIPT_CHECK_COUNTER : begin
                if(fin_counter < 3'b001) begin
                    next_state <= CRIPT_ADD_COUNTER;
                end
                else begin
                    next_state <= CRIPT_SUBBOX_KEY;
                end
            end
            CRIPT_ADD_COUNTER : begin
                next_state <= CRIPT_MIXCOL;
            end
            CRIPT_MIXCOL : begin
                next_state <= DELAY_CRIPT_MIXCOL;
            end
            DELAY_CRIPT_MIXCOL : begin
                next_state <= CRIPT_SUBBOX_KEY;
            end
            CRIPT_SUBBOX_KEY : begin
                next_state <= DELAY_CRIPT_SUBBOX_KEY;
            end
            DELAY_CRIPT_SUBBOX_KEY : begin
                next_state <= CRIPT_XOR_KEY;
            end
            CRIPT_XOR_KEY : begin
                next_state <= DELAY_CRIPT_XOR_KEY;
            end
            DELAY_CRIPT_XOR_KEY : begin
                next_state <= CRIPT_CHECK_END;
            end 
            CRIPT_CHECK_END : begin
                if(fin_counter < 3'b001) begin
                    next_state <= CRIPT_SAVE_REG;
                end
                else begin
                    next_state <= OUT_DATA;
                end 
            end
            //Part with DECRIPT -----------------------------------------------------------------------
            DECRIPTFIRST_XOR : begin
                next_state <= DELAY_DECRIPT_F_XOR;
            end
            DELAY_DECRIPT_F_XOR : begin
                next_state <= DECRIPT_SHIFT;
            end
            DECRIPT_SHIFT : begin
                next_state <= DELAY_DECRIPT_SHIFT;
            end
            DELAY_DECRIPT_SHIFT : begin
                next_state <= DECRIPT_SUBBOX;
            end
            DECRIPT_SUBBOX : begin
                next_state <= DELAY_DECRIPT_SUBBOX;
            end
            DELAY_DECRIPT_SUBBOX : begin
                next_state <= DECRIPT_CHECK_COUNT;
            end 
            DECRIPT_CHECK_COUNT : begin
                if(fin_counter < 3'b001) begin
                    next_state <= DECRIPT_SUB_COUNTER;
                end
                else begin
                    next_state <= DECRIPT_LST_SUB_KEY;
                end
            end 
            DECRIPT_SUB_COUNTER : begin
                next_state <= DECRIPT_SUBBOX_KEY;
            end
            DECRIPT_SUBBOX_KEY : begin
                next_state <= DELAY_DECRIPT_SUBB_KEY;
            end
            DELAY_DECRIPT_SUBB_KEY : begin
                next_state <= DECRIPT_XOR_KEY;
            end
            DECRIPT_XOR_KEY : begin
                next_state <= DELAY_DECRIPT_XOR_KEY;
            end
            DELAY_DECRIPT_XOR_KEY : begin
                next_state <= DECRIPT_MIXCOL;
            end
            DECRIPT_MIXCOL : begin
                next_state <= DELAY_DECRIPT_MIXCOL;
            end
            DELAY_DECRIPT_MIXCOL : begin
                next_state <= DECRIPT_SAVE_REG;
            end
            DECRIPT_SAVE_REG : begin
                next_state <= DELAY_DECRIPT_SAVE_REG;
            end
            DELAY_DECRIPT_SAVE_REG : begin
                next_state <= DECRIPT_SHIFT;
            end
            DECRIPT_LST_SUB_KEY : begin
                next_state <= DELAY_DECRIPT_LST_S_KEY;
            end
            DELAY_DECRIPT_LST_S_KEY : begin
                next_state <= DECRIPT_LST_XOR_KEY;
            end
            DECRIPT_LST_XOR_KEY : begin
                next_state <= DELAY_DECRIPT_LST_X_KEY;
            end
            DELAY_DECRIPT_LST_X_KEY : begin
                next_state <= OUT_DATA;
            end
            //Common end ------------------------------------------------------------------------------
            OUT_DATA : begin
                next_state <= OUT_KEY;
            end
            OUT_KEY : begin
                next_state <= FIN;
            end
            FIN : begin
                next_state <= IDLE;
            end

        endcase
    end

    always @(posedge clk, posedge rst) begin
        {c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21} <= 22'b0;

        case(next_state) 
            GET_DATA_KEY : begin
                c0 <= 1'b1;
            end
            //CRIPT
            CRIPT_FIRST_XOR : begin
                c1 <= 1'b1;
            end
            CRIPT_SAVE_REG : begin
                c2 <= 1'b1;
            end
            CRIPT_SUBBOX : begin
                c3 <= 1'b1;
            end
            CRIPT_SHIFT : begin
                c4 <= 1'b1;
            end
            CRIPT_ADD_COUNTER : begin
                c5 <= 1'b1;
            end
            CRIPT_MIXCOL : begin
                c6 <= 1'b1;
            end
            CRIPT_SUBBOX_KEY : begin
                c7 <= 1'b1;
            end
            CRIPT_XOR_KEY : begin
                c8 <= 1'b1;
            end
            //DECRIPT
            DECRIPTFIRST_XOR : begin
                c9 <= 1'b1;
            end 
            DECRIPT_SAVE_REG : begin
                c10 <= 1'b1;
            end
            DECRIPT_SHIFT : begin
                c11 <= 1'b1;
            end
            DECRIPT_SUBBOX : begin
                c12 <= 1'b1;
            end
            DECRIPT_SUB_COUNTER : begin
                c5 <= 1'b1;
            end
            DECRIPT_SUBBOX_KEY : begin
                c14 <= 1'b1;
            end
            DECRIPT_XOR_KEY : begin
                c15 <= 1'b1;
            end
            DECRIPT_MIXCOL : begin
                c16 <= 1'b1;
            end
            DECRIPT_LST_SUB_KEY : begin
                c17 <= 1'b1;
            end
            DECRIPT_LST_XOR_KEY : begin
                c18 <= 1'b1;
            end
            //OUTBUS
            OUT_DATA : begin
                c19 <= 1'b1;
            end
            OUT_KEY : begin
                c20 <= 1'b1;
            end
            FIN : begin
                c21 <= 1'b1;
            end
        endcase 
    end

endmodule


module ControlUnit_tb();
 
    reg clk;
    reg rst;
    reg [1:0] cript_or_decript;
    reg bgn;
    reg [2:0] fin_counter;
    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21;


    ControlUnit uut (
        .clk(clk),
        .rst(rst),
        .cript_or_decript(cript_or_decript),
        .bgn(bgn),
        .fin_counter(fin_counter),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4),
        .c5(c5), .c6(c6), .c7(c7), .c8(c8), .c9(c9),
        .c10(c10), .c11(c11), .c12(c12), .c13(c13), .c14(c14),
        .c15(c15), .c16(c16), .c17(c17), .c18(c18), .c19(c19), .c20(c20), .c21(c21)
    );


    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end


    initial begin

        rst = 1;
        bgn = 0;
        cript_or_decript = 2'b00;
        fin_counter = 3'b000;

        #20 
        rst = 0;

        #20;
        rst = 1;
        bgn = 1;

        #30;
        bgn = 0;
        cript_or_decript = 2'b01;

        #200;
        fin_counter = 3'b011;

        #200;
        fin_counter = 3'b100;


        #160;
        rst = 0;
        
        #20;
        rst = 1;
        bgn = 1;
        fin_counter = 3'b0;

        #30;
        cript_or_decript = 2'b10;
        bgn = 0;
        
        #200;
        fin_counter = 3'b100;

        #200;

        $stop;
    end


endmodule
