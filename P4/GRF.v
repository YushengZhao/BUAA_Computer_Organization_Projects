`timescale 1ns / 1ps

module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] reg1,
    input [4:0] reg2,
    input [4:0] writeReg,
    input [31:0] writeData,
	input [31:0] PC,
    output [31:0] data1,
    output [31:0] data2
    );
	
	reg [31:0] RF [31:0];
	integer i;
	
	assign data1=RF[reg1];
	assign data2=RF[reg2];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i=0;i<32;i=i+1)RF[i]<=32'h0;
		end
		else if(WE)begin
			$display("@%h: $%d <= %h",PC,writeReg,writeData);
			RF[writeReg]<=writeData;
			RF[0]<=32'h0;
		end
	end

endmodule
