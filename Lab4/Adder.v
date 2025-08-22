// student ID: 314551161
module Adder(
    src1_i,
    src2_i,
    sum_o
);

// I/O ports
input  [31:0] src1_i;
input  [31:0] src2_i;
output [31:0] sum_o;

// Main function
assign sum_o = src1_i + src2_i;

endmodule
