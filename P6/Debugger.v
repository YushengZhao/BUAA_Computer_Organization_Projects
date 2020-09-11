`timescale 1ns / 1ps
`include "macros.v"

module Debugger(
	input [`INFOMAX-1:0] info
    );
	
	wire [31:0] instr,PC,RS,RT,nPC,EXT,AO,DMD,WD;
	wire [4:0] A3;
	wire [3:0] rtuse,rsuse,tnew;
	wire GRFWE,valid,usingXALU,busy;
	
	assign instr=info[`instr];
	assign PC=info[`PC];
	assign RS=info[`RS];
	assign RT=info[`RT];
	assign nPC=info[`nPC];
	assign EXT=info[`EXT];
	assign AO=info[`AO];
	assign DMD=info[`DMD];
	assign WD=info[`WD];
	assign A3=info[`A3];
	assign rtuse=info[`rtuse];
	assign rsuse=info[`rsuse];
	assign tnew=info[`tnew];
	assign GRFWE=info[`GRFWE];
	assign valid=info[`valid];
	assign usingXALU=info[`usingXALU];
	assign busy=info[`busy];
	
	wire isSlti;
	assign isSlti=`isSlti;

endmodule
