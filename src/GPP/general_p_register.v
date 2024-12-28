module general_purpose_registers (
    input clk,                // Clock signal
    input rst,                // Reset signal (active low)
    input [15:0] data_in,     // Data input
    input reg_write_x,        // Control signal to write to register X
    input reg_write_y,        // Control signal to write to register Y
	input reg_write_accumulator,// Control signal to write to register accumulator
    input reg_read_x,         // Control signal to read from register X
    input reg_read_y,         // Control signal to read from register Y
	input reg_read_accumulator,// Control signal to read from register accumulator
    output reg [15:0] data_out, // Data output from register X sau Y
    //output reg [15:0] data_out, // Data output from register Y
	output reg [15:0] data_out_accumulator // Data output from register accumulator
);

    // Registers X , Y and accumulator
    reg [15:0] reg_x;
    reg [15:0] reg_y;
	reg [15:0] reg_accumulator;
    // Write operations on the rising edge of the clock
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_x <= 16'b0; // Reset register X
            reg_y <= 16'b0; // Reset register Y
			reg_accumulator <=16'b0;//Reset register accumulator
        end else begin
            if (reg_write_x) reg_x <= data_in; // Write to register X
            if (reg_write_y) reg_y <= data_in; // Write to register Y
			if (reg_write_accumulator) reg_accumulator <= data_in; // Write to register accumulator
        end
    end

    // Read operations
    always @(*) begin
        if (reg_read_x) data_out= reg_x; // Read from register X
        else 
		begin		
			if (reg_read_y) data_out= reg_y; // Read from register Y
			else data_out = 16'b0;           // Default output
		end
		if (reg_read_accumulator) data_out_accumulator = reg_accumulator; // Read from register accumulator
        else data_out_accumulator = 16'b0;           // Default output
    end

endmodule

`timescale 1ns/1ps

module general_purpose_registers_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [15:0] data_in;
    reg reg_write_x;
    reg reg_write_y;
    reg reg_write_accumulator;
    reg reg_read_x;
    reg reg_read_y;
    reg reg_read_accumulator;
    wire [15:0] data_out;
    //wire [15:0] data_out_y;
    wire [15:0] data_out_accumulator;

    // Instantiate the general-purpose registers module
    general_purpose_registers uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .reg_write_x(reg_write_x),
        .reg_write_y(reg_write_y),
        .reg_write_accumulator(reg_write_accumulator),
        .reg_read_x(reg_read_x),
        .reg_read_y(reg_read_y),
        .reg_read_accumulator(reg_read_accumulator),
        .data_out(data_out),
        .data_out_accumulator(data_out_accumulator)
    );

    // Clock generation (50MHz)
    initial clk = 0;
    always #10 clk = ~clk; // 20ns period

    // Test procedure
    initial begin
        // Initialize signals
        rst = 0; data_in = 16'b0;
        reg_write_x = 0; reg_write_y = 0; reg_write_accumulator = 0;
        reg_read_x = 0; reg_read_y = 0; reg_read_accumulator = 0;

        // Apply reset
        $display("Applying Reset");
        #5 rst = 1; // Release reset after 5ns
        #10 rst = 0; // Apply reset
        #20 rst = 1; // End reset

        // Write to register X
        $display("Writing to Register X");
        #20 data_in = 16'hA5A5; reg_write_x = 1;
        #20 reg_write_x = 0;

        // Write to register Y
        $display("Writing to Register Y");
        #20 data_in = 16'h5A5A; reg_write_y = 1;
        #20 reg_write_y = 0;

        // Write to accumulator
        $display("Writing to Accumulator");
        #20 data_in = 16'h1234; reg_write_accumulator = 1;
        #20 reg_write_accumulator = 0;

        // Read from register X
        $display("Reading from Register X");
        #20 reg_read_x = 1;
        #20 reg_read_x = 0;

        // Read from register Y
        $display("Reading from Register Y");
        #20 reg_read_y = 1;
        #20 reg_read_y = 0;

        // Read from accumulator
        $display("Reading from Accumulator");
        #20 reg_read_accumulator = 1;
        #20 reg_read_accumulator = 0;

        // Simultaneous writes to all registers
        $display("Simultaneous Writes to X, Y, and Accumulator");
        #20 data_in = 16'hBEEF; reg_write_x = 1; reg_write_y = 1; reg_write_accumulator = 1;
        #20 reg_write_x = 0; reg_write_y = 0; reg_write_accumulator = 0;

        // Simultaneous reads from all registers
        $display("Simultaneous Reads from X, Y, and Accumulator");
        #20 reg_read_x = 1; reg_read_y = 1; reg_read_accumulator = 1;
        #20 reg_read_x = 0; reg_read_y = 0; reg_read_accumulator = 0;

        // Reset during write
        $display("Testing Reset During Write");
        #20 data_in = 16'hFACE; reg_write_x = 1;
        #10 rst = 0; // Reset while writing
        #20 rst = 1; reg_write_x = 0;

        // Verify reset clears all registers
        $display("Verifying Reset Clears All Registers");
        #20 reg_read_x = 1; reg_read_y = 1; reg_read_accumulator = 1;
        #20 reg_read_x = 0; reg_read_y = 0; reg_read_accumulator = 0;

        // Finish simulation
        $stop;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %t | rst: %b | data_in: %h | write_x: %b | write_y: %b | write_accumulator: %b | read_x: %b | read_y: %b | read_accumulator: %b | data_out: %h | data_out_accumulator: %h",
                 $time, rst, data_in, reg_write_x, reg_write_y, reg_write_accumulator, reg_read_x, reg_read_y, reg_read_accumulator, data_out, data_out_accumulator);
    end

endmodule
