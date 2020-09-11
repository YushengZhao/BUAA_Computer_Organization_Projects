`timescale 1ns / 1ps
`define CNT_MAX 32'h1000
module DigitalTubeDriver(//implements RAM
	input clk,
	input reset,
	input DT_En,
	input [31:0] DT_Addr,
	input [31:0] DT_Data,
	output [31:0] DT_Out,
	
	output [7:0] digital_tube2,
	output digital_tube_sel2,
	output [7:0] digital_tube1,
	output [3:0] digital_tube_sel1,
	output [7:0] digital_tube0,
	output [3:0] digital_tube_sel0
    );
	
	reg [31:0] number,sign,counter;
	reg [1:0] status;
	wire [3:0] pos1,pos0;
	wire [31:0] trueAddr;
	assign trueAddr={DT_Addr[31:2],2'b0};
	
	assign DT_Out=(trueAddr==32'h7f38)?number:{24'b0,sign[7:0]};
	
	always@(posedge clk)begin
		if(reset)begin
			number<=32'b0;
			sign<=32'b0;
		end
		else begin
			if(DT_En)begin
				if(trueAddr==32'h7f38)number<=DT_Data;
				else if(trueAddr==32'h7f3c)sign[7:0]<=DT_Data[7:0];
			end
		end
		case(status)
				2'b00:begin
						if(counter>0)counter<=counter-1;
						else begin
							counter<=`CNT_MAX;
							status<=2'b01;
						end
					  end
				2'b01:begin
						if(counter>0)counter<=counter-1;
						else begin
							counter<=`CNT_MAX;
							status<=2'b10;
						end
					  end
				2'b10:begin
						if(counter>0)counter<=counter-1;
						else begin
							counter<=`CNT_MAX;
							status<=2'b11;
						end
					  end
				2'b11:begin
						if(counter>0)counter<=counter-1;
						else begin
							counter<=`CNT_MAX;
							status<=2'b00;
						end
					  end
				default:status<=2'b00;
		endcase
	end
	
	assign digital_tube_sel2=1'b1;
	assign pos1=(status==2'b00)?number[19:16]:
				(status==2'b01)?number[23:20]:
				(status==2'b10)?number[27:24]:
				number[31:28];
	
	assign pos0=(status==2'b00)?number[3:0]:
				(status==2'b01)?number[7:4]:
				(status==2'b10)?number[11:8]:
				number[15:12];
	
	assign digital_tube_sel1[0]=(status==2'b00)?1'b1:1'b0;
	assign digital_tube_sel1[1]=(status==2'b01)?1'b1:1'b0;
	assign digital_tube_sel1[2]=(status==2'b10)?1'b1:1'b0;
	assign digital_tube_sel1[3]=(status==2'b11)?1'b1:1'b0;
	
	assign digital_tube_sel0[0]=(status==2'b00)?1'b1:1'b0;
	assign digital_tube_sel0[1]=(status==2'b01)?1'b1:1'b0;
	assign digital_tube_sel0[2]=(status==2'b10)?1'b1:1'b0;
	assign digital_tube_sel0[3]=(status==2'b11)?1'b1:1'b0;
	
	DT_Decoder decoder2(
		.data(sign[3:0]),
		.DT_port(digital_tube2)
	);
	
	DT_Decoder decoder1(
		.data(pos1),
		.DT_port(digital_tube1)
	);
	
	DT_Decoder decoder0(
		.data(pos0),
		.DT_port(digital_tube0)
	);
	
endmodule
