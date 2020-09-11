`timescale 1ns / 1ps

module DataMemory(
	input clk,
	input reset,
	input [31:0] D,
	input [31:2] A,
	input E,
	output [31:0] O
    );

	reg [31:0] DM [4095:0];
	integer i;
	initial begin
		for(i=0;i<4096;i=i+1)DM[i]=32'b0;
	end
	
	assign O=DM[A[13:2]];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i=0;i<4096;i=i+1)DM[i]=32'b0;
		end
		else if(E) begin
			DM[A[13:2]]<=D;
		end
	end

endmodule
