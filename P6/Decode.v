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
		if(`isOri|`isAndi|`isXori)ext={16'h0,instr[`i16]};
		else ext={{16{instr[15]}},instr[`i16]};
	end
	
	wire [31:0] PC4;
	assign PC4=INFO[`PC]+4;
	always@(*)begin:DecoderCL
		reg [31:0] instr;
		reg signed [31:0] sRS;
		info=INFO;
		info[`EXT]=ext;
		instr=INFO[`instr];
		//npc
		sRS=$signed(INFO[`RS]);
		info[`valid]=(`isBeq&INFO[`RS]===INFO[`RT])
					|(`isBne&INFO[`RS]!==INFO[`RT])
					|(`isBlez&sRS<=0)
					|(`isBgtz&sRS>0)
					|(`isBltz&sRS<0)
					|(`isBgez&sRS>=0)
					|`isJ|`isJal|`isJr|`isJalr;
		info[`nPC]=(//branches:
						(`isBeq&INFO[`RS]===INFO[`RT])
						|(`isBne&INFO[`RS]!==INFO[`RT])
						|(`isBlez&sRS<=0)
						|(`isBgtz&sRS>0)
						|(`isBltz&sRS<0)
						|(`isBgez&sRS>=0)
				   )?({ext[29:0],2'b0}+PC4):
				   //jumps:
				   (`isJ|`isJal)?{PC4[31:28],INFO[`i26],2'b0}:
				   (`isJr|`isJalr)?INFO[`RS]:
				   //for debug:
				   32'h18373695;
		
		//get ans:
		if(`isJal){info[`A3],info[`WD],info[`GRFWE]}={5'd31,INFO[`PC]+8,1'b1};
		if(`isJalr){info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],INFO[`PC]+8,1'b1};
		//calculate tuse and tnew:
		info[`rtuse]=(`isBeq|`isBne)?4'h0:
					 (`isAnd|`isOr|`isXor|`isNor|`isAdd|`isAddu|`isSub|`isSubu
						|`isSll|`isSrl|`isSra|`isSllv|`isSrlv|`isSrav
						|`isSlt|`isSltu
						|`isMult|`isMultu|`isDiv|`isDivu|`isMadd|`isMsub
					 )?4'h1:
					 4'hf;
		info[`rsuse]=(`isBeq|`isBne|`isBlez|`isBgtz|`isBltz|`isBgez|`isJr|`isJalr)?4'h0:
					 (`isMthi|`isMtlo|`isMult|`isMultu|`isDiv|`isDivu|`isMadd|`isMsub
						|`isAnd|`isOr|`isXor|`isNor|`isSllv|`isSrlv|`isSrav|`isSlt|`isSltu|`isAdd|`isSub|`isAddu|`isSubu
						|`isAddi|`isAddiu|`isAndi|`isXori|`isOri|`isSlti|`isSltiu
						|`isSb|`isSh|`isSw|`isLb|`isLbu|`isLh|`isLhu|`isLw
					 )?4'h1:
					 4'hf;
		info[`tarReg]=(`isMfhi|`isMflo
						|`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
						|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
						|`isSlt|`isSltu
						|`isJalr
					  )?info[`rd]:
					  (`isSlti|`isSltiu|`isAddi|`isAddiu|`isAndi|`isXori|`isLui|`isOri
						|`isLb|`isLbu|`isLh|`isLhu|`isLw
					  )?info[`rt]:
					  (`isJal)?5'd31:
					  5'd0;
		info[`tnew]=(`isLui|`isOri
						|`isSlti|`isSltiu
						|`isSlt|`isSltu
						|`isAddi|`isAddiu|`isAndi|`isXori
						|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
						|`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
						|`isMfhi|`isMflo
					)?4'h2:
					(`isLw|`isLb|`isLbu|`isLh|`isLhu)?4'h3:
					(`isJal|`isJalr)?4'h1:
					4'h0;
		info[`tarVolatile]=1'b0;
		//using XALU
		info[`usingXALU]=`isMfhi|`isMflo|`isMthi|`isMtlo|`isMult|`isMultu|`isDiv|`isDivu|`isMadd|`isMsub;
	end

endmodule
