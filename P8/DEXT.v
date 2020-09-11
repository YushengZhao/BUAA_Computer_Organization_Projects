`timescale 1ns / 1ps
`include "macros.v"
module DEXT(
	input [31:0] instr,
	input [1:0] offset,
	input [31:0] DMD,
	output reg [31:0] newDMD
    );
	
	always@(*)begin:DEXT_CL
		if(`isLw)newDMD=DMD;
		else if(`isLh)begin
			if(offset[1])newDMD={{16{DMD[31]}},DMD[31:16]};
			else newDMD={{16{DMD[15]}},DMD[15:0]};
		end
		else if(`isLhu)begin
			if(offset[1])newDMD={16'b0,DMD[31:16]};
			else newDMD={16'b0,DMD[15:0]};
		end
		else if(`isLb)begin
			case(offset)
				2'b00:newDMD={{24{DMD[7]}},DMD[7:0]};
				2'b01:newDMD={{24{DMD[15]}},DMD[15:8]};
				2'b10:newDMD={{24{DMD[23]}},DMD[23:16]};
				2'b11:newDMD={{24{DMD[31]}},DMD[31:24]};
				default:newDMD=32'b0;
			endcase
		end
		else if(`isLbu)begin
			case(offset)
				2'b00:newDMD={24'b0,DMD[7:0]};
				2'b01:newDMD={24'b0,DMD[15:8]};
				2'b10:newDMD={24'b0,DMD[23:16]};
				2'b11:newDMD={24'b0,DMD[31:24]};
				default:newDMD=32'b0;
			endcase
		end
		else newDMD=32'b0;
	end

endmodule
