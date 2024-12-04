module instr_mem(
    input clk,
    input rst,
    input read_file, read_memory,
    input [8:0] pos, 
    output reg fin_file,
    output reg [15:0] return_instr_line
);
    reg [8:0] counter_elem;
    reg [15:0] line_from_file;      // line of data we will read 
    reg [15:0] instruction_data [0:399];  // Reg where will be all the data saved

    //for reading data from file
    `define NULL 0
    integer data_file;
    integer scan_file;

    initial begin
        data_file = $fopen("res_in_bin.txt", "r");
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $finish;
        end
    end

    always @(posedge clk, negedge rst) begin
        if(rst ==1'b1) begin
            counter_elem = 0;
            line_from_file = 0;
            fin_file = 0;
        end
        else begin
            if(read_file == 1'b1) begin
                scan_file = $fscanf(data_file, "%b\n", line_from_file); 
                if ($feof(data_file)) begin //Will activate the semnal to stop reading from the file
                    fin_file = 1'b1;
                end 
                instruction_data[counter_elem] = line_from_file[15:0]; //saves the line in memory
                counter_elem = counter_elem + 1; //increment the position where to save
                //need to add a checker when you are near 400
            end
            else if(read_memory == 1'b1) begin //signal to read from the memory
                return_instr_line[15:0] = instruction_data[pos];    //with pos you specify where to read from instruction memory
                                                                    //will help us with branch
            end
        end   
        // $monitor(line_from_file);
    end


endmodule



module tb_instr_mem;

    // Inputs
    reg rst;
    reg read_file;
    reg read_memory;
    reg [8:0] pos;
    reg clk;

    // Outputs
    wire fin_file;
    wire [15:0] return_instr_line;

    // Instantiate the DUT (Device Under Test)
    instr_mem dut (
        .clk(clk),
        .rst(rst),
        .read_file(read_file),
        .read_memory(read_memory),
        .pos(pos),
        .fin_file(fin_file),
        .return_instr_line(return_instr_line)
    );

    // Clock generation
    initial clk = 0;
    always #50 clk = ~clk; // 10ns clock period

    // Testbench procedure
    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
        read_file = 1'b1;
        while (fin_file == 1'b0) begin
            #100
            read_file = 1'b1;
        end
        read_file = 1'b0;
        #100;
        pos = 9'b000000000;
        read_memory = 1'b1;
        #100;
        pos = 9'b000000001;
        #100;
        pos = 9'b000000010;
        #100;
        pos = 9'b000000011;
        #200
        read_memory = 1'b0;
        #100
        $finish;
    end

endmodule
