`timescale 1ns / 1ps
`define DEBUGGER 32'h18373695
module Bridge(
	input [31:0] A1,
	output reg [31:0] O1,
	input [31:0] A2,
	input [31:0] D2,
	input E,
	output [31:0] O2,
	//for timer0
	output [31:0] t0D,
	output [31:0] t0A,
	output reg t0E,
	input [31:0] t0O,
	//for timer1
	output [31:0] t1D,
	output [31:0] t1A,
	output reg t1E,
	input [31:0] t1O,
	//for dm
	output [31:0] DMD,
	output [31:0] DMA,
	output reg DME,
	input [31:0] DMO
    );

	reg [31:0] IM [4095:0];
	
	integer i;
	initial begin
		for(i=0;i<4096;i=i+1)begin
			IM[i]=32'h0;
		end
		$readmemh("code.txt",IM,0,4095);
		$readmemh("code_handler.txt",IM,1120,2047); 
	end
	
	always@(*)begin:aboutIM
		reg [31:0] realPC;
		realPC=A1-32'h3000;
		O1=IM[realPC[13:2]];
	end
	
	assign t0A=A2;
	assign t1A=A2;
	assign DMA=A2;
	assign O2=(A2<=32'h2fff)?DMO:
			  (A2>=32'h7f00 && A2<=32'h7f0b)?t0O:
			  (A2>=32'h7f10 && A2<=32'h7f1b)?t1O:
			  `DEBUGGER;
	assign t0D=D2;
	assign t1D=D2;
	assign DMD=D2;
	always@(*)begin
		t0E=1'b0;
		t1E=1'b0;
		DME=1'b0;
		if(A2>=32'h0 && A2<=32'h2fff)DME=E;
		else if(A2>=32'h7f00 && A2<=32'h7f0b)t0E=E;
		else if(A2>=32'h7f10 && A2<=32'h7f1b)t1E=E;
	end

endmodule
