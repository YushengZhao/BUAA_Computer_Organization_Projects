`timescale 1ns / 1ps
`define ADD 3'h0
`define SUB 3'h1
`define OR 3'h2
`define LUI 3'h3
module ALU(
    input [31:0] operand1,
    input [31:0] operand2,
    input [2:0] ALUOp,
    output equal,
    output reg [31:0] result
    );

	assign equal=(operand1===operand2);
	always@(*)begin
		case(ALUOp)
			`ADD:result=operand1+operand2;
			`SUB:result=operand1-operand2;
			`OR:result=operand1|operand2;
			`LUI:result={operand2[15:0],16'h0};
			default:result=0;
		endcase
	end

endmodule
