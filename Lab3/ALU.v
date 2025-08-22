//Student ID: 314551161
`timescale 1ns/1ps
`include "ALU_1bit.v"
module ALU(
	input                   rst_n,         // negative reset            (input)
	input		 [ 5-1:0]	shamt,
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);

wire [32:0] carry;
assign carry[0] = ALU_control[2];
wire set;
assign set = ($signed(src1) < $signed(src2)) ? 1'b1 : 1'b0;
wire [31:0] result_w;


genvar i;
generate
	for (i=0; i<32; i=i+1) begin: ALU_bit
		ALU_1bit alu (
			.src1(src1[i]),
			.src2(src2[i]),
			.less((i == 0) ? set : 1'b0),
			.Ainvert(ALU_control[3]),
			.Binvert(ALU_control[2]),
			.cin(carry[i]),
			.operation(ALU_control[1:0]),
			.result(result_w[i]),
			.cout(carry[i+1])
		);
	end
endgenerate

always @(*) begin
	result = result_w;

	case (ALU_control)
		4'b1000: result = src2 << shamt; //sll
		4'b1001: result = src2 >> shamt; //srl
		4'b1010: result = src2 << src1[4:0]; //sllv
		4'b1011: result = src2 >> src1[4:0]; //srlv
		default: result = result_w;
	endcase

	zero = ~(| result);
	if ({ALU_control[3], ALU_control[1:0]} == 3'b010) begin
		overflow = carry[31] ^ carry[32];
		cout = carry[32];
	end
	else begin
		overflow = 0;
		cout = 0;
	end
end

endmodule