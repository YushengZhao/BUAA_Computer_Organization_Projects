`timescale 1ns / 1ps
`include "macros.v"

module Memory(
	input clk,
	input reset,
	input [`INFOMAX-1:0] INFO,
	output reg [`INFOMAX-1:0] info
    );

	wire [31:0] addr;
	assign addr=INFO[`AO];
	
	//preDM:
	reg WE;
	reg [3:0] BE;
	reg [31:0] WD;
	always@(*)begin:preDM
		reg [31:0] instr;
		instr=INFO[`instr];
		WE=`isSw|`isSh|`isSb;
		WD=INFO[`RT];
		if(`isSw)begin
			BE=4'b1111;
			WD=INFO[`RT];
		end
		else if(`isSh)begin
			BE=(addr[1])?4'b1100:4'b0011;
			WD={WD[15:0],WD[15:0]};
		end
		else if(`isSb)begin
			case(addr[1:0])
				2'b00:BE=4'b0001;
				2'b01:BE=4'b0010;
				2'b10:BE=4'b0100;
				2'b11:BE=4'b1000;
				default:BE=4'b0000;
			endcase
			WD={WD[7:0],WD[7:0],WD[7:0],WD[7:0]};
		end
		else BE=4'b0;
		
		
		//if(INFO[`PC]===32'h31b4)WE=1'b0;
	end
	
	wire [31:0] DMD;
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.addr(addr),
		.WE(WE),
		.BE(BE),
		.WD(WD),
		.PC(INFO[`PC]),
		.DMD(DMD)
	);
	
	wire [31:0] newDMD;
	
	DEXT dataEXT(
		.instr(INFO[`instr]),
		.offset(addr[1:0]),
		.DMD(DMD),
		.newDMD(newDMD)
	);
	
	always@(*)begin:MEM_CL
		reg [31:0] instr;
		instr=INFO[`instr];
		info=INFO;
		//readMEM/getans
		info[`DMD]=newDMD;
		if(`isLw|`isLh|`isLhu|`isLb|`isLbu)begin
			{info[`A3],info[`WD],info[`GRFWE]}={INFO[`rt],newDMD,1'b1};
		end
		//refresh tnew:
		info[`tnew]=(INFO[`tnew]===4'h0)?4'h0:(INFO[`tnew]-1);
	end
	
endmodule
