`timescale 1ns / 1ps
`include "macros.v"

module Fetch(
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );
	//IM
	reg [31:0] IM [4095:0];
	integer i;
	initial begin
		for(i=0;i<4096;i=i+1)IM[i]=32'h0;
		$readmemh("code.txt",IM,0,4095);
	end
	//install instruction
	always@(*)begin:fetch_CL
		reg [31:0] realPC;
		info=INFO;
		realPC=INFO[`PC]-32'h3000;
		info[`instr]=IM[realPC[13:2]];
	end

endmodule
