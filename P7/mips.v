`timescale 1ns / 1ps

module mips(
	input clk,
	input reset,
	input interrupt,
	output [31:0] addr
    );

	wire [7:2] HWInt;
	wire t0int,t1int,t0E,t1E,DME;
	wire [31:0] t0D,t0O,t0A,t1D,t1O,t1A,DMD,DMA,DMO;
	wire [31:0] PC,ins,D_M,O_M,A_M;
	wire E_M;
	
	assign HWInt[7:2]={3'b0,interrupt,t1int,t0int};

	CPU cpu(
		.clk(clk),
		.reset(reset),
		.HWInt(HWInt),
		.addr(addr),
		.PC(PC),
		.ins(ins),
		.D_M(D_M),
		.O_M(O_M),
		.A_M(A_M),
		.E_M(E_M)
	);
	
	Bridge bridge(
		.A1(PC),
		.O1(ins),
		.A2(A_M),
		.D2(D_M),
		.E(E_M),
		.O2(O_M),
		.t0D(t0D),
		.t0A(t0A),
		.t0E(t0E),
		.t0O(t0O),
		.t1D(t1D),
		.t1A(t1A),
		.t1E(t1E),
		.t1O(t1O),
		.DMD(DMD),
		.DMA(DMA),
		.DME(DME),
		.DMO(DMO)
	);
	
	TC timer0(
		.clk(clk),
		.reset(reset),
		.Addr(t0A[31:2]),
		.WE(t0E),
		.Din(t0D),
		.Dout(t0O),
		.IRQ(t0int)
	);
	
	TC timer1(
		.clk(clk),
		.reset(reset),
		.Addr(t1A[31:2]),
		.WE(t1E),
		.Din(t1D),
		.Dout(t1O),
		.IRQ(t1int)
	);
	
	DataMemory dataMemory(
		.clk(clk),
		.reset(reset),
		.D(DMD),
		.A(DMA[31:2]),
		.E(DME),
		.O(DMO)
	);

endmodule
