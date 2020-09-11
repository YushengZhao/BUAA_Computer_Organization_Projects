`timescale 1ns / 1ps
`define rs 25:21
`define base 25:21
`define rt 20:16
`define rd 15:11
`define imm16 15:0
`define imm26 25:0
`define op 31:26
`define funct 5:0
`define shamt 10:6

module Datapath(
	input clk,
	input reset,
	input branch,
	input j,
	input jr,
	input GRF_WE,
	input [1:0] sel_rt_rd_31,
	input [1:0] sel_alu_dm_pc4,
	input sel_zero_sign,
	input sel_imm32_rt,
	input [2:0] ALUOp,
	input DM_RE,
	input DM_WE,
	input DM_isSigned,
	input [2:0] DM_opBytes,
	output equal,
	output [31:0] instr
    );

	wire [31:0] npc,pc,pc4,imm32;
	wire [31:0] rs,rt,ALU_result,DM_dout;
	wire en;
	assign en=1;
	
	PC programCounter(
		.nPC(npc),// input [31:0] nPC
		.en(en),// input en
		.reset(reset),// input reset
		.clk(clk),// input clk
		.PC(pc)// output [31:0] PC
	);
	
	NPC nextPC(
		.branch(branch),// input branch
		.j(j),// input j
		.jr(jr),// input jr
		.jumpReg(rs),// input [31:0] jumpReg
		.PC(pc),// input [31:0] PC
		.imm26(instr[`imm26]),// input [25:0] imm26
		.PC4(pc4),// output [31:0] PC4
		.nPC(npc)// output reg [31:0] nPC
	);
	
	IM instructionMemory(
		.addr(pc),// input [31:0] addr
		.data(instr)// output [31:0] data
	);
	
	wire [4:0] ra,to_writeReg;
	assign ra=5'h1f;
	Mux4 #(5) mux1 // #(parameter WIDTH=32)
	(
		.in0(instr[`rt]),// input [WIDTH-1:0] in0
		.in1(instr[`rd]),// input [WIDTH-1:0] in1
		.in2(ra),// input [WIDTH-1:0] in2
		.in3(),// input [WIDTH-1:0] in3
		.sel(sel_rt_rd_31),// input [1:0] sel
		.out(to_writeReg)// output reg [WIDTH-1:0] out
	);
	
	wire [31:0] to_writeData;
	Mux4 mux2// #(parameter WIDTH=32)
	(
		.in0(ALU_result),// input [WIDTH-1:0] in0
		.in1(DM_dout),// input [WIDTH-1:0] in1
		.in2(pc4),// input [WIDTH-1:0] in2
		.in3(),// input [WIDTH-1:0] in3
		.sel(sel_alu_dm_pc4),// input [1:0] sel
		.out(to_writeData)// output reg [WIDTH-1:0] out
	);
	
	GRF generalRegisterFile(
		.clk(clk),// input clk
		.reset(reset),// input reset
		.WE(GRF_WE),// input WE
		.reg1(instr[`rs]),// input [4:0] reg1
		.reg2(instr[`rt]),// input [4:0] reg2
		.writeReg(to_writeReg),// input [4:0] writeReg
		.writeData(to_writeData),// input [31:0] writeData
		.PC(pc),// input [31:0] PC
		.data1(rs),// output [31:0] data1
		.data2(rt)// output [31:0] data2
	);
	
	Extender extender // #(parameter from=16,to=32)
	(
		.din(instr[`imm16]),// input [from-1:0] din
		.selZeroSign(sel_zero_sign),// input selZeroSign
		.dout(imm32)// output [to-1:0] dout
	);
	
	wire [31:0] to_alu2;
	Mux2 mux3// #(parameter WIDTH=32)
	(
		.in0(imm32),// input [WIDTH-1:0] in0
		.in1(rt),// input [WIDTH-1:0] in1
		.sel(sel_imm32_rt),// input sel
		.out(to_alu2)// output [WIDTH-1:0] out
	);
	
	ALU arithmeticAndLogicUnit(
		.operand1(rs),// input [31:0] operand1
		.operand2(to_alu2),// input [31:0] operand2
		.ALUOp(ALUOp),// input [2:0] ALUOp
		.equal(equal),// output equal
		.result(ALU_result) // output reg [31:0] result
	);
	
	DM dataMemory(
		.clk(clk),// input clk
		.reset(reset),// input reset
		.WE(DM_WE),// input WE
		.RE(DM_RE),// input RE
		.isSigned(DM_isSigned),// input isSigned
		.opBytes(DM_opBytes),// input [2:0] opBytes
		.addr(ALU_result),// input [31:0] addr
		.din(rt),// input [31:0] din
		.dout(DM_dout), // output reg [31:0] dout
		.pc(pc)
	);
	
endmodule
	