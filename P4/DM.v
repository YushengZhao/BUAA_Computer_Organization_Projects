`timescale 1ns / 1ps
`define DMSIZE 4096
module DM(
    input clk,
    input reset,
    input WE,
    input RE,
	input isSigned,
	input [2:0] opBytes,
    input [31:0] addr,
    input [31:0] din,
	input [31:0] pc,
    output reg [31:0] dout
    );

	reg [7:0] memory [`DMSIZE-1:0];
	integer i;
	
	initial begin
		for(i=0;i<`DMSIZE;i=i+1)memory[i]<=0;
	end
	
	//store:
	always@(posedge clk)begin
		if(reset)for(i=0;i<`DMSIZE;i=i+1)memory[i]<=0;
		else if(WE)begin
			$display("@%h: *%h <= %h",pc, addr,din);
			case(opBytes)
				3'h1:memory[addr][7:0]<=din[7:0];
				3'h2:{memory[addr+1][7:0],memory[addr][7:0]}<=din[15:0];
				3'h4:{memory[addr+3][7:0],memory[addr+2][7:0],memory[addr+1][7:0],memory[addr][7:0]}<=din;
				default:{memory[addr+3][7:0],memory[addr+2][7:0],memory[addr+1][7:0],memory[addr][7:0]}<=din;
			endcase
		end
	end
	//load:
	always@(*)begin
		if(RE)begin
			case(opBytes)
				3'h1:dout=isSigned?{{24{memory[addr][7]}},memory[addr][7:0]}
							:{24'b0,memory[addr][7:0]};
				3'h2:dout=isSigned?{{16{memory[addr+1][7]}},memory[addr+1][7:0],memory[addr][7:0]}
							:{16'b0,memory[addr+1][7:0],memory[addr][7:0]};
				3'h4:dout={memory[addr+3][7:0],memory[addr+2][7:0],memory[addr+1][7:0],memory[addr][7:0]};
				default:dout=32'h0;
			endcase
		end
	end

endmodule
