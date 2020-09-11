`timescale 1ns / 1ps
`include "macros.v"
module CPU(
    input clk,
    input reset,
	input [7:2] HWInt,
	output [31:0] addr,
	//for bridge
	output [31:0] PC,
	input [31:0] ins,
	output [31:0] D_M,
	output [31:0] A_M,
	output E_M,
	output [3:0] BE_M,
	input [31:0] O_M
    );

	wire [31:0] Pc,epc;
	wire [`INFOMAX-1:0] preF,afterF,preGRF,preD,newD,afterD,preE,newE,afterE,preM,newM,afterM,preW;
	wire defaultEnable;
	assign defaultEnable=1'b1;
	wire stall,toExc;
	//between cp0 and m level
	wire [31:0] data_cp0,content_cp0;
	wire [4:0] addr_cp0;
	wire enable_cp0;
	reg clearDE,enableInt;
	
	Debugger AfterF(afterF);
	Debugger AfterD(afterD);
	Debugger AfterE(afterE);
	Debugger AfterM(afterM);
	Debugger PreW(preW);
	
	PC pc(
		.INFO(afterD),
		.clk(clk),
		.reset(reset),
		.en(~stall),
		.info(preF),
		.toExc(toExc)
	);
	
	Fetch fetch(
		.INFO(preF),
		.info(afterF),
		.PC(PC),
		.ins(ins)
	);
	
	INFOReg IF_ID(
		.clk(clk),
		.reset(reset|toExc),
		.resetWithPC(`false),
		.PCusing(afterF[`PC]),
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
		.INFO(clearDE?`INFOMAX'b0:newD),
		.info(afterD),
		.epc(epc)
	);
	
	INFOReg ID_EX(
		.clk(clk),
		.reset(reset|toExc),
		.resetWithPC(stall|clearDE),
		.PCusing(afterD[`PC]),
		.en(defaultEnable),
		.INFO(afterD),
		.info(preE)
	);
	
	//insert renewer here
	
	Execute execute(
		.clk(clk),
		.reset(reset),
		.INFO(newE),
		.info(afterE),
		.stop(toExc)
	);
	
	INFOReg EX_MEM(
		.clk(clk),
		.reset(reset|toExc),
		.resetWithPC(`false),
		.en(defaultEnable),
		.INFO(afterE),
		.info(preM)
	);
	
	//insert renewer here
	
	Memory memory(
		.clk(clk),
		.reset(reset),
		.INFO(newM),
		.info(afterM),
		.A_M(A_M),
		.D_M(D_M),
		.O_M(O_M),
		.E_M(E_M),
		.BE_M(BE_M),
		.data(data_cp0),
		.ad(addr_cp0),
		.enable(enable_cp0),
		.CP0reg(content_cp0),
		.toExc(toExc)
	);
	
	INFOReg MEM_WB(
		.clk(clk),
		.reset(reset|toExc),
		.resetWithPC(`false),
		.en(defaultEnable),
		.INFO(afterM),
		.info(preW)
	);
	
	StallControl stallControl(
		.infoD(afterD),
		.infoE(afterE),
		.infoM(afterM),
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
	
	CP0 cp0(
		.clk(clk),
		.reset(reset),
		.HWInt(HWInt[7:2]),
		.preD(preD),
		.preE(preE),
		.preM(preM),
		.preW(preW),
		.preF(preF),
		.din(data_cp0),
		.addr(addr_cp0),
		.enable(enable_cp0),
		.enableInt(enableInt),
		.dout(content_cp0),
		.toExc(toExc),
		.epc(epc),
		.truePC(addr)
	);
	
	//for eret clear:
	always@(*)begin:clearEret
		reg [31:0] instr;
		instr=afterE[`instr];
		if(`isEret)clearDE=1'b1;
		else clearDE=1'b0;
	end
	//for enable interrupt
	always@(*)begin:enableInterruption
		reg [31:0] instr;
		instr=preW[`instr];
		if(`isEret)enableInt=`true;
		else enableInt=`false;
	end

endmodule
