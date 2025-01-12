`include "../ALU/SUBSTRACTOR/FSC1bit.v"

module FSC4bit(a, b, bin, diff, bout);
    input [3:0] a, b;    
    input bin;           
    output [3:0] diff;   
    output bout;         

    wire [3:0] borrow;   

    FSC1bit fs0 (.a(a[0]), .b(b[0]), .bin(bin),      .diff(diff[0]), .bout(borrow[0]));
    FSC1bit fs1 (.a(a[1]), .b(b[1]), .bin(borrow[0]), .diff(diff[1]), .bout(borrow[1]));
    FSC1bit fs2 (.a(a[2]), .b(b[2]), .bin(borrow[1]), .diff(diff[2]), .bout(borrow[2]));
    FSC1bit fs3 (.a(a[3]), .b(b[3]), .bin(borrow[2]), .diff(diff[3]), .bout(bout));

endmodule
