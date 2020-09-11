`timescale 1ns / 1ps
`include "macros.v"
`define IM_MAX 1023
module Fetch(
	input [31:0] pc,
	output reg [`INFOMAX-1:0] info
    );

	reg [31:0] IM [`IM_MAX:0];
	integer i;
	initial begin
		for(i=0;i<`IM_MAX;i=i+1)IM[i]=32'h0;
		$readmemh("code.txt",IM,0,`IM_MAX-1);
	end
	
	reg [31:0] instr;
	always@(*)begin
		info=`INFOMAX'b0;
		info[`PC]=pc;
		info[`instr]=IM[pc[11:2]];
		
		instr=info[`instr];
		info[`rtuse]=(`isBeq)?4'h0:
					 (`isAddu|`isSubu)?4'h1:
					 4'hf;
		info[`rsuse]=(`isBeq|`isJr)?4'h0:
					 (`isAddu|`isSubu|`isOri|`isLw|`isSw)?4'h1:
					 4'hf;
		info[`tarReg]=(`isAddu|`isSubu)?info[`rd]:
					  (`isLui|`isOri|`isLw)?info[`rt]:
					  (`isJal)?5'd31:
					  5'd0;
		info[`tnew]=(`isAddu|`isSubu|`isLui|`isOri)?4'h2:
					(`isLw)?4'h3:
					(`isJal)?4'h1:
					4'h0;
	end

endmodule
