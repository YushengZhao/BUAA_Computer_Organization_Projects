`timescale 1ns / 1ps

module DM(
	input clk,
	input reset,
    input [31:0] addr,
	input WE,
	input [3:0] BE,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] DMD
    );

	reg [31:0] mem [4095:0];
	integer i;
	initial begin
		for(i=0;i<4096;i=i+1)mem[i]=32'b0;
	end
	
	assign DMD=mem[addr[13:2]];
	
	reg [31:0] toWrite;
	always@(*)begin
		toWrite=mem[addr[13:2]];
		if(BE[0])toWrite[7:0]=WD[7:0];
		if(BE[1])toWrite[15:8]=WD[15:8];
		if(BE[2])toWrite[23:16]=WD[23:16];
		if(BE[3])toWrite[31:24]=WD[31:24];
	end
	
	always@(posedge clk)begin
		if(reset)for(i=0;i<4096;i=i+1)mem[i]<=32'b0;
		else if(WE)begin
			$display("%d@%h: *%h <= %h", $time, PC, {addr[31:2],2'b0},toWrite);
			mem[addr[13:2]]<=toWrite;
		end
	end

endmodule
