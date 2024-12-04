`include "MULTIPLIER/multiplier.v"
`include "SHIFTER/LSL.v"
`include "SHIFTER/LSR.v"
`include "SHIFTER/RSL.v"
`include "SHIFTER/RSR.v"
`include "SUBSTRACTOR/FSC16bit.v"
`include "LOGICALOPERATIONS/and.v"
`include "LOGICALOPERATIONS/cmp.v"
`include "LOGICALOPERATIONS/not.v"
`include "LOGICALOPERATIONS/or.v"
`include "LOGICALOPERATIONS/tst.v"
`include "LOGICALOPERATIONS/xor.v"
`include "LOGICALOPERATIONS/mov.v"
`include "DIVIDER/divider.v"
`include "ARITHMETICOPERATIONS/dec.v"
`include "ARITHMETICOPERATIONS/inc.v"
`include "ARITHMETICOPERATIONS/mod.v"
`include "ADDER/CLA16bit.v"

module FSM16bit(
    input wire clk,
    input wire rst,
    input wire mov_enable,
    input wire [5:0] op_code,  
    input wire [15:0] a,       
    input wire [15:0] b,      
    input wire bin,
    input wire cin,            
    output reg [15:0] result,
    output reg [15:0] remainder,
    output reg bout,           
    output reg busy            
);


    localparam IDLE = 6'b000000;  // IDLE
    localparam ADD  = 6'b000001;  // ADD
    localparam SUB  = 6'b000010;  // SUB
    localparam INC  = 6'b000011;  // INC
    localparam DEC  = 6'b000100;  // DEC
    localparam MOD  = 6'b000101;  // MOD
    localparam AND  = 6'b000110;  // AND
    localparam CMP  = 6'b000111;  // CMP
    localparam MOV  = 6'b001000;  // MOV
    localparam NOT  = 6'b001001;  // NOT
    localparam OR   = 6'b001010;  // OR
    localparam XOR  = 6'b001011;  // XOR
    localparam MUL  = 6'b001100;  // MUL
    localparam LSL  = 6'b001101;  // LSL
    localparam LSR  = 6'b001110;  // LSR
    localparam RSL  = 6'b001111;  // RSL
    localparam RSR  = 6'b010000;  // RSR
    localparam DIV  = 6'b010001;  //DIV

    reg [5:0] current_state, next_state;
    reg start_mul;
    wire mul_busy;

    wire [15:0] add_result, sub_result, inc_result, dec_result, mod_result, div_result, remainder_res;
    wire [15:0] and_result, or_result, xor_result, not_result, mov_result, mul_result;
    wire [15:0] lsl_result, lsr_result, rsl_result, rsr_result;
    wire sub_bout, add_cout;

    CLA16bit adder (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(add_result),
        .cout(add_cout),
        .clk(clk),
        .rst(rst)
    );

    divider divid(
        .dividend(a),
        .divisor(b),
        .clk(clk),
        .rst(rst),
        .quotient(div_result),
        .remainder(remainder_res)
    );   

    FullSubtractor16bit subtractor (
        .a(a),
        .b(b),
        .bin(bin),
        .diff(sub_result),
        .bout(sub_bout),
        .clk(clk),
        .rst(rst)
    );

    INC16bit incrementer (
        .inp(a),
        .clk(clk),
        .rst(rst),
        .out(inc_result)
    );

    DEC16bit decrementer (
        .inp(a),
        .clk(clk),
        .rst(rst),
        .out(dec_result)
    );

    MOD16bit modulator (
        .num(a), 
        .imp(b), 
        .clk(clk),
        .rst(rst),
        .result(mod_result)
    );

    AND16bit and_op (
        .inp1(a), 
        .inp2(b),
        .clk(clk),
        .rst(rst),
        .out(and_result)
    );

    OR16bit or_op (
        .inp1(a), 
        .inp2(b),
        .clk(clk),
        .rst(rst),
        .out(or_result)
    );

    XOR16bit xor_op (
        .inp1(a), 
        .inp2(b),
        .clk(clk),
        .rst(rst), 
        .out(xor_result)
    );

    NOT16bit not_op (
        .inp(a),
        .clk(clk),
        .rst(rst),
        .out(not_result)
    );

    MOV16bit mover (
        .src(a),
        .clk(clk),
        .rst(rst), 
        .mov_enable(mov_enable),
        .dest(mov_result)
    );

    multiplier mul_op (
        .a(a), 
        .b(b),
        .out(mul_result), 
        .clk(clk), 
        .rst(rst)
    );

    LSL16bit lsl_op (
        .inp(a), 
        .shift_value(b), 
        .clk(clk),
        .rst(rst),
        .out(lsl_result)
    );

    LSR16bit lsr_op (
        .inp(a), 
        .shift_value(b),
        .clk(clk),
        .rst(rst),
        .out(lsr_result)
    );

    RSL16bit rsl_op (
        .inp(a), 
        .shift_value(b),
        .clk(clk),
        .rst(rst),
        .out(rsl_result)
    );

    RSR16bit rsr_op (
        .inp(a), 
        .shift_value(b), 
        .clk(clk),
        .rst(rst),
        .out(rsr_result)
    );


    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        busy = 1;

        case (current_state)
            IDLE: begin
                busy = 0;
                case (op_code)
                    ADD: next_state = ADD;
                    SUB: next_state = SUB;
                    INC: next_state = INC;
                    DEC: next_state = DEC;
                    MOD: next_state = MOD;
                    AND: next_state = AND;
                    OR: next_state = OR;
                    XOR: next_state = XOR;
                    NOT: next_state = NOT;
                    MOV: next_state = MOV;
                    LSL: next_state = LSL;
                    LSR: next_state = LSR;
                    RSL: next_state = RSL;
                    RSR: next_state = RSR;
                    MUL: next_state = MUL;
                    DIV: next_state = DIV;
                    default: next_state = IDLE;
                endcase
            end

            ADD, SUB, INC, DEC, MOD, AND, OR, XOR, NOT, MOV, LSL, LSR, RSL, RSR, DIV:
                next_state = IDLE;

            MUL: begin
                start_mul = 1;
                if (!mul_busy) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Ieșirea FSM
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            result <= 16'b0;
            remainder <= 16'b0;
            bout <= 0;
        end else begin
            case (current_state)
                ADD: result <= add_result;
                SUB: begin result <= sub_result; bout <= sub_bout; end
                INC: result <= inc_result;
                DEC: result <= dec_result;
                MOD: result <= mod_result;
                AND: result <= and_result;
                OR: result <= or_result;
                XOR: result <= xor_result;
                NOT: result <= not_result;
                MOV: result <= mov_result;
                LSL: result <= lsl_result;
                LSR: result <= lsr_result;
                RSL: result <= rsl_result;
                RSR: result <= rsr_result;
                MUL: result <= mul_result;
                DIV: begin result <= div_result; remainder <= remainder_res; end
                default: result <= result;
            endcase
        end
    end
