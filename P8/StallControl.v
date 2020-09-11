`timescale 1ns / 1ps
`include "macros.v"
module StallControl(
	input [`INFOMAX-1:0] infoD,
	input [`INFOMAX-1:0] infoE,
	input [`INFOMAX-1:0] infoM,
	output stall
    );

	//rtuse-tnew
	wire s1DE,s1DM;
	assign s1DE=(infoD[`rt]!==5'd0)&(infoE[`tarReg]===infoD[`rt])&(infoD[`rtuse]<infoE[`tnew]);
	assign s1DM=(infoD[`rt]!==5'd0)&(infoM[`tarReg]===infoD[`rt])&(infoD[`rtuse]<infoM[`tnew]);
	//rsuse-tnew
	wire s2DE,s2DM;
	assign s2DE=(infoD[`rs]!==5'd0)&(infoE[`tarReg]===infoD[`rs])&(infoD[`rsuse]<infoE[`tnew]);
	assign s2DM=(infoD[`rs]!==5'd0)&(infoM[`tarReg]===infoD[`rs])&(infoD[`rsuse]<infoM[`tnew]);
	//epc related:
	reg epcStall;
	always@(*)begin:epcRelated
		reg [31:0] instr;
		instr=infoD[`instr];
		if(`isEret & (infoE[`usingEPC] | infoM[`usingEPC]) )epcStall=1'b1;
		else epcStall=1'b0;
	end
	
	assign stall=s1DE|s1DM|s2DE|s2DM|epcStall;

endmodule
