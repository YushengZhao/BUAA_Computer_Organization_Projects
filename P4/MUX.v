`timescale 1ns / 1ps

module Mux2#(parameter WIDTH=32)(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input sel,
    output [WIDTH-1:0] out
    );
	
	assign out=sel?in1:in0;

endmodule

module Mux4#(parameter WIDTH=32)(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
	input [WIDTH-1:0] in2,
	input [WIDTH-1:0] in3,
    input [1:0] sel,
    output reg [WIDTH-1:0] out
    );
	
	always@(*)begin
		case(sel)
			2'h0:out=in0;
			2'h1:out=in1;
			2'h2:out=in2;
			2'h3:out=in3;
			default:out=0;
		endcase
	end

endmodule