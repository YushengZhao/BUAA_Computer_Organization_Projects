`timescale 1ns / 1ps
`include "macros.v"
module Execute(
	input clk,
	input reset,
	input stop,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );
	
	//ALU:
	reg [31:0] ans;
	reg [4:0] exc;
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
		
		exc=5'b0;
		ans=32'b0;
		if(`isAddu)ans=rs+rt;
		else if(`isSubu)ans=rs-rt;
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
		else if(`isAddiu)ans=rs+imm;
		else if(`isAndi)ans=rs&imm;
		else if(`isOri)ans=rs|imm;
		else if(`isXori)ans=rs^imm;
		else if(`isLui)ans={imm[15:0],16'b0};
		else if(`isSlti)ans=(srs<simm)?1:0;
		else if(`isSltiu)ans=(rs<imm)?1:0;
		else if(`isAdd)begin:add
			reg [32:0] temp;
			temp={rs[31],rs}+{rt[31],rt};
			if(temp[32]!==temp[31]) exc=`Ov;
			else ans=temp[31:0];
		end
		else if(`isSub)begin:sub
			reg [32:0] temp;
			temp={rs[31],rs}-{rt[31],rt};
			if(temp[32]!==temp[31]) exc=`Ov;
			else ans=temp[31:0];
		end
		else if(`isAddi)begin:addi
			reg [32:0] temp;
			temp={rs[31],rs}+{imm[31],imm};
			if(temp[32]!==temp[31]) exc=`Ov;
			else ans=temp[31:0];
		end
		else if(`isSb|`isSh|`isSw)begin:stores
			reg [32:0] temp;
			temp={rs[31],rs}+{imm[31],imm};
			if(temp[32]!==temp[31]) exc=`AdES;
			else if(!(
					(temp[31:0]>=32'h0 && temp[31:0]<=32'h1fff)//DM
					|(temp[31:0]>=32'h7f00 && temp[31:0]<=32'h7f07)//timer except count
					|(temp[31:0]==32'h7f10)//UART
					|(temp[31:0]==32'h7f14)//UART_empty
					|(temp[31:0]==32'h7f24)
					|(temp[31:0]==32'h7f28)
					|(temp[31:0]==32'h7f34)//LED
					|(temp[31:0]==32'h7f38)//DT
					|(temp[31:0]==32'h7f3c)
				))exc=`AdES;
			else if((`isSh|`isSb)
						&&(
							temp[31:0]>=32'h7f00
						)
				)exc=`AdES;
			else if(`isSh && temp[0]!==1'b0)exc=`AdES;
			else if(`isSw && temp[1:0]!==2'b0)exc=`AdES;
			else ans=temp[31:0];
		end
		else if(`isLb|`isLbu|`isLh|`isLhu|`isLw)begin:loads
			reg [32:0] temp;
			temp={rs[31],rs}+{imm[31],imm};
			if(temp[32]!==temp[31]) exc=`AdEL;
			else if(!(
					(temp[31:0]>=32'h0 && temp[31:0]<=32'h1fff)
					|(temp[31:0]>=32'h7f00 && temp[31:0]<=32'h7f43)
				))exc=`AdEL;
			else if((`isLb|`isLbu|`isLh|`isLhu)
						&&(
							temp[31:0]>=32'h7f00
						)
				)exc=`AdEL;
			else if(`isLw && temp[1:0]!==2'b0)exc=`AdEL;
			else if( (`isLh|`isLhu) && temp[0]!==1'b0)exc=`AdEL;
			else ans=temp[31:0];
		end
		else ans=rs+imm;
	end
	
	//E level logic:
	always@(*)begin:E_CL
		reg [31:0] instr;
		instr=INFO[`instr];
		info=INFO;
		info[`AO]=ans;
		//refresh tnew
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-4'h1);
		
		//get ans
		if(`isSra|`isSll|`isSrl|`isSllv|`isSrlv|`isSrav
			|`isAnd|`isOr|`isXor|`isNor|`isAdd|`isSub|`isAddu|`isSubu
			|`isSlt|`isSltu)
				{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rd],ans,1'b1};
				
		else if(`isSlti|`isSltiu|`isAddi|`isAddiu|`isAndi|`isXori|`isOri|`isLui)
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rt],ans,1'b1};
			
		//check exceptions
		if(exc!==5'b0)begin
			info[`instr]=32'b0;
			info[`GRFWE]=1'b0;
			info[`excCode]=info[`excCode]|exc;
		end
	end

endmodule
