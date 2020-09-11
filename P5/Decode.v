`timescale 1ns / 1ps
`include "macros.v"
module Decode(
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );

	//EXT:
	reg [31:0] ext;
	always@(*)begin:EXT
		reg [31:0] instr;
		instr=INFO[`instr];
		if(`isOri)ext={16'h0,instr[`i16]};
		else ext={{16{instr[15]}},instr[`i16]};
	end
	
	wire [31:0] PC4;
	assign PC4=INFO[`PC]+4;
	always@(*)begin:DecoderCL
		reg [31:0] instr;
		info=INFO;
		info[`EXT]=ext;
		//npc
		instr=INFO[`instr];
		info[`valid]=(`isBeq&INFO[`RS]===INFO[`RT])|`isJ|`isJal|`isJr;
		info[`nPC]=(`isBeq&INFO[`RS]===INFO[`RT])?({ext[29:0],2'b0}+PC4):
				   (`isJ|`isJal)?{PC4[31:28],INFO[`i26],2'b0}:
				   (`isJr)?INFO[`RS]:
				   32'b0;
		//refresh tnew:
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-1);
		//get ans:
		if(`isJal){info[`A3],info[`WD],info[`GRFWE]}={5'd31,INFO[`PC]+8,1'b1};
	end

endmodule
