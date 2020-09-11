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
	assign s1DE=(infoD[`rt]!==5'd0)&(infoE[`tarReg]===infoD[`rt]|infoE[`tarVolatile])&(infoD[`rtuse]<infoE[`tnew]);
	assign s1DM=(infoD[`rt]!==5'd0)&(infoM[`tarReg]===infoD[`rt]|infoM[`tarVolatile])&(infoD[`rtuse]<infoM[`tnew]);
	//rsuse-tnew
	wire s2DE,s2DM;
	assign s2DE=(infoD[`rs]!==5'd0)&(infoE[`tarReg]===infoD[`rs]|infoE[`tarVolatile])&(infoD[`rsuse]<infoE[`tnew]);
	assign s2DM=(infoD[`rs]!==5'd0)&(infoM[`tarReg]===infoD[`rs]|infoM[`tarVolatile])&(infoD[`rsuse]<infoM[`tnew]);
	//busy?
	wire busyStall;
	assign busyStall=infoE[`busy]&infoD[`usingXALU];
	
	assign stall=s1DE|s1DM|s2DE|s2DM|busyStall;

endmodule
