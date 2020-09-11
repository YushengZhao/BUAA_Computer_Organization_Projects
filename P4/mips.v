`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
    );
	
	wire branch,j,jr,GRF_WE,DM_RE,DM_WE,DM_isSigned,equal;
	wire [1:0] sel_rt_rd_31,sel_alu_dm_pc4;
	wire sel_zero_sign,sel_imm32_rt;
	wire [2:0] ALUOp,DM_opBytes;
	wire [31:0] instr;
	
	Control control(
		.branch(branch),// output branch
		.j(j),// output j
		.jr(jr),// output jr
		.GRF_WE(GRF_WE),// output GRF_WE
		.sel_rt_rd_31(sel_rt_rd_31),// output sel_rt_rd_31
		.sel_alu_dm_pc4(sel_alu_dm_pc4),// output sel_alu_dm_pc4
		.sel_zero_sign(sel_zero_sign),// output sel_zero_sign
		.sel_imm32_rt(sel_imm32_rt),//output sel_imm32_rt
		.ALUOp(ALUOp),// output [2:0] ALUOp
		.DM_RE(DM_RE),// output DM_RE
		.DM_WE(DM_WE),// output DM_WE
		.DM_isSigned(DM_isSigned),// output DM_isSigned
		.DM_opBytes(DM_opBytes),// output [2:0] DM_opBytes
		.equal(equal),// input equal
		.instr(instr) // input [31:0] instr
	);
	
	Datapath datapath(
		.clk(clk),// input clk
		.reset(reset),// input reset
		.branch(branch),// input branch
		.j(j),// input j
		.jr(jr),// input jr
		.GRF_WE(GRF_WE),// input GRF_WE
		.sel_rt_rd_31(sel_rt_rd_31),// input sel_rt_rd_31
		.sel_alu_dm_pc4(sel_alu_dm_pc4),// input sel_alu_dm_pc4
		.sel_zero_sign(sel_zero_sign),// input sel_zero_sign
		.sel_imm32_rt(sel_imm32_rt),//input sel_imm32_rt
		.ALUOp(ALUOp),// input [2:0] ALUOp
		.DM_RE(DM_RE),// input DM_RE
		.DM_WE(DM_WE),// input DM_WE
		.DM_isSigned(DM_isSigned),// input DM_isSigned
		.DM_opBytes(DM_opBytes),// input DM_opBytes
		.equal(equal), // output equal
		.instr(instr) // output [31:0] instr
	);

	
endmodule
