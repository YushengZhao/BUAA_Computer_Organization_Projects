`timescale 1ns / 1ps
`include "macros.v"
module Execute(
	input clk,
	input reset,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );
	
	//ALU:
	reg [31:0] ans;
	always@(*)begin:ALU
		reg [31:0] instr,imm,rs,rt;
		reg [4:0] s;
		reg signed [31:0] srs,srt,simm;
		instr=INFO[`instr];
		imm=INFO[`EXT];
		rs=INFO[`RS];
		rt=INFO[`RT];
		s=INFO[`shamt];
		simm=$signed(imm);
		srs=$signed(rs);
		srt=$signed(rt);
		
		if(`isAdd|`isAddu)ans=rs+rt;
		else if(`isSub|`isSubu)ans=rs-rt;
		else if(`isSlt)ans=(srs<srt)?1:0;
		else if(`isSltu)ans=(rs<rt)?1:0;
		else if(`isSll)ans=(rt<<s);
		else if(`isSrl)ans=(rt>>s);
		else if(`isSra)ans=(srt>>>s);
		else if(`isSllv)ans=(rt<<(rs[4:0]));
		else if(`isSrlv)ans=(rt>>(rs[4:0]));
		else if(`isSrav)ans=(srt>>>(rs[4:0]));
		else if(`isAnd)ans=rs&rt;
		else if(`isOr)ans=rs|rt;
		else if(`isXor)ans=rs^rt;
		else if(`isNor)ans=~(rs|rt);
		else if(`isAddi|`isAddiu)ans=rs+imm;
		else if(`isAndi)ans=rs&imm;
		else if(`isOri)ans=rs|imm;
		else if(`isXori)ans=rs^imm;
		else if(`isLui)ans={imm[15:0],16'b0};
		else if(`isSlti)ans=(srs<simm)?1:0;
		else if(`isSltiu)ans=(rs<imm)?1:0;
		else ans=rs+imm;
	end
	
	//XALU
	wire [31:0] hi,lo;
	wire busy;
	
	XALU xALU(
		.clk(clk),
		.reset(reset),
		.INFO(INFO),
		.HI(hi),
		.LO(lo),
		.busy(busy)
	);
	
	//E level logic:
	always@(*)begin:E_CL
		reg [31:0] instr;
		instr=INFO[`instr];
		info=INFO;
		info[`AO]=ans;
		info[`busy]=busy;
		//refresh tnew
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-1);
		//get ans
		if(`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
			|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
			|`isSlt|`isSltu)
				{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],ans,1'b1};
		
		else if(`isSlti|`isSltiu|`isAddi|`isAddiu|`isAndi|`isXori|`isOri|`isLui)
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rt],ans,1'b1};
		else if(`isMfhi)
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],hi,1'b1};
		else if(`isMflo)
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],lo,1'b1};
	end

endmodule
