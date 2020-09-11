`timescale 1ns / 1ps
`include "macros.v"

module Fetch(
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info,
	//for bridge
	output [31:0] PC,
	input [31:0] ins
    );
	
	assign PC=INFO[`PC];

	always@(*)begin:fetch_CL
		info=INFO;
		info[`instr]=ins;
		if(PC[1:0]!==2'b00 || PC<32'h3000 || PC>32'h4ffc)begin
			info[`instr]=32'b0;
			info[`excCode]=`AdEL;
		end
	end
endmodule
