`timescale 1ns / 1ps
`include "macros.v"
module RF(
	input clk,
	input reset,
	input [`INFOMAX-1:0] INFO,
	input [`INFOMAX-1:0] Winfo,
	output reg [`INFOMAX-1:0] info
    );

	wire [31:0] RD1,RD2;
	GRF grf(
		.clk(clk),
		.reset(reset),
		.WE(Winfo[`GRFWE]),
		.A1(INFO[`rs]),
		.A2(INFO[`rt]),
		.A3(Winfo[`A3]),
		.WD(Winfo[`WD]),
		.PC(Winfo[`PC]),
		.RD1(RD1),
		.RD2(RD2)
	);
	
	always@(*)begin
		info=INFO;
		info[`RS]=RD1;
		info[`RT]=RD2;
	end
	
endmodule
