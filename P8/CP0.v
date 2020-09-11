`timescale 1ns / 1ps
`include "macros.v"
`define DEBUG 32'h23456789
`define IP 15:10
`define IM 15:10
`define EXL 1
`define IE 0
`define ExcCode 6:2
`define BD 31
module CP0(
	input clk,
	input reset,
	input [7:2] HWInt,
	input [`INFOMAX-1:0] preM,
	input [`INFOMAX-1:0] preE,
	input [`INFOMAX-1:0] preD,
	input [`INFOMAX-1:0] preF,
	input [`INFOMAX-1:0] preW,
	input [31:0] din,
	input [4:0] addr,
	input enable,
	input enableInt,
	output [31:0] dout,
	output toExc,
	output [31:0] epc,
	output [31:0] truePC
    );

	reg [31:0] EPC=32'h0,cause=32'h0,SR=32'h0,prID=32'h18373695;
	wire IntReq,hasExc;
	reg branchDelay;
	reg [31:0] branchPC;//register indicates the last branch instruction's PC
	assign IntReq=|(HWInt[7:2]&SR[`IM])&SR[`IE]&~SR[`EXL];
	assign hasExc=(|preM[`excCode])&~SR[`EXL];
	assign toExc=IntReq|hasExc;
	assign dout=(addr===5'd12)?SR:
				(addr===5'd13)?cause:
				(addr===5'd14)?EPC:
				(addr===5'd15)?prID:
				32'h0;
	assign epc=EPC;
	assign truePC=(preM[`PC]!==32'h0)?preM[`PC]:
				  (preE[`PC]!==32'h0)?preE[`PC]:
				  (preD[`PC]!==32'h0)?preD[`PC]:
				  (preF[`PC]!==32'h0)?preF[`PC]:
				  32'h3000;
	
	reg isBranch;
	always@(*)begin:testBranch
		reg [31:0] instr;
		instr=preM[`instr];
		if(`isBeq|`isBne|`isBlez|`isBgtz|`isBltz|`isBgez|`isJr|`isJalr|`isJ|`isJal|`isEret)
			isBranch=`true;
		else isBranch=`false;
	end
	always@(posedge clk)begin:recordBranchPC
		if(isBranch)branchPC<=preM[`PC];
	end
	
	always@(*)begin:solveBD
		if(preM[`PC]===(branchPC+32'h4))branchDelay=`true;
		else branchDelay=`false;
	end
	
	always@(posedge clk)begin
		if(reset)begin
			EPC<=32'h0;
			cause<=32'h0;
			SR<=32'h0;
			prID<=32'h18373695;
		end
		else begin
			cause[`IP]<=HWInt[7:2];
			if(enable & ~IntReq & ~hasExc)begin
				if(addr===5'd12){SR[15:10],SR[1:0]}<={din[15:10],din[1:0]};
				else if(addr===5'd14)EPC<=din;
			end
			else if(IntReq)begin
				cause[`ExcCode]<=(HWInt[3])?`UART_INT:`_INT;
				cause[`BD]<=branchDelay;
				EPC<=(branchDelay)?branchPC:
					 (preM[`PC]!==32'h0)?preM[`PC]:
					 (preE[`PC]!==32'h0)?preE[`PC]:
					 (preD[`PC]!==32'h0)?preD[`PC]:
					 (preF[`PC]!==32'h0)?preF[`PC]:
					 `DEBUG;
				SR[`EXL]<=1'b1;
			end
			else if(hasExc)begin
				cause[`ExcCode]<=preM[`excCode];
				cause[`BD]<=branchDelay;
				EPC<=(branchDelay)?branchPC:
					 (preM[`PC]!==32'h0)?preM[`PC]:
					 (preE[`PC]!==32'h0)?preE[`PC]:
					 (preD[`PC]!==32'h0)?preD[`PC]:
					 (preF[`PC]!==32'h0)?preF[`PC]:
					 `DEBUG;
				SR[`EXL]<=1'b1;
			end
			else if(enableInt)begin
				SR[`EXL]<=1'b0;
			end
		end
	end
	
endmodule
