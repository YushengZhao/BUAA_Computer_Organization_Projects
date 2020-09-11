`timescale 1ns / 1ps
`define PC_DEFAULT 32'h0000_3000

module PC(
    input [31:0] nPC,
    input en,
	input reset,
    input clk,
    output [31:0] PC
    );
	
	reg [31:0] pc=`PC_DEFAULT;
	always@(posedge clk)begin
		if(reset)pc<=`PC_DEFAULT;
		else if(en)pc<=nPC;
	end
	assign PC=pc;

endmodule
