//Student ID: 314551161
`timescale 1ns/1ps
`include "MUX_2to1.v"
`include "MUX_4to1.v"

module ALU_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output reg          result,     //1 bit result    (output)
	output reg          cout        //1 bit carry out (output)
	);

wire a_out, b_out, mux_result;
wire ab_and, ab_or, ab_sum;

MUX_2to1 MUX_A(
	.src1(src1),
	.src2(~src1),
	.select(Ainvert),
	.result(a_out)
);
MUX_2to1 MUX_B(
	.src1(src2),
	.src2(~src2),
	.select(Binvert),
	.result(b_out)
);

assign ab_or = a_out | b_out;
assign ab_and = a_out & b_out;
assign ab_sum = a_out ^ b_out ^ cin;

MUX_4to1 MUX_result(
	.src1(ab_or),
	.src2(ab_and),
	.src3(ab_sum),
	.src4(less),
	.select(operation),
	.result(mux_result)
);

always @(*) begin
	result = mux_result;
	cout = (a_out&b_out) | (a_out&cin) | (b_out&cin);
end

endmodule