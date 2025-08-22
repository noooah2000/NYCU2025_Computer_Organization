// student ID: 314551161
`timescale 1ns/1ps


module ALU_1bit(
	input				src1,
	input				src2,
	input				less,
	input 				Ainvert,
	input				Binvert,
	input 				cin,
	input 	    [1:0]	operation,
	output reg          result,
	output reg          cout
);

wire A, B, res;

MUX_2to1 #(.size(1)) A_invert (
	.src1(src1),
	.src2(~src1),
	.select(Ainvert),
	.result(A)
);

MUX_2to1 #(.size(1)) B_invert (
	.src1(src2),
	.src2(~src2),
	.select(Binvert),
	.result(B)
);

MUX_4to1 #(.size(1)) op (
	.src1(A | B),
	.src2(A & B),
	.src3(A ^ B ^ cin),
	.src4(less),
	.select(operation),
	.result(res)
);

// 輸出
always@(*) begin
	result = res;
	cout = (A & B) | (A & cin) | (B & cin);
end

endmodule
