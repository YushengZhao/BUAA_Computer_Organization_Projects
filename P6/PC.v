`timescale 1ns / 1ps
`include "macros.v"
`define PC_INIT 32'h00003000
module PC(
	input [`INFOMAX-1:0] INFO,
	input clk,
	input reset,
	input en,
	output reg [`INFOMAX-1:0] info
    );
	
	reg [31:0] pc=`PC_INIT;
	always@(posedge clk)begin
		if(reset)pc<=`PC_INIT;
		else if(en)pc<=(INFO[`valid])?INFO[`nPC]:(pc+4);
		else pc<=pc;
	end
	//install pc
	always@(*)begin
		info=`INFOMAX'b0;
		info[`PC]=pc;
	end

endmodule
