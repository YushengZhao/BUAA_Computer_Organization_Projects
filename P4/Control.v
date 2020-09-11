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
`define ADD 3'h0
`define SUB 3'h1
`define OR 3'h2
`define LUI 3'h3

module Control(
	output branch,
	output j,
	output jr,
	output GRF_WE,
	output [1:0] sel_rt_rd_31,
	output [1:0] sel_alu_dm_pc4,
	output sel_zero_sign,
	output sel_imm32_rt,
	output [2:0] ALUOp,
	output DM_RE,
	output DM_WE,
	output DM_isSigned,
	output [2:0] DM_opBytes,
	input equal,
	input [31:0] instr
    );

	//identify instructions:
	wire isAddu,isSubu,isOri,isLw,isSw,isBeq,isLui,isJal,isJr,isNop;
	
	assign isAddu=(instr[`op]===6'h0)&(instr[`funct]===6'h21);
	assign isSubu=(instr[`op]===6'h0)&(instr[`funct]===6'h23);
	assign isOri=(instr[`op]===6'hd);
	assign isLw=(instr[`op]===6'h23);
	assign isSw=(instr[`op]===6'h2b);
	assign isBeq=(instr[`op]===6'h4);
	assign isLui=(instr[`op]===6'hf);
	assign isJal=(instr[`op]===6'h3);
	assign isJr=(instr[`op]===6'h0)&(instr[`funct]===6'h8);
	assign isJ=(instr[`op]===6'h2);
	assign isNop=(instr===32'h0);
	
	//generate control signals:
	assign branch=(isBeq&equal);
	assign j=isJ|isJal;
	assign jr=isJr;
	assign GRF_WE=isAddu|isSubu|isOri|isLw|isLui|isJal;
	assign ALUOp=isSubu?`SUB:
				 isOri?`OR:
				 isLui?`LUI:
				 `ADD;
	assign DM_RE=isLw;
	assign DM_WE=isSw;
	assign DM_isSigned=0;
	assign DM_opBytes=(isLw|isSw)?3'h4:3'h0;
	assign sel_rt_rd_31=isJal?2'h2:
						(isAddu|isSubu)?2'h1:
						2'h0;
	assign sel_alu_dm_pc4=isJal?2'h2:
						  isLw?2'h1:
						  2'h0;
	assign sel_zero_sign=isLw|isSw|isBeq;
	assign sel_imm32_rt=isAddu|isSubu|isBeq;

endmodule
