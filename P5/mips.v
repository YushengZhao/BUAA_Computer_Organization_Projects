`timescale 1ns / 1ps
`include "macros.v"
module mips(
    input clk,
    input reset
    );

	wire [31:0] Pc;
	wire [`INFOMAX-1:0] afterF,preGRF,preD,newD,afterD,preE,newE,afterE,preM,newM,afterM,preW;
	wire defaultEnable;
	assign defaultEnable=1'b1;
	wire stall;
	
	Debugger AfterF(afterF);
	Debugger AfterD(afterD);
	Debugger AfterE(afterE);
	Debugger AfterM(afterM);
	Debugger PreW(preW);
	
	PC pc(
		.info(afterD),
		.clk(clk),
		.reset(reset),
		.en(~stall),
		.PC(Pc)
	);
	
	Fetch fetch(
		.pc(Pc),
		.info(afterF)
	);
	
	INFOReg IF_ID(
		.clk(clk),
		.reset(reset),
		.en(~stall),
		.INFO(afterF),
		.info(preGRF)
	);
	
	RF rf(
		.clk(clk),
		.reset(reset),
		.INFO(preGRF),
		.Winfo(preW),
		.info(preD)
	);
	
	//insert renwer here
	
	Decode decode(
		.INFO(newD),
		.info(afterD)
	);
	
	INFOReg ID_EX(
		.clk(clk),
		.reset(reset|stall),
		.en(defaultEnable),
		.INFO(afterD),
		.info(preE)
	);
	
	//insert renewer here
	
	Execute execute(
		.INFO(newE),
		.info(afterE)
	);
	
	INFOReg EX_MEM(
		.clk(clk),
		.reset(reset),
		.en(defaultEnable),
		.INFO(afterE),
		.info(preM)
	);
	
	//insert renewer here
	
	Memory memory(
		.clk(clk),
		.reset(reset),
		.INFO(newM),
		.info(afterM)
	);
	
	INFOReg MEM_WB(
		.clk(clk),
		.reset(reset),
		.en(defaultEnable),
		.INFO(afterM),
		.info(preW)
	);
	
	StallControl stallControl(
		.infoD(preGRF),
		.infoE(preE),
		.infoM(preM),
		.stall(stall)
	);
	
	Forwarding forwarding(
		.preD(preD),
		.preE(preE),
		.preM(preM),
		.preW(preW),
		.newD(newD),
		.newE(newE),
		.newM(newM)
	);

endmodule
