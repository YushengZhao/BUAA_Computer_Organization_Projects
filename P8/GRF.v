`timescale 1ns / 1ps

module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
	input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
	
	reg [31:0] RF [31:0];
	integer i;
	
	assign RD1=RF[A1];
	assign RD2=RF[A2];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i=0;i<32;i=i+1)RF[i]<=32'h0;
		end
		else if(WE)begin
			//if(A3!==5'd0)$display("%d@%h: $%d <= %h",$time,PC,A3,WD);
			RF[A3]<=WD;
			RF[0]<=32'h0;
		end
	end

endmodule
