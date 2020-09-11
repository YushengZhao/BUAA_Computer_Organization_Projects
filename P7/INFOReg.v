`timescale 1ns / 1ps
`include "macros.v"
module INFOReg(
	input clk,
	input reset,
	input resetWithPC,
	input [31:0] PCusing,
	input en,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );

	reg [`INFOMAX-1:0] emptyExceptPC;
	always@(*)begin
		emptyExceptPC=`INFOMAX'b0;
		emptyExceptPC[`PC]=PCusing;
	end
	
	always@(posedge clk)begin
		if(reset)info<=`INFOMAX'b0;
		else if(resetWithPC)info<=emptyExceptPC;
		else if(en)info<=INFO;
		else info<=info;
	end

endmodule
