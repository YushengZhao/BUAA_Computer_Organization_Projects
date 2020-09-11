`timescale 1ns / 1ps
`include "macros.v"
module Execute(
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );
	
	//yield aluA aluB:
	reg [31:0] aluA,aluB;
	always@(*)begin:mux_aluB
		reg [31:0] instr;
		instr=INFO[`instr];
		if(`isAddu|`isSubu) aluB=INFO[`RT];
		else aluB=INFO[`EXT];
		aluA=INFO[`RS];
	end
	//ALU:
	reg [31:0] aluResult;
	always@(*)begin:ALU
		reg [31:0] instr;
		instr=INFO[`instr];
		if(`isSubu)aluResult=aluA-aluB;
		else if(`isOri)aluResult=aluA|aluB;
		else if(`isLui)aluResult={aluB[15:0],16'h0};
		else aluResult=aluA+aluB;
	end
	
	always@(*)begin:E_CL
		reg [31:0] instr;
		instr=INFO[`instr];
		info=INFO;
		info[`AO]=aluResult;
		//refresh tnew
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-1);
		//get ans
		if(`isAddu|`isSubu){info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],aluResult,1'b1};
		else if(`isOri|`isLui){info[`A3],info[`WD],info[`GRFWE]}={INFO[`rt],aluResult,1'b1};
	end

endmodule
