module data_mem #(parameter WIDTH=15)(
    input clk,               // Clock signal

    //Address from Instr mem
    input [8:0] address,     // 9 bit address for accessing up to 400 locations

    //Reg X, Y
    input [WIDTH:0] write_data, // 16 bit data to write to memory
    input mem_write,         // control signal for memory write operation
    output reg [WIDTH:0] read_data,

    //ACC
    input signal_acc_data_write,  
    input [15:0] acc_data,
    output reg [15:0] acc_read_data,

    //PC and SP
    input signal_pc_data_write,
    input [8:0] sp_address,
    input [15:0] pc_data,
    output reg [15:0] pc_read_data,

    //Crypto
    input signal_crypto_data_write,
    input [15:0]  crypto_data,
    output reg [15:0] crypto_read_data

);

    // declare memory: 400 locations, each 16 bits wide
    reg [15:0] memory [0:399];

    // handle write operations on the rising edge of the clock
    always @(posedge clk) begin
        if (mem_write) begin
            //write the input data to the memory at the specified address
            memory[address] <= write_data;
        end
        if (signal_acc_data_write == 1'b1) begin
            memory[address] <= acc_data;
        end
        if (signal_pc_data_write == 1'b1) begin
            memory[sp_address] <= pc_data;
        end
        if(signal_crypto_data_write == 1'b1) begin
            memory[address] <= crypto_data;
        end
    end


    always @(*) begin
        read_data <= memory[address];
        acc_read_data <= memory[address];
        pc_read_data <= memory[sp_address] + 1'b1;
        crypto_read_data <= memory[address];
    end

endmodule


module data_mem_tb;

    reg clk;                     
    reg [8:0] address;           
    reg [15:0] write_data;       
    reg mem_write;               
    reg mem_read;                
    wire [15:0] read_data;       

    // Instantiate the DUT (Device Under Test)
    data_mem uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Testbench procedure
    initial begin
        // Initialize signals
        address = 0;             
        write_data = 0;          
        mem_write = 0;           
        mem_read = 0;            

        // Write operations: Write different values to different addresses
        #10
        address = 9'd0; write_data = 16'hAAAA; mem_write = 1; // Write 0xAAAA to address 0
        #10
        mem_write = 0;

        #10
        address = 9'd1; write_data = 16'hBBBB; mem_write = 1; // Write 0xBBBB to address 1
        #10
        mem_write = 0;

        #10
        address = 9'd2; write_data = 16'hCCCC; mem_write = 1; // Write 0xCCCC to address 2
        #10
        mem_write = 0;

        #10
        address = 9'd3; write_data = 16'hDDDD; mem_write = 1; // Write 0xDDDD to address 3
        #10
        mem_write = 0;

        // Read operations: Read from the written addresses
        #10
        address = 9'd0; mem_read = 1; // Read from address 0
        #10
        mem_read = 0;

        #10
        address = 9'd1; mem_read = 1; // Read from address 1
        #10
        mem_read = 0;

        #10
        address = 9'd2; mem_read = 1; // Read from address 2
        #10
        mem_read = 0;

        #10
        address = 9'd3; mem_read = 1; // Read from address 3
        #10
        mem_read = 0;

        #20
        $display("Testbench completed.");
        $finish;
    end

endmodule
