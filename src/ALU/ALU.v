`include "../ALU/MULTIPLIER/multiplier.v"
`include "../ALU/SHIFTER/LSL.v"
`include "../ALU/SHIFTER/LSR.v"
`include "../ALU/SHIFTER/RSL.v"
`include "../ALU/SHIFTER/RSR.v"
`include "../ALU/SUBSTRACTOR/Sub.v"
`include "../ALU/LOGICALOPERATIONS/and.v"
`include "../ALU/LOGICALOPERATIONS/cmp.v"
`include "../ALU/LOGICALOPERATIONS/not.v"
`include "../ALU/LOGICALOPERATIONS/or.v"
`include "../ALU/LOGICALOPERATIONS/tst.v"
`include "../ALU/LOGICALOPERATIONS/xor.v"
`include "../ALU/LOGICALOPERATIONS/mov.v"
`include "../ALU/DIVIDER/divider.v"
`include "../ALU/ARITHMETICOPERATIONS/dec.v"
`include "../ALU/ARITHMETICOPERATIONS/inc.v"
`include "../ALU/ARITHMETICOPERATIONS/mod.v"
`include "../ALU/ADDER/Add.v"

module FSM16bit(
    input wire clk,
    input wire rst,
    input wire start,
    input wire mov_enable,
    input wire [5:0] op_code,  
    input wire [15:0] a,       
    input wire [15:0] b,                 
    output reg [15:0] result,
    output reg [15:0] remainder,       
    output reg busy,
    output reg carry_flag,
    output reg negative_flag,
    output reg overflow_flag,
    output reg zero_flag           
);

    localparam IDLE = 6'b000000;  // IDLE
    localparam ADD  = 6'b001100;  // ADD
    localparam SUB  = 6'b001101;  // SUB
    localparam LSR  = 6'b001110;  // LSR
    localparam LSL  = 6'b001111;  // LSL
    localparam RSR  = 6'b010000;  // RSR
    localparam RSL  = 6'b010001;  // RSL
    localparam MOV  = 6'b010010;  // MOV
    localparam MUL  = 6'b010011;  // MUL
    localparam DIV  = 6'b010100;  // DIV
    localparam MOD  = 6'b010101;  // MOD
    localparam AND  = 6'b010110;  // AND
    localparam OR   = 6'b010111;  // OR
    localparam XOR  = 6'b011000;  // XOR
    localparam NOT  = 6'b011001;  // NOT
    localparam CMP  = 6'b011010;  // CMP
    localparam TST  = 6'b011011;  // TST
    localparam INC  = 6'b011100;  // INC
    localparam DEC  = 6'b011101;  // DEC

    reg [5:0] current_state, next_state;
    reg start_mul;
    wire mul_busy;

    wire [15:0] add_result, sub_result, inc_result, dec_result, mod_result, div_result, remainder_res;
    wire [15:0] and_result, or_result, xor_result, not_result, mov_result, mul_result, cmp_result, tst_result;
    wire [15:0] lsl_result, lsr_result, rsl_result, rsr_result;
    wire neg_flag, ovf_flag, ze_flag, carr_flag;

     Add adder (
        .a(a),
        .b(b),
        .sum(add_result),
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

    Sub subtractor (
        .a(a),
        .b(b),
        .diff(sub_result),
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

    TST16bit tst_op(
        .inp1(a),
        .inp2(b),
        .clk(clk),
        .rst(rst),
        .and_result(tst_result),
        .overflow_flag(ovf_flag),
        .zero_flag(ze_flag),
        .negative_flag(neg_flag),
        .carry_flag(carr_flag)
    );

    CMP16bit cmp_op (
        .op1(a),
        .op2(b),
        .clk(clk),
        .rst(rst),
        .result(cmp_result)
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
                if (start) begin
                    // $display("start = %b || op_code = %b",start, op_code);
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
                        TST: next_state = TST;
                        CMP: next_state = CMP;
                        default: next_state = IDLE;
                    endcase
                end
            end

            ADD, SUB, INC, DEC, MOD, AND, OR, XOR, NOT, MOV, LSL, LSR, RSL, RSR, DIV, MUL, TST, CMP:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            result <= 16'b0;
            remainder <= 16'b0;
            overflow_flag <= 1'b0; 
            negative_flag <= 1'b0; 
            carry_flag <= 1'b0; 
            zero_flag <= 1'b0;
        end else begin
            case (current_state)
                ADD: begin result <= add_result; overflow_flag <= (~a[15] & ~b[15] & result[15]) | (a[15] & b[15] & ~result[15]); negative_flag <= add_result[15]; carry_flag <= (a + b) > 16'hFFFF; zero_flag <= (add_result == 16'b0); end
                SUB: begin result <= sub_result; overflow_flag <= (a[15] & ~b[15] & ~result[15]) | (~a[15] & b[15] & result[15]); negative_flag <= sub_result[15]; carry_flag <= (a < b); zero_flag <= (sub_result == 16'b0); end
                INC: begin result <= inc_result; overflow_flag <= (a == 16'b1111111111111111); negative_flag <= inc_result[15]; carry_flag <= (a == 16'b1111111111111111); zero_flag <= (inc_result == 16'b0); end
                DEC: begin result <= dec_result; overflow_flag <= (a == 16'd0); negative_flag <= dec_result[15]; carry_flag <= (a == 16'd0); zero_flag <= (dec_result == 16'b0); end
                MOD: begin result <= mod_result; overflow_flag <= 1'b0; negative_flag <= mod_result[15]; carry_flag <= 1'b0; zero_flag <= (mod_result == 16'b0); end
                AND: begin result <= and_result; overflow_flag <= 1'b0; negative_flag <= and_result[15]; carry_flag <= 0; zero_flag <= (and_result == 16'b0); end
                OR: begin result <= or_result; overflow_flag <= 1'b0; negative_flag <= or_result[15]; carry_flag <= 1'b0; zero_flag <= (or_result == 16'b0); end
                XOR: begin result <= xor_result; overflow_flag <= 1'b0; negative_flag <= xor_result[15]; carry_flag <= 1'b0; zero_flag <= (xor_result == 16'b0); end
                NOT: begin result <= not_result; overflow_flag <= 1'b0; negative_flag <= not_result[15]; carry_flag <= 1'b0; zero_flag <= (not_result == 16'b0); end
                MOV: begin result <= mov_result; overflow_flag <= 1'b0; negative_flag <= mov_result[15]; carry_flag <= 1'b0; zero_flag <= (mov_result == 16'b0); end
                LSL: begin result <= lsl_result; overflow_flag <= 1'b0; negative_flag <= lsl_result[15]; carry_flag <= a[15 - b[3:0]]; zero_flag <= (lsl_result == 16'b0); end
                LSR: begin result <= lsr_result; overflow_flag <= 1'b0; negative_flag <= lsr_result[15]; carry_flag <= a[b[3:0] - 1]; zero_flag <= (lsr_result == 16'b0); end
                RSL: begin result <= rsl_result; overflow_flag <= 1'b0; negative_flag <= rsl_result[15]; carry_flag <= 1'b0; zero_flag <= (rsl_result == 16'b0); end
                RSR: begin result <= rsr_result; overflow_flag <= 1'b0; negative_flag <= rsr_result[15]; carry_flag <= 1'b0; zero_flag <= (rsr_result == 16'b0); end
                MUL: begin result <= mul_result; overflow_flag <= (mul_result/a != b); negative_flag <= mul_result[15]; carry_flag <= (mul_result/a != b); zero_flag <= (mul_result == 16'b0); end
                DIV: begin result <= div_result; remainder <= remainder_res; overflow_flag <= (div_result * a != b); negative_flag <= div_result[15]; carry_flag <= (remainder_res != 16'b0); zero_flag <= (div_result == 16'b0); end
                CMP: begin result <= cmp_result; overflow_flag <= (a[15] != cmp_result[15]); negative_flag <= cmp_result[15]; carry_flag <= (b > a); zero_flag <= (cmp_result == 16'b0); end
                TST: begin result <= tst_result; overflow_flag <= ovf_flag; negative_flag <= neg_flag; carry_flag <= carr_flag; zero_flag <= ze_flag; end
                default: begin result <= result; overflow_flag <= overflow_flag; negative_flag <= negative_flag; carry_flag <= carry_flag; zero_flag <= zero_flag; end
            endcase

            // $display("a:%b |  b:%b |  result:%b",a, b, result);
        end 
    end
endmodule


module tb_FSM16bit;

    // Declarațiile semnalelor
    reg clk;
    reg rst;
    reg start;
    reg [5:0] op_code;
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] result;
    wire busy;
    reg mov_enable;
    wire [15:0] remainder;
    wire zero_flag, overflow_flag, carry_flag, negative_flag;

    // Instanțierea modulului FSM
    FSM16bit fsm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mov_enable(mov_enable),
        .op_code(op_code),
        .a(a),
        .b(b),
        .result(result),
        .remainder(remainder),
        .busy(busy),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
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
        start = 1;

        // Reset FSM
        #10 rst = 1;
        #10 rst = 0;
        #10 rst = 1;

        // Test ADD
        #10;
        op_code = 6'b000001; // ADD
        a = 16'd10;
        b = 16'd5;
        #10;
        check_result("ADD", result, 16'd15, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 + 5 = 15

        // Test SUB
        #10;
        op_code = 6'b000010; // SUB
        a = 16'd0;
        b = 16'd5;
        #10;
        check_result("SUB", result, 16'b1111111111111011, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 15 - 5 = 10

        // Test INC
        #10;
        op_code = 6'b000011; // INC
        a = 16'd10;
        #10;
        check_result("INC", result, 16'd11, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 + 1 = 11

        // Test DEC
        #10;
        op_code = 6'b000100; // DEC
        a = 16'd10;
        #10;
        check_result("DEC", result, 16'd9, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 - 1 = 9

        // Test MOD
        #10;
        op_code = 6'b000101; // MOD
        a = 16'd10;
        b = 16'd3;
        #10;
        check_result("MOD", result, 16'd1, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 % 3 = 1

        // Test AND
        #10;
        op_code = 6'b000110; // AND
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("AND", result, 16'd7, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 15 & 7 = 7

        // Test OR
        #10;
        op_code = 6'b001010; // OR
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("OR", result, 16'd15, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 15 | 7 = 15

        #10;
        op_code = 6'b010001; // DIV
        a = 16'd15;
        b = 16'd7;
        #10;
        check_division_result("DIV", result, 16'd2, remainder, 16'd1, overflow_flag, carry_flag, zero_flag, negative_flag); 
        // Test XOR
        #10;
        op_code = 6'b001011; // XOR
        a = 16'd15;
        b = 16'd7;
        #10;
        check_result("XOR", result, 16'd8, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 15 ^ 7 = 8

        // Test NOT
        #10;
        op_code = 6'b001001; // NOT
        a = 16'd10;
        #10;
        check_result("NOT", result, 16'b1111111111110101, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect ~10

        // Test MOV
        #10;
        op_code = 6'b001000; // MOV
        a = 16'd5;
        mov_enable = 1;    // Activăm semnalul de mutare
        #10;
        check_result("MOV", result, 16'd5, overflow_flag, carry_flag, zero_flag, negative_flag);

        // Test LSL
        #10;
        op_code = 6'b001101; // LSL
        a = 16'd10;
        b = 16'd3; // Shift left by 3
        #10;
        check_result("LSL", result, 16'd80, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 << 3 = 80

        // Test LSR
        #10;
        op_code = 6'b001110; // LSR
        a = 16'd10;
        b = 16'd3; // Shift right by 3
        #10;
        check_result("LSR", result, 16'd1, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 >> 3 = 1

        // Test RSL
        #10;
        op_code = 6'b001111; // RSL
        a = 16'd10;
        b = 16'd3; // Rotate left by 3
        #10;
        check_result("RSL", result, 16'd80, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect rotated left by 3

        // Test RSR
        #10;
        op_code = 6'b010000; // RSR
        a = 16'd10;
        b = 16'd3; // Rotate right by 3
        #10;
        check_result("RSR", result, 16'd16385, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect rotated right by 3

        // Test MUL
        #10;
        op_code = 6'b001100; // MUL
        a = 16'd65535;
        b = 16'd65535;
        #10;
        check_result("MUL", result, 16'b0000000000000001, overflow_flag, carry_flag, zero_flag, negative_flag); // Expect 10 * 5 = 50

        //TEST CMP
        #10;
        op_code = 6'b000111;
        a = 16'd4;
        b = 16'd7;
        #10;
        check_result("CMP", result, 16'b1111111111111101, overflow_flag, carry_flag, zero_flag, negative_flag);

        //Test TST
        #10;
        op_code = 6'b010010;
        a = 16'd5;
        b = 16'd7;
        #10;
        check_result("TST", result, 16'b0101, overflow_flag, carry_flag, zero_flag, negative_flag);
        // Test final check
        #10;
        $stop;
    end

    // Task for checking results
    task check_result;
        input [7*8:1] operation;
        input [15:0] actual_result;
        input [15:0] expected_result;
        input overflow;
        input carry;
        input zero;
        input negative;
        begin
            if (actual_result == expected_result) begin
                $display("%s Test PASSED: Result = %d, overflow = %b, carry = %b, zero = %b, negative = %b", 
                         operation, actual_result, overflow, carry, zero, negative);
            end else begin
                $display("%s Test FAILED: Expected = %d, Got = %d, overflow = %b, carry = %b, zero = %b, negative = %b", 
                         operation, expected_result, actual_result, overflow, carry, zero, negative);
            end
        end
    endtask

    task check_division_result;
    input [7*8:1] operation;
    input [15:0] actual_quotient;
    input [15:0] expected_quotient;
    input [15:0] actual_remainder;
    input [15:0] expected_remainder;
    input overflow_flag;
    input carry_flag;
    input zero_flag;
    input negative_flag;
    begin
        if (actual_quotient == expected_quotient && actual_remainder == expected_remainder) begin
            $display("%s Test PASSED: Quotient = %d, Expected Remainder = %d, Actual Remainder = %d, overflow = %b, carry = %b, zero = %b, negative = %b",
                     operation, actual_quotient, expected_remainder, actual_remainder, overflow_flag, carry_flag, zero_flag, negative_flag);
        end else begin
            $display("%s Test FAILED: Expected Quotient = %d, Got Quotient = %d, Expected Remainder = %d, Got Remainder = %d, overflow = %b, carry = %b, zero = %b, negative = %b",
                     operation, expected_quotient, actual_quotient, expected_remainder, actual_remainder, overflow_flag, carry_flag, zero_flag, negative_flag);
        end
    end
endtask

endmodule
