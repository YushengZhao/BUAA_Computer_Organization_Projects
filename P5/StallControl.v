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
	
	assign stall=(s1DE|s1DM|s2DE|s2DM===1'b1)?1'b1:1'b0;

endmodule
