`timescale 1ns / 1ps

module NPC(
	input branch,
	input j,
	input jr,
	input [31:0] jumpReg,
    input [31:0] PC,
    input [25:0] imm26,
    output [31:0] PC4,
    output reg [31:0] nPC
    );

	assign PC4=PC+32'h4;
	always@(*)begin
		if(j)begin
			nPC={PC4[31:28],imm26,2'b0};
		end
		else if(jr)begin
			nPC=jumpReg;
		end
		else if(branch)begin
			nPC=PC4+{{14{imm26[15]}},imm26[15:0],2'b0};
		end
		else begin
			nPC=PC4;
		end
	end

endmodule
