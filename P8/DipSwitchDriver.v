`timescale 1ns / 1ps

module DipSwitchDriver(//implements ROM
	input [7:0] dip_switch0,
	input [7:0] dip_switch1,
	input [7:0] dip_switch2,
	input [7:0] dip_switch3,
	input [7:0] dip_switch4,
	input [7:0] dip_switch5,
	input [7:0] dip_switch6,
	input [7:0] dip_switch7,
	
	input [31:0] addr,
	output [31:0] data
    );

	wire [31:0] trueAddr;
	assign trueAddr={addr[31:2],2'b0};
	assign data=(trueAddr==32'h7f2c)?
					{~dip_switch3,~dip_switch2,~dip_switch1,~dip_switch0}:
					{~dip_switch7,~dip_switch6,~dip_switch5,~dip_switch4};

endmodule