endmodule

`timescale 1ns / 1ps

module tb_FSM16bit;

    // Declarațiile semnalelor
    reg clk;
    reg rst;
    reg [5:0] op_code;
    reg [15:0] a;
    reg [15:0] b;
    reg bin;
    reg cin;
    wire [15:0] result;
    wire bout;
    wire busy;
    reg mov_enable;
    wire [15:0] remainder;

    // Instanțierea modulului FSM
    FSM16bit fsm (
        .clk(clk),
        .rst(rst),
        .mov_enable(mov_enable),
        .op_code(op_code),
        .a(a),
        .b(b),
        .bin(bin),
        .cin(cin),
        .result(result),
        .remainder(remainder),
        .bout(bout),
        .busy(busy)
    );

    // Generarea semnalului de ceas
    always begin
        #1 clk = ~clk;
    end

    // Testbench-ul propriu-zis
    initial begin
        // Inițializare semnale
        clk = 0;
        rst = 0;
        op_code = 6'b000000; // IDLE
        a = 16'b0;
        b = 16'b0;
        bin = 0;
        cin = 0;

        // Reset FSM
        #10 rst = 1;
        #10 rst = 0;
        #10 rst = 1;

        // Test ADD
        #10;
        op_code = 6'b000001; // ADD
        a = 16'd10;
        b = 16'd5;
        cin = 0;
        bin = 0;
        #10;
        check_result("ADD", result, 16'd15); // Expect 10 + 5 = 15

        // Test SUB
        #10;
        op_code = 6'b000010; // SUB
        a = 16'd15;
        b = 16'd5;
        cin = 0;
        bin = 0;
        #10;
        check_result("SUB", result, 16'd10); // Expect 15 - 5 = 10

        // Test INC
        #10;
        op_code = 6'b000011; // INC
        a = 16'd10;
        #10;
        check_result("INC", result, 16'd11); // Expect 10 + 1 = 11

        // Test DEC
        #10;
        op_code = 6'b000100; // DEC
        a = 16'd10;
        #10;
        check_result("DEC", result, 16'd9); // Expect 10 - 1 = 9

        // Test MOD
        #10;
        op_code = 6'b000101; // MOD
        a = 16'd10;
        b = 16'd3;
        #10;
        check_result("MOD", result, 16'd1); // Expect 10 % 3 = 1

        // Test AND
        #10;
        op_code = 6'b000110; // AND
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("AND", result, 16'd7); // Expect 15 & 7 = 7

        // Test OR
        #10;
        op_code = 6'b001010; // OR
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("OR", result, 16'd15); // Expect 15 | 7 = 15

        #10;
        op_code = 6'b010001; // OR
        a = 16'd15;
        b = 16'd7;
        #10;
        check_division_result("DIV", result, 16'd2, remainder, 16'd1); 
        // Test XOR
        #10;
        op_code = 6'b001011; // XOR
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("XOR", result, 16'd8); // Expect 15 ^ 7 = 8

        // Test NOT
        #10;
        op_code = 6'b001001; // NOT
        a = 16'd10;
        #10;
        check_result("NOT", result, 16'b1111111111110101); // Expect ~10

        // Test MOV
        #10;
        op_code = 6'b001000; // MOV
        a = 16'd5;
        mov_enable = 1;    // Activăm semnalul de mutare
        #10;
        check_result("MOV", result, 16'd5);

        // Test LSL
        #10;
        op_code = 6'b001101; // LSL
        a = 16'd10;
        b = 16'd3; // Shift left by 3
        #10;
        check_result("LSL", result, 16'd80); // Expect 10 << 3 = 80

        // Test LSR
        #10;
        op_code = 6'b001110; // LSR
        a = 16'd10;
        b = 16'd3; // Shift right by 3
        #10;
        check_result("LSR", result, 16'd1); // Expect 10 >> 3 = 1

        // Test RSL
        #10;
        op_code = 6'b001111; // RSL
        a = 16'd10;
        b = 16'd3; // Rotate left by 3
        #10;
        check_result("RSL", result, 16'd80); // Expect rotated left by 3

        // Test RSR
        #10;
        op_code = 6'b010000; // RSR
        a = 16'd10;
        b = 16'd3; // Rotate right by 3
        #10;
        check_result("RSR", result, 16'd16385); // Expect rotated right by 3

        // Test MUL
        #10;
        op_code = 6'b001100; // MUL
        a = 16'd10;
        b = 16'd5;
        #10;
        check_result("MUL", result, 16'd50); // Expect 10 * 5 = 50

        // Test final check
        #10;
        $stop; // Stop simularea
    end

    // Task for checking results
    task check_result;
        input [7*8:1] operation;
        input [15:0] actual_result;
        input [15:0] expected_result;
        begin
            if (actual_result == expected_result) begin
                $display("%s Test PASSED: Result = %d", operation, actual_result);
            end else begin
                $display("%s Test FAILED: Expected = %d, Got = %d", operation, expected_result, actual_result);
            end
        end
    endtask

    task check_division_result;
    input [7*8:1] operation;
    input [15:0] actual_quotient;
    input [15:0] expected_quotient;
    input [15:0] actual_remainder;
    input [15:0] expected_remainder;
    begin
        if (actual_quotient == expected_quotient && actual_remainder == expected_remainder) begin
            $display("%s Test PASSED: Quotient = %d, Expected Remainder = %d, Actual Remainder = %d",
                     operation, actual_quotient, expected_remainder, actual_remainder);
        end else begin
            $display("%s Test FAILED: Expected Quotient = %d, Got Quotient = %d, Expected Remainder = %d, Got Remainder = %d",
                     operation, expected_quotient, actual_quotient, expected_remainder, actual_remainder);
        end
    end
endtask

endmodule

