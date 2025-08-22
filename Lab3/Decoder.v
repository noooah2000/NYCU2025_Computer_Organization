// student ID:314551161
module Decoder( 
	instr_op_i,
	ALU_op_o,
	ALUSrc_o,
	RegWrite_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
);

// I/O ports
input	[6-1:0] instr_op_i;

output	[2-1:0] ALU_op_o;
output	[2-1:0] RegDst_o, MemtoReg_o;
output  [2-1:0] Branch_o;
output			ALUSrc_o, RegWrite_o, Jump_o, MemRead_o, MemWrite_o;

// Internal Signals
wire op0, op1, op2, op3, op4, op5;
assign {op5, op4, op3, op2, op1, op0} = instr_op_i[5:0];
wire Rformat, addi, lw, sw, beq, bne, j, jal;

// Main function
assign Rformat = (~op0) & (~op1) & (~op2) & (~op3) & (~op4) & (~op5);
assign addi = (op0) & (~op1) & (~op2) & (op3) & (~op4) & (~op5);
assign lw = (~op0) & (~op1) & (op2) & (op3) & (~op4) & (op5);
assign sw = (~op0) & (~op1) & (op2) & (~op3) & (~op4) & (op5);
assign beq = (~op0) & (op1) & (op2) & (~op3) & (~op4) & (~op5);
assign bne = (op0) & (~op1) & (op2) & (~op3) & (~op4) & (~op5);
assign j = (op0) & (op1) & (op2) & (~op3) & (~op4) & (~op5);
assign jal = (op0) & (op1) & (~op2) & (~op3) & (~op4) & (~op5);

assign ALU_op_o = (Rformat) ? 2'b10 : ((beq | bne) ? 2'b01 : 2'b00);
assign RegDst_o = (jal) ? 2'b10 : (Rformat ? 2'b01 : 2'b00);
assign MemtoReg_o = (jal) ? 2'b10 : (lw ? 2'b01 : 2'b00);
assign Branch_o = (beq) ? 2'b01 : (bne ? 2'b10 : 2'b00);

assign ALUSrc_o = lw | sw | addi;
assign RegWrite_o = Rformat | lw | addi | jal;
assign Jump_o = j | jal;
assign MemRead_o = lw;
assign MemWrite_o = sw;

endmodule
                

