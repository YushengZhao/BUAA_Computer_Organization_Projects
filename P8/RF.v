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
	reg [`INFOMAX-1:0] winfo;
	
	always@(*)begin:debugger
		winfo=Winfo;
		//if(Winfo[`PC]===32'h31b4)begin {winfo[`A3],winfo[`WD],winfo[`GRFWE]}={5'd9,Winfo[`instr],1'b1};end
	end
	
	GRF grf(
		.clk(clk),
		.reset(reset),
		.WE(winfo[`GRFWE]),
		.A1(INFO[`rs]),
		.A2(INFO[`rt]),
		.A3(winfo[`A3]),
		.WD(winfo[`WD]),
		.PC(winfo[`PC]),
		.RD1(RD1),
		.RD2(RD2)
	);
	
	always@(*)begin:RF_CL
		info=INFO;
		info[`RS]=RD1;
		info[`RT]=RD2;
	end
	
endmodule
