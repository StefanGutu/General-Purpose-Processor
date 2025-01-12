module control_unit(
    input clk,
    input rst,
	
	input bgn,											//Signal to start the process in CPU
	input fin_crypto,									//Signal crypt unit finished
	input fin_file,										//Signal instr mem finished to read from file
	input [5:0] opcode,
	input [3:0] flags,				 					//carry,negative,overflow,zero
	input Alu_busy,										//Signal that ALU is still busy
	input register,										// Reg X or Y	
	

	//General porp reg
	output reg [3:0]reg_signal,							//LD X, ST X, LD Y, ST Y
    output reg STA_signal,								//ST ACC
	output reg LDA_signal,								//LD ACC
	output reg signal_save_after_alu,					//Save acc from alu

	//Crypto core reg
	output reg Load_data,								//Load data for cript or decript
	output reg Store_data,								//Store data from cript or decript

	//Data memory
	output reg mem_read,								//Send data from data mem
	output reg mem_write,								//Write data in data mem

	//Crypto core C.U
    output reg start_crypt,								
	output reg start_decrypt,
	output reg start_execute_crypto,

	//Instr mem
	output reg read_file,								//Read from file
	output reg read_memory,								//Read line from instr mem

	//SP
	output reg PUSH,									//Push in stack
	output reg POP,										//Pop from stack

	//PC
	output reg pc_save_address_from_instr_mem,
	output reg pc_save_address_from_data_mem,
	output reg pc_save_address_from_counter,

	//PC Counter
	output reg Increm_PC,								//Increment counter PC 
	output reg get_address_from_pc,

	//ALU
	output reg Start_ALU_operation,	
	output reg mov_enable,

	//End
	output reg fin
);

	parameter IDLE = 					6'b000000; 
	parameter READ_FILE = 				6'b000001;
	parameter CHECK_END_READ_FILE =     6'b000010;
	parameter GET_LINE_WITH_PC =        6'b000011;
	parameter INCREMENT_PC =          	6'b000100;
	parameter CHECK_TYPE_INSTR = 		6'b000101;

	//For ALU
	parameter SELECT_REG_ALU =			6'b000110;
	parameter START_ALU = 				6'b000111;
	parameter CHECK_BUSY_ALU = 			6'b001000;

	//For Branch
	parameter CHECK_RET = 				6'b001001;
	parameter BRANCH_IF_ZERO = 			6'b001010;
	parameter BRANCH_IF_NEG =			6'b001011;
	parameter BRANCH_IF_CARRY = 		6'b001100;
	parameter BRANCH_IF_OVERFLOW = 		6'b001101;
	parameter BRANCH_ALWAYS =			6'b001111;		 
	parameter JUMP_BRANCH =				6'b010000;
	parameter PUSH_SP =					6'b010001;
	parameter PC_JUMP_AFTER_PUSH =		6'b010010;
	parameter PULL_SP =					6'b010011;
	parameter PC_JUMP_AFTER_PULL =		6'b010100;

	//For Load/Store ACC/REG
	parameter CHECK_ACC_OR_REG =		6'b010101;

	parameter CHECK_REG_ST_OR_LD =		6'b010110;
	parameter REG_ST =					6'b010111;
	parameter REG_ST_MEM_WRITE =		6'b011000;
	parameter REG_LD_MEM_READ =			6'b011001;
	parameter REG_LD =					6'b011010;

	parameter CHECK_ACC_ST_OR_LD = 		6'b011011;
	parameter ACC_ST =					6'b011100;
	parameter ACC_ST_MEM_WRITE =		6'b011101;
	parameter ACC_LD_MEM_READ =			6'b011110;
	parameter ACC_LD =					6'b011111;		

	//For Crypto
	parameter CRYPTO_MEM_READ =			6'b100000;
	parameter CRYPTO_SEND_KEY =			6'b100001;
	parameter CRYPTO_ACTIV =			6'b100010;
	parameter CHECK_CRYPTO_END =		6'b100011;
	parameter CRYPTO_MEM_WRITE =		6'b100100;
	parameter CRYPTO_SAVE_KEY =			6'b100101;


	//For END program
	parameter SAVE_ACC =				6'b100111;
	parameter END_EXECUTION =			6'b101000;			


	
	
	reg [5:0] current_state, next_state;

	always @(posedge clk or negedge rst) begin
			if (!rst) begin

				current_state <= IDLE;

				reg_signal<=4'b0000;
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
				Increm_PC<=1'b0;
				Start_ALU_operation<=1'b0;
				pc_save_address_from_counter <= 1'b0;
				pc_save_address_from_data_mem <= 1'b0;
				pc_save_address_from_instr_mem <= 1'b0;
				start_execute_crypto <= 1'b0;
				get_address_from_pc <= 1'b0;
				mov_enable <= 1'b0;
				signal_save_after_alu <= 1'b0;
				fin <= 1'b0;

			end else begin
				current_state <= next_state;
				// $monitor("Current_state = %b\n", current_state);
			end
	end

 
 
	//stari
	always @(*)begin
		next_state = current_state;

		case(current_state)
			IDLE : begin
				if (bgn == 1'b0) begin
					next_state <= IDLE;
				end
				else if (bgn == 1'b1) begin
					next_state <= READ_FILE;
				end
			end
			READ_FILE : begin
				next_state <= CHECK_END_READ_FILE;
			end
			CHECK_END_READ_FILE : begin
				if (fin_file == 1'b0) begin
					next_state <= CHECK_END_READ_FILE;
				end
				else if (fin_file == 1'b1) begin
					next_state <= GET_LINE_WITH_PC;
				end
			end
			GET_LINE_WITH_PC : begin
				next_state <= INCREMENT_PC;
			end	
			INCREMENT_PC : begin
				next_state <= CHECK_TYPE_INSTR;
			end
			CHECK_TYPE_INSTR : begin
				if (opcode >= 6'b000001 && opcode <= 6'b000100) begin 			// (LD/ST)
					next_state <= CHECK_ACC_OR_REG;
				end
				if (opcode >= 6'b000101 && opcode <= 6'b001011) begin			// Branch
					next_state <= CHECK_RET;
				end
				if (opcode >= 6'b001100 && opcode <= 6'b011101) begin			//ALU
					next_state <= SELECT_REG_ALU;
				end
				if (opcode == 6'b011110) begin									//CRYPTO
					next_state <= CRYPTO_MEM_READ;
				end
				if (opcode == 6'b000000) begin									//END
					next_state <= END_EXECUTION;
				end
			end
			//Part  with LD/ST ---------------------------------------------------------------

			CHECK_ACC_OR_REG : begin
				if (opcode == 6'b000001 || opcode == 6'b000010 ) begin
					next_state <= CHECK_REG_ST_OR_LD;
				end
				else if (opcode == 6'b000011 || opcode == 6'b000100) begin
					next_state <= CHECK_ACC_ST_OR_LD;
				end
			end
			//REG
			CHECK_REG_ST_OR_LD : begin
				if(opcode == 6'b000010) begin
					next_state <= REG_ST;
				end
				else if (opcode == 6'b000001) begin
					next_state <= REG_LD_MEM_READ;
				end
			end
			REG_ST : begin
				next_state <= REG_ST_MEM_WRITE;
			end
			REG_ST_MEM_WRITE : begin
				next_state <= GET_LINE_WITH_PC;
			end
			REG_LD_MEM_READ : begin
				next_state <= REG_LD;
			end
			REG_LD : begin
				next_state <= GET_LINE_WITH_PC;
			end
			//ACC
			CHECK_ACC_ST_OR_LD : begin
				if(opcode == 6'b000011) begin
					next_state <= ACC_ST;
				end
				else if (opcode == 6'b000100) begin
					next_state <= ACC_LD_MEM_READ;
				end
			end
			ACC_ST : begin
				next_state <= ACC_ST_MEM_WRITE;
			end
			ACC_ST_MEM_WRITE : begin
				next_state <= GET_LINE_WITH_PC;
			end
			ACC_LD_MEM_READ : begin
				next_state <= ACC_LD;
			end
			ACC_LD : begin
				next_state <= GET_LINE_WITH_PC;
			end

			//Part with Branch ----------------------------------------------------------------

			CHECK_RET : begin
				if (opcode == 6'b001011) begin					//RET
					next_state <= PULL_SP;
				end
				else if (opcode == 6'b000101 ) begin
					next_state <= BRANCH_IF_ZERO;
				end
				else if (opcode == 6'b000110 ) begin
					next_state <= BRANCH_IF_NEG;
				end
				else if (opcode == 6'b000111 ) begin
					next_state <= BRANCH_IF_CARRY;
				end
				else if (opcode == 6'b001000 ) begin
					next_state <= BRANCH_IF_OVERFLOW;
				end
				else if (opcode == 6'b001001 ) begin
					next_state <= BRANCH_ALWAYS;
				end
				else if (opcode == 6'b001010 ) begin			//JMP
					next_state <= PUSH_SP;
				end
			end
			PULL_SP : begin
				next_state <= PC_JUMP_AFTER_PULL;
			end
			PC_JUMP_AFTER_PULL : begin
				next_state <= GET_LINE_WITH_PC;
			end

			PUSH_SP : begin
				next_state <= PC_JUMP_AFTER_PUSH;
			end
			PC_JUMP_AFTER_PUSH : begin
				next_state <= JUMP_BRANCH;
			end

			BRANCH_IF_ZERO : begin
				if(flags[3] == 1'b1) begin
					next_state <= JUMP_BRANCH;
				end
				else if(flags[3] == 1'b0) begin
					next_state <= GET_LINE_WITH_PC;
				end
			end
			BRANCH_IF_NEG : begin
				if(flags[2] == 1'b1) begin
					next_state <= JUMP_BRANCH;
				end
				else if(flags[2] == 1'b0) begin
					next_state <= GET_LINE_WITH_PC;
				end
			end
			BRANCH_IF_CARRY : begin
				if(flags[1] == 1'b1) begin
					next_state <= JUMP_BRANCH;
				end
				else if(flags[1] == 1'b0) begin
					next_state <= GET_LINE_WITH_PC ;
				end
			end
			BRANCH_IF_OVERFLOW : begin
				if(flags[0] == 1'b1) begin
					next_state <= JUMP_BRANCH;
				end
				else if(flags[0] == 1'b0) begin
					next_state <= GET_LINE_WITH_PC;
				end
			end
			BRANCH_ALWAYS : begin
				next_state <= JUMP_BRANCH;
			end
			JUMP_BRANCH : begin
				next_state <= GET_LINE_WITH_PC;
			end

			//Part with CRYPTO ----------------------------------------------------------------

			CRYPTO_MEM_READ : begin
				next_state <= CRYPTO_SEND_KEY;
			end
			CRYPTO_SEND_KEY : begin
				next_state <= CRYPTO_ACTIV;
			end
			CRYPTO_ACTIV : begin
				next_state <= CHECK_CRYPTO_END;
			end
			CHECK_CRYPTO_END : begin
				if (fin_crypto == 1'b0) begin
					next_state <= CHECK_CRYPTO_END;
				end
				else if (fin_crypto == 1'b1) begin
					next_state <= CRYPTO_MEM_WRITE;
				end
			end
			CRYPTO_MEM_WRITE : begin
				next_state <= CRYPTO_SAVE_KEY;
			end
			CRYPTO_SAVE_KEY : begin
				next_state <= GET_LINE_WITH_PC;
			end

			//Part with ALU -------------------------------------------------------------------

			SELECT_REG_ALU : begin
				next_state <= START_ALU;
			end
			START_ALU : begin
				next_state <= CHECK_BUSY_ALU;
			end
			CHECK_BUSY_ALU : begin
				if (Alu_busy == 1'b1) begin
					next_state <= CHECK_BUSY_ALU;
				end
				else if (Alu_busy == 1'b0) begin
					next_state <= SAVE_ACC;
				end
			end
			SAVE_ACC : begin
				next_state <= GET_LINE_WITH_PC;
			end


			//Part with End ------------------------------------------------------------------

			END_EXECUTION : begin
				// next_state <= IDLE;
			end
		endcase
	end
 
 
	//outputuri
	always @(posedge clk, posedge rst) begin

		reg_signal<=4'b0000;
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
		Increm_PC<=1'b0;
		Start_ALU_operation<=1'b0;
		pc_save_address_from_counter <= 1'b0;
		pc_save_address_from_data_mem <= 1'b0;
		pc_save_address_from_instr_mem <= 1'b0;
		start_execute_crypto <= 1'b0;
		get_address_from_pc <= 1'b0;
		mov_enable <= 1'b0;
		signal_save_after_alu <= 1'b0;
		fin <= 1'b0;


		case(next_state)
			READ_FILE : begin
				// read_file <= 1'b1;
			end
			CHECK_END_READ_FILE : begin
				read_file <= 1'b1;
			end
			GET_LINE_WITH_PC : begin
				get_address_from_pc <= 1'b1;
			end
			INCREMENT_PC : begin
				Increm_PC <= 1'b1;
				read_memory <= 1'b1;
			end
			//ST REG ---------------------------------------------------------------------
			REG_ST : begin
				if (register == 1'b0) begin
					reg_signal <= 4'b1000;
				end
				else if (register == 1'b1) begin
					reg_signal <= 4'b0010;
				end
			end
			REG_ST_MEM_WRITE : begin
				mem_write <= 1'b1;
			end
			//LD REG
			REG_LD_MEM_READ : begin
				mem_read <= 1'b1;
			end
			REG_LD : begin
				if (register == 1'b0) begin
					reg_signal <= 4'b0100;
				end	
				else if(register == 1'b1) begin
					reg_signal <= 4'b0001;
				end
			end
			//ST ACC
			ACC_ST : begin
				STA_signal <= 1'b1;
			end
			ACC_ST_MEM_WRITE : begin
				mem_write <= 1'b1;
			end
			//LD ACC 
			ACC_LD_MEM_READ : begin
				mem_read <= 1'b1;
			end
			ACC_LD : begin
				LDA_signal <= 1'b1;
			end
			//Jump for branch ---------------------------------------------------------
			JUMP_BRANCH : begin
				pc_save_address_from_instr_mem <= 1'b1;
			end
			//JMP stack
			PUSH_SP : begin
				PUSH <= 1'b1;
				// mem_write <= 1'b1;
			end
			PC_JUMP_AFTER_PUSH : begin
				//Momentan nu e nevoie de nimic
			end
			//RET 
			PULL_SP : begin
				mem_read <= 1'b1;
				POP <= 1'b1;
			end
			PC_JUMP_AFTER_PULL : begin
				pc_save_address_from_data_mem <= 1'b1;
			end
			//ALU OP -----------------------------------------------------------------
			SELECT_REG_ALU : begin
				if (register == 1'b0) begin
					reg_signal <= 4'b1000;
				end
				else if (register == 1'b1) begin
					reg_signal <= 4'b0010;
				end
			end
			START_ALU : begin
				Start_ALU_operation <= 1'b1;

				if(opcode == 6'b010010) begin
					mov_enable <= 1'b1;
				end
			end
			SAVE_ACC : begin
				signal_save_after_alu <= 1'b1;
			end
			//Crypto ----------------------------------------------------------------
			CRYPTO_MEM_READ : begin
				mem_read <= 1'b1;
			end
			CRYPTO_SEND_KEY : begin
				if (register == 1'b0) begin
					start_crypt <= 1'b1;
				end
				else if (register == 1'b1) begin
					start_decrypt <= 1'b1;
				end
				Load_data <= 1'b1;
			end
			CRYPTO_ACTIV : begin
				start_execute_crypto <= 1'b1;
			end
			CRYPTO_MEM_WRITE : begin
				Store_data <= 1'b1;
			end
			CRYPTO_SAVE_KEY : begin
				mem_write <= 1'b1;
			end
			//End
			END_EXECUTION : begin
				fin <= 1'b1;
			end

		endcase

	end
 	
endmodule


//Testbench

module ControlUnit_tb_ii();

    reg clk;
    reg rst;
    reg bgn;
    reg fin_crypto;
    reg fin_file;
    reg [5:0] opcode;
    reg [3:0] flags;
    reg Alu_busy;
    reg register;

    wire [3:0] reg_signal;
    wire STA_signal;
    wire LDA_signal;
    wire Load_data;
    wire Store_data;
    wire mem_read;
    wire mem_write;
    wire start_crypt;
    wire start_decrypt;
    wire start_execute_crypto;
    wire read_file;
    wire read_memory;
    wire PUSH;
    wire POP;
    wire pc_save_address_from_instr_mem;
    wire pc_save_address_from_data_mem;
    wire pc_save_address_from_counter;
    wire Increm_PC;
    wire Start_ALU_operation;

    control_unit uut (
        .clk(clk),
        .rst(rst),
        .bgn(bgn),
        .fin_crypto(fin_crypto),
        .fin_file(fin_file),
        .opcode(opcode),
        .flags(flags),
        .Alu_busy(Alu_busy),
        .register(register),
        .reg_signal(reg_signal),
        .STA_signal(STA_signal),
        .LDA_signal(LDA_signal),
        .Load_data(Load_data),
        .Store_data(Store_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .start_crypt(start_crypt),
        .start_decrypt(start_decrypt),
        .start_execute_crypto(start_execute_crypto),
        .read_file(read_file),
        .read_memory(read_memory),
        .PUSH(PUSH),
        .POP(POP),
        .pc_save_address_from_instr_mem(pc_save_address_from_instr_mem),
        .pc_save_address_from_data_mem(pc_save_address_from_data_mem),
        .pc_save_address_from_counter(pc_save_address_from_counter),
        .Increm_PC(Increm_PC),
        .Start_ALU_operation(Start_ALU_operation)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end


    initial begin
        rst = 1;
        bgn = 0;
        fin_crypto = 1;
        fin_file = 0;
        opcode = 6'b001100;
        flags = 4'b0000;
        Alu_busy = 0;
        register = 0;

        #20; 
		rst = 0; 


		//ALU op
		#20;
		rst = 1;
		bgn = 1;
		fin_file = 1;

		#60;
		bgn = 0;

		//ST op
		#120;
		opcode = 6'b000001;

		//LD op
		#120;
		opcode = 6'b000010;

		//LDA
		#120;
		opcode = 6'b000100;

		//BRO
		#120;
		opcode = 6'b001000;

		//BRA
		#120
		opcode = 6'b001001;

		//Crypt
		#120;
		opcode = 6'b011110;

		//End
		#180;
		opcode = 6'b000000;

		#100;
        
        $stop; 
    end

endmodule
