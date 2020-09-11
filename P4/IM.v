`timescale 1ns / 1ps
`include "PC.v"
`define IMSIZE 1024

module IM(
    input [31:0] addr,
    output [31:0] data
    );
	
	reg [31:0] memory [`IMSIZE-1:0];
	wire [31:0] realAddr;
	
	initial begin:initialization
		integer i;
		for(i=0;i<`IMSIZE;i=i+1)memory[i]=32'h0;
		$readmemh("code.txt",memory,0,`IMSIZE-1);
	end
	
	assign realAddr=(addr-`PC_DEFAULT)>>2;
	assign data=memory[realAddr];

endmodule
