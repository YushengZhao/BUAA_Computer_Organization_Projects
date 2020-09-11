`timescale 1ns / 1ps
`include "macros.v"
module XALU(
	input clk,
	input reset,
	input [`INFOMAX-1:0] INFO,
	output reg [31:0] HI,
	output reg [31:0] LO,
	output busy
    );

	reg [31:0] total=32'h0,counter=32'h0,hi=32'h0,lo=32'h0;
	reg start=1'b0;
	
	assign busy=(|counter)|start;
	
	always@(*)begin:XALU_CL//using hi lo not HI LO
		reg [31:0] instr,RS,RT;
		
		instr=INFO[`instr];
		RS=INFO[`RS];
		RT=INFO[`RT];
		
		if(`isMult)begin:mult
			reg signed [63:0] ans,A,B;
			A=$signed({{32{RS[31]}},RS[31:0]});
			B=$signed({{32{RT[31]}},RT[31:0]});
			ans=A*B;
			hi=ans[63:32];
			lo=ans[31:0];
			start=1'b1;
			total=32'd5;
		end
		else if(`isMultu)begin:multu
			reg [63:0] ans,A,B;
			A={32'b0,RS};
			B={32'b0,RT};
			ans=A*B;
			hi=ans[63:32];
			lo=ans[31:0];
			start=1'b1;
			total=32'd5;
		end
		else if(`isMadd)begin:madd
			reg signed [63:0] sum,ans,A,B;
			A=$signed({{32{RS[31]}},RS[31:0]});
			B=$signed({{32{RT[31]}},RT[31:0]});
			ans=A*B;
			sum=$signed({hi,lo});
			sum=sum+ans;
			hi=sum[63:32];
			lo=sum[31:0];
		end
		else if(`isMsub)begin:msub
			reg signed [63:0] sum,ans,A,B;
			A=$signed({{32{RS[31]}},RS[31:0]});
			B=$signed({{32{RT[31]}},RT[31:0]});
			ans=A*B;
			sum=$signed({hi,lo});
			sum=sum-ans;
			hi=sum[63:32];
			lo=sum[31:0];
		end
		else if(`isDiv)begin:div
			reg signed [31:0] A,B,q,r;
			A=$signed(RS);
			B=$signed(RT);
			q=A/B;
			r=A%B;
			hi=r[31:0];
			lo=q[31:0];
			start=1'b1;
			total=32'd10;
		end
		else if(`isDivu)begin:divu
			hi=RS%RT;
			lo=RS/RT;
			start=1'b1;
			total=32'd10;
		end
		else if(`isMthi)begin:mthi
			hi=RS;
			start=1'b0;
			total=32'h0;
		end
		else if(`isMtlo)begin:mtlo
			lo=RS;
			start=1'b0;
			total=32'h0;
		end
		else begin:nothing
			start=1'b0;
			total=32'h0;
		end
	end
	
	always@(posedge clk)begin
		if(reset)begin
			counter<=32'h0;
			start<=1'b0;
			HI<=32'h0;
			LO<=32'h0;
		end
		else begin
			HI<=hi;
			LO<=lo;
			if(start)
				counter<=total;
			else if(counter>0)
				counter=counter-1;
		end
	end

endmodule
