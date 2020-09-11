`timescale 1ns / 1ps
`include "macros.v"
module Decode(
	input [`INFOMAX-1:0] INFO,
	input [31:0] epc,
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
	
	wire [31:0] PC4,PC;
	assign PC4=INFO[`PC]+4;
	assign PC=INFO[`PC];
	always@(*)begin:DecoderCL
		reg [31:0] instr;
		reg signed [31:0] sRS;
		info=INFO;
		info[`EXT]=ext;
		instr=INFO[`instr];
		info[`PC]={PC[31:2],2'b0};
		//npc
		sRS=$signed(INFO[`RS]);
		info[`valid]=(`isBeq&INFO[`RS]===INFO[`RT])
					|(`isBne&INFO[`RS]!==INFO[`RT])
					|(`isBlez&sRS<=0)
					|(`isBgtz&sRS>0)
					|(`isBltz&sRS<0)
					|(`isBgez&sRS>=0)
					|`isJ|`isJal|`isJr|`isJalr|`isEret;
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
				   (`isEret)?epc:
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
					 )?4'h1:
					 4'hf;
		info[`rsuse]=(`isBeq|`isBne|`isBlez|`isBgtz|`isBltz|`isBgez|`isJr|`isJalr)?4'h0:
					 (|`isAnd|`isOr|`isXor|`isNor|`isSllv|`isSrlv|`isSrav|`isSlt|`isSltu|`isAdd|`isSub|`isAddu|`isSubu
						|`isAddi|`isAddiu|`isAndi|`isXori|`isOri|`isSlti|`isSltiu
						|`isSb|`isSh|`isSw|`isLb|`isLbu|`isLh|`isLhu|`isLw
					 )?4'h1:
					 4'hf;
		info[`tarReg]=(|`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
						|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
						|`isSlt|`isSltu
						|`isJalr
					  )?info[`rd]:
					  (`isSlti|`isSltiu|`isAddi|`isAddiu|`isAndi|`isXori|`isLui|`isOri
						|`isLb|`isLbu|`isLh|`isLhu|`isLw
						|`isMfc0
					  )?info[`rt]:
					  (`isJal)?5'd31:
					  5'd0;
		info[`tnew]=(`isLui|`isOri
						|`isSlti|`isSltiu
						|`isSlt|`isSltu
						|`isAddi|`isAddiu|`isAndi|`isXori
						|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
						|`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
					)?4'h2:
					(`isLw|`isLb|`isLbu|`isLh|`isLhu|`isMfc0)?4'h3:
					(`isJal|`isJalr)?4'h1:
					4'h0;
		//using EPC
		info[`usingEPC]=`isMtc0;
		//recognize instruction
		if(!(
			`isBeq|`isBne|`isBlez|`isBgtz|`isBltz|`isBgez|`isJr|`isJalr|`isJ|`isJal
			|`isAnd|`isOr|`isXor|`isNor|`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav|`isSlt|`isSltu|`isAdd|`isSub|`isAddu|`isSubu
			|`isAddi|`isAddiu|`isAndi|`isXori|`isOri|`isSlti|`isSltiu|`isLui
			|`isSb|`isSh|`isSw|`isLb|`isLbu|`isLh|`isLhu|`isLw
			|`isMfc0|`isMtc0|`isEret
			|`isNop
		))begin
			info[`excCode]=`RI;
			info[`instr]=32'b0;
		end
	end

endmodule
