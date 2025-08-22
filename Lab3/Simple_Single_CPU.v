// student ID:314551161

`include "ProgramCounter.v"
`include "Instr_Memory.v"
`include "Reg_File.v"
`include "Data_Memory.v"

`include "Adder.v"
`include "ALU.v"
`include "Decoder.v"
`include "ALU_Ctrl.v"
`include "MUX_2to1.v"
`include "MUX_3to1.v"
`include "MUX_4to1.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"

module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
// I/O port
input         clk_i;
input         rst_i;

// Internal Signals
wire [32-1:0] pc_next, pc_curr, pc_add4, pc_branch, pc_after_MUXbranch;
wire [32-1:0] instr;
wire [5-1:0] write_reg_addr;
wire [32-1:0] write_reg_data, read_reg_data1, read_reg_data2;
wire [2-1:0] ALU_op, RegDst, Branch, MemtoReg;
wire ALUSrc, RegWrite, Jump, MemRead, MemWrite;
wire [32-1:0] immediate, immediate_sl2;
wire [4-1:0] ALU_signal;
wire [32-1:0] ALU_src2;
wire [32-1:0] ALU_result;
wire zero, cout, overflow;
wire [32-1:0] mem_read_data;


// Components
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

Instr_Memory IM(
        .pc_addr_i(pc_curr),  
        .instr_o(instr)    
);

Decoder Decoder(
        .instr_op_i(instr[31:26]),
	.ALU_op_o(ALU_op),
	.ALUSrc_o(ALUSrc),
	.RegWrite_o(RegWrite),
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)
);

MUX_3to1 #(.size(5)) MUX_RegDst(
        .src1(instr[20:16]),
        .src2(instr[15:11]),
        .src3(5'd31),
        .select(RegDst),
        .result(write_reg_addr)
);

Reg_File Registers(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(write_reg_addr), 
        .RDdata_i(write_reg_data),
        .RegWrite_i(RegWrite),
        .RSdata_o(read_reg_data1),  
        .RTdata_o(read_reg_data2) 
);

Sign_Extend Sign_Extend(
        .data_i(instr[15:0]),
        .data_o(immediate)
);

ALU_Ctrl ALU_Ctrl(
        .funct_i(instr[5:0]),
        .ALUOp_i(ALU_op),
        .ALUCtrl_o(ALU_signal)        
);

MUX_2to1 #(.size(32)) MUX_ALUSrc(
        .src1(read_reg_data2),
        .src2(immediate),
        .select(ALUSrc),
        .result(ALU_src2)
);

ALU ALU(
        .rst_n(1'b1),
        .shamt(instr[10:6]),
        .src1(read_reg_data1),
        .src2(ALU_src2),
        .ALU_control(ALU_signal),
        .result(ALU_result),
        .zero(zero),
        .cout(cout),
        .overflow(overflow)
);

Shift_Left_Two_32 Shift_Left_Two_32(
        .data_i(immediate),
        .data_o(immediate_sl2)
);

Adder Adder_branch(
        .src1_i(pc_curr),
        .src2_i(immediate_sl2),
        .sum_o(pc_branch)
);

wire Branch_select;
assign Branch_select = (Branch[0] & zero) | (Branch[1] & (~zero));
MUX_2to1 #(.size(32)) MUX_branch(
        .src1(pc_add4),
        .src2(pc_branch),
        .select(Branch_select),
        .result(pc_after_MUXbranch)
);

MUX_2to1 #(.size(32)) MUX_jump(
        .src1(pc_after_MUXbranch),
        .src2({pc_add4[31:28], instr[25:0], 2'b00}),
        .select(Jump),
        .result(pc_next)
);
	
Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(ALU_result), 
	.data_i(read_reg_data2), 
	.MemRead_i(MemRead), 
	.MemWrite_i(MemWrite), 
	.data_o(mem_read_data)
);

MUX_3to1 #(.size(32)) MUX_MemtoReg(
        .src1(ALU_result),
        .src2(mem_read_data),
        .src3(pc_add4),
        .select(MemtoReg),
        .result(write_reg_data)
);

endmodule
