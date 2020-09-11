`timescale 1ns / 1ps
`include "macros.v"
module INFOReg(
	input clk,
	input reset,
	input en,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );

	always@(posedge clk)begin
		if(reset)info<=`INFOMAX'b0;
		else if(en)info<=INFO;
		else info<=info;
	end

endmodule
