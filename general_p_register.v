module general_purpose_registers (
    input clk,                // Clock signal
    input rst,                // Reset signal (active low)
    input [15:0] data_in,     // Data input
    input reg_write_x,        // Control signal to write to register X
    input reg_write_y,        // Control signal to write to register Y
    input reg_read_x,         // Control signal to read from register X
    input reg_read_y,         // Control signal to read from register Y
    output reg [15:0] data_out_x, // Data output from register X
    output reg [15:0] data_out_y  // Data output from register Y
);

    // Registers X and Y
    reg [15:0] reg_x;
    reg [15:0] reg_y;

    // Write operations on the rising edge of the clock
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_x <= 16'b0; // Reset register X
            reg_y <= 16'b0; // Reset register Y
        end else begin
            if (reg_write_x) reg_x <= data_in; // Write to register X
            if (reg_write_y) reg_y <= data_in; // Write to register Y
        end
    end

    // Read operations
    always @(*) begin
        if (reg_read_x) data_out_x = reg_x; // Read from register X
        else data_out_x = 16'b0;           // Default output

        if (reg_read_y) data_out_y = reg_y; // Read from register Y
        else data_out_y = 16'b0;           // Default output
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
    reg reg_read_x;
    reg reg_read_y;
    wire [15:0] data_out_x;
    wire [15:0] data_out_y;

    // Instantiate the general-purpose registers module
    general_purpose_registers uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .reg_write_x(reg_write_x),
        .reg_write_y(reg_write_y),
        .reg_read_x(reg_read_x),
        .reg_read_y(reg_read_y),
        .data_out_x(data_out_x),
        .data_out_y(data_out_y)
    );

    // Clock generation (50MHz)
    initial clk = 0;
    always #10 clk = ~clk; // 20ns period

    // Test procedure
    initial begin
        // Initialize signals
        rst = 0; data_in = 16'b0;
        reg_write_x = 0; reg_write_y = 0;
        reg_read_x = 0; reg_read_y = 0;

        // Apply reset
        #5 rst = 1; // Release reset after 5ns
        #10 rst = 0; // Apply reset
        #20 rst = 1; // End reset

        // Write to register X
        #20 data_in = 16'hA5A5; reg_write_x = 1;
        #20 reg_write_x = 0;

        // Write to register Y
        #20 data_in = 16'h5A5A; reg_write_y = 1;
        #20 reg_write_y = 0;

        // Read from register X
        #20 reg_read_x = 1;
        #20 reg_read_x = 0;

        // Read from register Y
        #20 reg_read_y = 1;
        #20 reg_read_y = 0;

        // Check reset behavior
        #20 rst = 0;
        #20 rst = 1;

        // Finish simulation
        #100 ;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %t | rst: %b | data_in: %h | write_x: %b | write_y: %b | read_x: %b | read_y: %b | data_out_x: %h | data_out_y: %h",
                 $time, rst, data_in, reg_write_x, reg_write_y, reg_read_x, reg_read_y, data_out_x, data_out_y);
    end

endmodule
