`timescale 1ns / 1ps
`include "macros.v"
module Forwarding(
	input [`INFOMAX-1:0] preD,
	input [`INFOMAX-1:0] preE,
	input [`INFOMAX-1:0] preM,
	input [`INFOMAX-1:0] preW,
	output reg [`INFOMAX-1:0] newD,
	output reg [`INFOMAX-1:0] newE,
	output reg [`INFOMAX-1:0] newM
    );
	
	always@(*)begin
		newD=preD;
		newE=preE;
		newM=preM;
		
		newD[`RT]=(preE[`A3]===newD[`rt]&newD[`rt]!==5'd0)?preE[`WD]:
				  (preM[`A3]===newD[`rt]&newD[`rt]!==5'd0)?preM[`WD]:
				  (preW[`A3]===newD[`rt]&newD[`rt]!==5'd0)?preW[`WD]:
				  preD[`RT];
		newE[`RT]=(preM[`A3]===newE[`rt]&newE[`rt]!==5'd0)?preM[`WD]:
				  (preW[`A3]===newE[`rt]&newE[`rt]!==5'd0)?preW[`WD]:
				  preE[`RT];
		newM[`RT]=(preW[`A3]===newM[`rt]&newM[`rt]!==5'd0)?preW[`WD]:
				  preM[`RT];
				  
		newD[`RS]=(preE[`A3]===newD[`rs]&newD[`rs]!==5'd0)?preE[`WD]:
				  (preM[`A3]===newD[`rs]&newD[`rs]!==5'd0)?preM[`WD]:
				  (preW[`A3]===newD[`rs]&newD[`rs]!==5'd0)?preW[`WD]:
				  preD[`RS];
		newE[`RS]=(preM[`A3]===newE[`rs]&newE[`rs]!==5'd0)?preM[`WD]:
				  (preW[`A3]===newE[`rs]&newE[`rs]!==5'd0)?preW[`WD]:
				  preE[`RS];
		newM[`RS]=(preW[`A3]===newM[`rs]&newM[`rs]!==5'd0)?preW[`WD]:
				  preM[`RS];
	end

endmodule
