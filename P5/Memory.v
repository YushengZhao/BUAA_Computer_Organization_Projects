`timescale 1ns / 1ps
`include "macros.v"

module Memory(
	input clk,
	input reset,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );

	reg [31:0] memory [1023:0];
	integer i;
	initial begin
		for(i=0;i<1024;i=i+1)memory[i]=32'h0;
	end
	
	wire [31:0] instr,AO;
	assign instr=INFO[`instr];
	assign AO=INFO[`AO];
	
	always@(posedge clk)begin
		if(reset)for(i=0;i<1024;i=i+1)memory[i]<=0;
		else if(`isSw)begin
			$display("%d@%h: *%h <= %h", $time,INFO[`PC],AO,INFO[`RT]);
			memory[AO[11:2]]<=INFO[`RT];
		end
	end
	
	always@(*)begin
		info=INFO;
		//readMEM/getans
		if(`isLw)begin
			info[`DMD]=memory[AO[11:2]];
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rt],info[`DMD],1'b1};
		end
		//refresh tnew:
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-1);
	end
	

endmodule
