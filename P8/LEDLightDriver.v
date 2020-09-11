`timescale 1ns / 1ps

module LEDLightDriver(//implements RAM
	output [31:0] led_light,
	input clk,
	input reset,
	input LED_En,
	input [31:0] LED_Data,
	output [31:0] LED_Out
    );

	reg [31:0] LED_Reg;
	assign LED_Out=LED_Reg;
	assign led_light=~LED_Reg;
	
	always@(posedge clk)begin
		if(reset)LED_Reg<=32'b0;
		else if(LED_En)LED_Reg<=LED_Data;
	end

endmodule
