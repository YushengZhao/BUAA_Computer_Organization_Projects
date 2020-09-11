`timescale 1ns / 1ps

module DM(
	input clk,
	input reset,
    input [31:0] addr,
	input WE,
	input [3:0] BE,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] DMD,
	//for bridge
	output [31:0] D_M,
	output [31:0] A_M,
	output E_M,
	input [31:0] O_M
    );

	assign E_M=WE;
	assign A_M=addr;
	assign DMD=O_M;
	assign D_M=WD;
	/*
	reg [31:0] toWrite;
	always@(*)begin
		toWrite=O_M;
		if(BE[0])toWrite[7:0]=WD[7:0];
		if(BE[1])toWrite[15:8]=WD[15:8];
		if(BE[2])toWrite[23:16]=WD[23:16];
		if(BE[3])toWrite[31:24]=WD[31:24];
	end
	*/
	always@(posedge clk)begin
		if(WE
			&& addr<=32'h2fff
		)begin
			//$display("%d@%h: *%h <= %h", $time, PC, {addr[31:2],2'b0},toWrite);
		end
	end

endmodule
