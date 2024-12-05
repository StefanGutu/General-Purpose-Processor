module proces_data(
    input clk,
    input rst,
    input [15:0] line_data,
    output reg [5:0] opcode,                    //opcode will go to ALU
    output reg [1:0] reg_x_or_y,                //reg_x_or_y will have a block to choose which reg to activate
    output reg [8:0] address_to_go,             //the address will be send where its needs to be with the type
    output reg [15:0] value_extended,           //this will extend the value that gets as 9 bits to 16 bits
    output reg [1:0] type                       //will choose a type that the instructions are

);

    //Explicatie:
    //Type 1 - instructiuni de LDR,STR 
    //Type 2 - instructiune de branch
    //Type 3 - instructiune de operatie logice sau aritmetica

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            type <= 2'b0;
            opcode <= 6'b0;
            reg_x_or_y <= 2'b0;
            address_to_go <= 9'b0;
            value_extended <= 16'b0;
        end
        else begin
            if(line_data[15:10] > 6'b000000 && line_data[15:10] <= 6'b000010) begin
                type <= 2'b01;

                if (line_data[9] == 0) begin        // setare registru 
                    reg_x_or_y <= 2'b01;            //registru x
                end
                else begin
                    reg_x_or_y <= 2'b10;            //registru y
                end
                opcode <= line_data[15:10];
                value_extended <= {7'b0 ,line_data[8:0]};

            end
            if(line_data[15:10] >= 6'b000011 && line_data[15:10] <= 6'b001001) begin
                type <= 2'b10;

                opcode <= line_data[15:10];             
                address_to_go <= line_data[8:0];

            end
            if(line_data[15:10] >= 6'b001010) begin
                type <= 2'b11;

                if (line_data[9] == 0) begin
                    reg_x_or_y <= 2'b01;                        //registru x
                end
                else begin
                    reg_x_or_y <= 2'b10;                        //registru y
                end
                opcode <= line_data[15:10]-9;                   //se scade cu 9 pentru a ramane la standardu din ALU              
                value_extended <= {7'b0 ,line_data[8:0]};

            end


            
        end
    end

endmodule

//----------------------------------------------------------------------------------------------------------------

module tb_proces_data;

    // Intrări
    reg clk;
    reg rst;
    reg [15:0] line_data;

    // Ieșiri
    wire [5:0] opcode;
    wire [1:0] reg_x_or_y;
    wire [8:0] address_to_go;
    wire [15:0] value_extended;
    wire [1:0] type;

    // Instanțierea DUT (Device Under Test)
    proces_data dut (
        .clk(clk),
        .rst(rst),
        .line_data(line_data),
        .opcode(opcode),
        .reg_x_or_y(reg_x_or_y),
        .address_to_go(address_to_go),
        .value_extended(value_extended),
        .type(type)
    );

    // Generarea semnalului de ceas
    initial clk = 0;
    always #50 clk = ~clk; // Perioada de ceas: 100ns (50ns high, 50ns low)

    // Testbench
    initial begin
        // Resetare inițială
 
        line_data = 16'b0;
        rst = 1'b0; // Reset activat
        #100;
        rst = 1'b1; // Reset dezactivat
        // Testare pentru tipul 2'b01 (<= 6'b000010)
        line_data = 16'b000010_0_000000001; // opcode=000001, reg_x_or_y=01, value=000000001
        #100;
        $display("Test 1: opcode=%b, reg_x_or_y=%b, value_extended=%b, address_to_go=%b, type=%b",
                 opcode, reg_x_or_y, value_extended, address_to_go, type);

        line_data = 16'b000001_0_000000001; // opcode=000001, reg_x_or_y=01, value=000000001
        #100;
        $display("Test 1.1: opcode=%b, reg_x_or_y=%b, value_extended=%b, address_to_go=%b, type=%b",
                 opcode, reg_x_or_y, value_extended, address_to_go, type);


        // Testare pentru tipul 2'b10 (> 6'b000010 și <= 6'b001001)
        line_data = 16'b000011_0_000000010; // opcode=000011, address=000000010
        #100;
        $display("Test 2: opcode=%b, reg_x_or_y=%b, value_extended=%b, address_to_go=%b, type=%b",
                 opcode, reg_x_or_y, value_extended, address_to_go, type);

        // Testare pentru tipul 2'b11 (> 6'b001001)
        line_data = 16'b001010_1_000000011; // opcode=001010, reg_x_or_y=10, value=000000011
        #100;
        $display("Test 3: opcode=%b, reg_x_or_y=%b, value_extended=%b, address_to_go=%b, type=%b",
                 opcode, reg_x_or_y, value_extended, address_to_go, type);

        // Finalizare test
        #200;
        $finish;
    end

endmodule
