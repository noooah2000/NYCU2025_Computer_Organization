// ID

`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "Instruction_Memory.v"
`include "MUX_2to1.v"
`include "MUX_4to1.v"
`include "Pipe_Reg.v"
`include "ProgramCounter.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"

`timescale 1ns / 1ps

module Pipe_CPU(
    clk_i,
    rst_i
    );

input clk_i;
input rst_i;

// TO DO

// Internal signal
wire [32-1:0] pc_next, pc_curr, pc_add4, pc_branch, pc_after_MUXbranch;
wire [32-1:0] instr;
wire [5-1:0] write_reg_addr;
wire [32-1:0] write_reg_data, read_reg_data1, read_reg_data2;
wire [2-1:0] ALU_op, Branch;
wire ALUSrc, RegWrite, Jump, MemRead, MemWrite, RegDst, MemtoReg;
wire [32-1:0] immediate, immediate_sl2;
wire [4-1:0] ALU_signal;
wire [32-1:0] ALU_src2;
wire [32-1:0] ALU_result;
wire zero, cout, overflow;
wire [32-1:0] mem_read_data;


// IF stage======================
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_next),   
        .pc_out_o(pc_curr) 
);

Adder Adder_PC(
        .src1_i(pc_curr),
        .src2_i(32'd4),
        .sum_o(pc_add4)
);

Instruction_Memory IM(
        .addr_i(pc_curr),  
        .instr_o(instr)    
);

wire Branch_select;
MUX_2to1 #(.size(32)) MUX_branch(
        .src1(pc_add4),
        .src2(ME_pc_branch),
        .select(Branch_select),
        .result(pc_next)
);

//--------------------------------
wire [31:0] ID_pc, ID_instr;
Pipe_Reg #(.size(32)) IF_ID_pc(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(pc_curr),
        .data_o(ID_pc)
);

Pipe_Reg #(.size(32)) IF_ID_instr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(instr),
        .data_o(ID_instr)
);
//--------------------------------
// ID stage======================
Decoder Decoder(
        .instr_op_i(ID_instr[31:26]),
        .ALU_op_o(ALU_op),
        .ALUSrc_o(ALUSrc),
        .RegWrite_o(RegWrite),
        .RegDst_o(RegDst),
        .Branch_o(Branch),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg)
);

Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(ID_instr[25:21]),
        .RTaddr_i(ID_instr[20:16]),
        .RDaddr_i(WB_write_reg_addr), 
        .RDdata_i(write_reg_data),
        .RegWrite_i(WB_WB[0]),
        .RSdata_o(read_reg_data1),  
        .RTdata_o(read_reg_data2) 
);

Sign_Extend Sign_Extend(
        .data_i(ID_instr[15:0]),
        .data_o(immediate)
);

//--------------------------------
wire [1:0] EX_WB;
wire [3:0] EX_M;
wire [3:0] EX_EX;
Pipe_Reg #(.size(2)) ID_EX_WB(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({MemtoReg, RegWrite}),
        .data_o(EX_WB)
);

Pipe_Reg #(.size(4)) ID_EX_M(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({Branch, MemRead, MemWrite}),
        .data_o(EX_M)
);

Pipe_Reg #(.size(4)) ID_EX_EX(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({ALU_op, ALUSrc, RegDst}),
        .data_o(EX_EX)
);

wire [31:0] EX_pc, EX_immediate;
wire [63:0] EX_read_data;
wire [9:0]  EX_reg_addr;
Pipe_Reg #(.size(32)) ID_EX_pc(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ID_pc),
        .data_o(EX_pc)
);

Pipe_Reg #(.size(64)) ID_EX_read_reg_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({read_reg_data1, read_reg_data2}),
        .data_o(EX_read_data)
);

Pipe_Reg #(.size(32)) ID_EX_immediate(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(immediate),
        .data_o(EX_immediate)
);

