`include "ALU/ALU.v"
`include "GPP/data_mem.v"
`include "GPP/general_p_register.v"
`include "GPP/instr_mem.v"
`include "GPP/proces_data.v"
`include "GPP/SP_PC.v"

module control_unit(
    input wire clk,
    input wire rst,
	
	input wire fin_file,
	input wire [5:0] opcode,
	input wire [3:0] flags, //carry,negative,overflow,zero
	input wire Alu_busy,
	input wire register,
	
	output reg [2:0]reg_signal,//X,Y,ACC
    output reg STA_signal,
	output reg LDA_signal,
	output reg Load_data,
	output reg Store_data,
	output reg mem_read,
	output reg mem_write,
    output reg start_crypt,
	output reg start_decrypt,
	output reg read_file,
	output reg read_memory,
	output reg PUSH,
	output reg POP,
	output reg Jump,
	output reg Increm_PC,
	output reg Start_ALU_operation
);
	localparam IDLE = 6'b000000; 
    localparam LDR  = 6'b000001; 
    localparam SRT  = 6'b000010; 
    localparam STA  = 6'b000011;  
    localparam LDA  = 6'b000100;  
    localparam BRZ  = 6'b000101;  
    localparam BRN  = 6'b000110;  
    localparam BRC  = 6'b000111;  
    localparam BRO  = 6'b001000;  
    localparam BRA  = 6'b001001;  
    localparam JMP   = 6'b001010; 
    localparam RET  = 6'b001011;
    localparam ADD  = 6'b001100;  
    localparam SUB  = 6'b001101;  
    localparam LSR  = 6'b001110; 
    localparam LSL  = 6'b001111;  
    localparam RSR  = 6'b010000;  
    localparam RSL  = 6'b010001;  
	localparam MOV  = 6'b010010;
	localparam MUL  = 6'b010011;
	localparam DIV  = 6'b010100;
	localparam MOD  = 6'b010101;
	localparam AND  = 6'b010110;
	localparam OR  = 6'b010111;
	localparam XOR  = 6'b011000;
	localparam NOT  = 6'b011001;
	localparam CMP = 6'b011010;
	localparam TST = 6'b011011;
	localparam INC = 6'b011100;
	localparam DEC = 6'b011101;
	localparam BEGIN1  = 6'b011110;
	localparam FETCH = 6'b011111;

	
	
reg [5:0] current_state, next_state;

always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= BEGIN;
        end else begin
            current_state <= next_state;
        end
 end
end
 
 
 //stari
 always @(*)begin
	case(current_state)
		BEGIN1:begin
			if(fin_file)
			begin
				next_state=FETCH;
			end
		end
		FETCH:begin
			if(Alu_busy)
			begin
				next_state=FETCH;
			end
			else
			begin
				case(opcode)
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
					BRZ: next_state = BRZ;
					BRN : next_state = BRN;
					BRC : next_state = BRC;
					BRO : next_state = BRO;
					BRA : next_state = BRA;
					JMP : next_state = JMP;
					RET	: next_state = RET;
					STR : next_state = STR;
					LDR : next_state =LDR;
					LDA: next_state = LDA;
					STA: next_state = STA;
					default:next_state=IDLE;
				endcase
			end
		end
		 ADD, SUB, INC, DEC, MOD, AND, OR, XOR, NOT, MOV, LSL, LSR, RSL, RSR, DIV, MUL, TST, CMP,BRO,BRA,BRC,BRZ,BRN,JMP,RET,STR,LDR, LDA, STA:
                next_state = FETCH;
	endcase
 end
 
 
//outputuri
 always @(posedge clk or negedge rst) begin
        if (!rst) begin
			reg_signal<=3'b000;
			STA_signal<=1'b0;
			LDA_signal<=1'b0;
			Load_data<=1'b0;
			Store_data<=1'b0;
			mem_read<=1'b0;
			mem_write<=1'b0;
			start_crypt<=1'b0;
			start_decrypt<=1'b0;
			read_file<=1'b0;
			read_memory<=1'b0;
			PUSH<=1'b0;
			POP<=1'b0;
			Jump<=1'b0;
			Increm_PC<=1'b0;
			Start_ALU_operation<=1'b0;
		end
		else
		begin 
			case(current_state)
				BEGIN1: begin 
					 read_file<=1'b1;
				end
				
				FETCH:  begin 
					read_memory<=1'b1; 
				end

				ADD, SUB, MUL, DIV, AND, OR, XOR, NOT, MOV, LSL, LSR, RSL, RSR: begin
					Start_ALU_operation <= 1'b1;
					Increm_PC <= 1'b1;
					reg_signal <= register ? 3'b100 : 3'b010;
				end
					
				BRZ: 
				begin 
					if(flags[3]) begin // Zero flag
						Jump <= 1'b1;
					end else begin 
						Increm_PC <= 1'b1;
					end
				end
					
                            
				BRN: begin
                    if (flags[1]) begin  // Negative flag
                       	Jump <= 1'b1;
                    end else
                        Increm_PC <= 1'b1;
                end
                            
                BRC: begin
                    if (flags[0]) begin  // Carry flag
                        Jump <= 1'b1;
                    end else
                        Increm_PC <= 1'b1;
                end
                            
                BRA: begin
                        Jump <= 1'b1;
						//Darius, Muller
                end
                            
                JMP: begin
                        Jump <= 1'b1;
						//Darius, Muller
                end


				RET	: begin 
					//Darius
				end
				
				STA: begin
					mem_write <= 1'b1;
					STA_signal <= 1'b1;
					Increm_PC <= 1'b1;
				end
				
				LDA: begin
					mem_read <= 1'b1;
					LDA_signal <= 1'b1;
					Increm_PC <= 1'b1;
				end

				STR : begin
					if(register) begin
						reg_signal<=3'b100;
						mem_write<=1'b1;
						Increm_PC<=1'b1;
					end else begin
						reg_signal<=3'b010;
						mem_write<=1'b1;
						Increm_PC<=1'b1;
					end
				end

				LDR : begin
					if(register) begin
						reg_signal<=3'b100;
						mem_read<=1'b1;
						Increm_PC<=1'b1;
					end else begin
						reg_signal<=3'b010;
						mem_read<=1'b1;
						Increm_PC<=1'b1;
					end

				end
				default:begin
					reg_signal<=3'b111;
				 end				
			endcase
		end
end
 	
endmodule