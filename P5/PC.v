`timescale 1ns / 1ps
`include "macros.v"
`define PC_INIT 32'h00003000
module PC(
	input [`INFOMAX-1:0] info,
	input clk,
	input reset,
	input en,
	output [31:0] PC
    );
	
	reg [31:0] pc=`PC_INIT;
	assign PC=pc;
	always@(posedge clk)begin
		if(reset)pc<=`PC_INIT;
		else if(en)pc<=(info[`valid])?info[`nPC]:(pc+4);
		else pc<=pc;
	end

endmodule