Pipe_Reg #(.size(10)) ID_EX_reg_addr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ID_instr[20:11]),
        .data_o(EX_reg_addr)
);
//--------------------------------

// EX stage======================
Shift_Left_Two_32 Shift_Left_Two_32(
        .data_i(EX_immediate),
        .data_o(immediate_sl2)
);

Adder Adder_branch(
        .src1_i(EX_pc),
        .src2_i(immediate_sl2),
        .sum_o(pc_branch)
);

MUX_2to1 #(.size(32)) MUX_ALUSrc(
        .src1(EX_read_data[31:0]),
        .src2(EX_immediate),
        .select(EX_EX[1]),
        .result(ALU_src2)
);

ALU_Ctrl ALU_Ctrl(
        .funct_i(EX_immediate[5:0]),
        .ALUOp_i(EX_EX[3:2]),
        .ALUCtrl_o(ALU_signal)        
);

ALU ALU(
        .rst_n(1'b1),
        .src1(EX_read_data[63:32]),
        .src2(ALU_src2),
        .ALU_control(ALU_signal),
        .result(ALU_result),
        .zero(zero),
        .cout(cout),
        .overflow(overflow)
);

MUX_2to1 #(.size(5)) MUX_RegDst(
        .src1(EX_reg_addr[9:5]),
        .src2(EX_reg_addr[4:0]),
        .select(EX_EX[0]),
        .result(write_reg_addr)
);

//--------------------------------
wire [1:0] ME_WB;
wire [3:0] ME_M;
Pipe_Reg #(.size(2)) EX_ME_WB(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(EX_WB),
        .data_o(ME_WB)
);

Pipe_Reg #(.size(4)) EX_ME_M(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(EX_M),
        .data_o(ME_M)
);

wire [31:0] ME_pc_branch, ME_ALU_result, ME_sw_data;
wire ME_zero;
wire [4:0] ME_write_reg_addr;
Pipe_Reg #(.size(32)) EX_ME_pc_branch(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(pc_branch),
        .data_o(ME_pc_branch)
);

Pipe_Reg #(.size(32)) EX_ME_ALU_result(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ALU_result),
        .data_o(ME_ALU_result)
);

Pipe_Reg #(.size(1)) EX_ME_zero(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(zero),
        .data_o(ME_zero)
);

Pipe_Reg #(.size(32)) EX_ME_sw_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(EX_read_data[31:0]),
        .data_o(ME_sw_data)
);

Pipe_Reg #(.size(5)) EX_ME_write_reg_addr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(write_reg_addr),
        .data_o(ME_write_reg_addr)
);
//--------------------------------
// MEM stage======================
assign Branch_select = (ME_M[2] & ME_zero) | (ME_M[3] & (~ME_zero));

Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(ME_ALU_result), 
	.data_i(ME_sw_data), 
	.MemRead_i(ME_M[1]), 
	.MemWrite_i(ME_M[0]), 
	.data_o(mem_read_data)
);

//--------------------------------
wire [1:0] WB_WB;
Pipe_Reg #(.size(2)) ME_WB_WB(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ME_WB),
        .data_o(WB_WB)
);

wire [31:0] WB_mem_read_data, WB_ALU_result;
wire [4:0] WB_write_reg_addr;
Pipe_Reg #(.size(32)) ME_WB_read_mem_data(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(mem_read_data),
        .data_o(WB_mem_read_data)
);

Pipe_Reg #(.size(32)) ME_WB_ALU_result(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ME_ALU_result),
        .data_o(WB_ALU_result)
);

Pipe_Reg #(.size(5)) ME_WB_write_reg_addr(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i(ME_write_reg_addr),
        .data_o(WB_write_reg_addr)
);
//--------------------------------
// WB stage======================
MUX_2to1 #(.size(32)) MUX_MemtoReg(
        .src1(WB_ALU_result),
        .src2(WB_mem_read_data),
        .select(WB_WB[1]),
        .result(write_reg_data)
);

endmodule

