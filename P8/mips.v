`timescale 1ns / 1ps

module mips(

	input clk_in,
	input sys_rstn,
	
	input uart_rxd,
	output uart_txd,
	
	input [7:0] dip_switch0,
	input [7:0] dip_switch1,
	input [7:0] dip_switch2,
	input [7:0] dip_switch3,
	input [7:0] dip_switch4,
	input [7:0] dip_switch5,
	input [7:0] dip_switch6,
	input [7:0] dip_switch7,
	
	input [7:0] user_key,
	
	output [31:0] led_light,
	//100,000cycles
	output [7:0] digital_tube2,
	output digital_tube_sel2,
	output [7:0] digital_tube1,
	output [3:0] digital_tube_sel1,
	output [7:0] digital_tube0,
	output [3:0] digital_tube_sel0
    );

	wire clk1,clk2,reset;
	wire [7:2] HWInt;
	wire timer_int,interrupt;
	reg timer_En,DM_En,UART_En,led_En,DT_En;
	wire [31:0] timer_Data,DM_Data,UART_Data,led_Data,DT_Data;
	wire [31:0] timer_Out,DM_Out,UART_Out,key_Out,led_Out,switch_Out,DT_Out;
	wire [31:0] timer_Addr,DM_Addr,UART_Addr,key_Addr,led_Addr,switch_Addr,DT_Addr;
	wire [31:0] PC,truePC,ins,D_M,O_M,A_M;
	wire E_M;
	wire [3:0] BE_M,BE;
	
	assign HWInt[7:2]={4'b0,interrupt,timer_int};
	assign reset=~sys_rstn;
	
	
	/*
	Clock clock(
		// Clock in ports
		.CLK_IN1(clk_in),       // IN
		// Clock out ports
		.CLK_OUT1(clk1),     // OUT
		.CLK_OUT2(clk2)      // OUT
	);
	*/
	
	Clock clock(
		// Clock in ports
		.CLK_IN1(clk_in),       // IN
		// Clock out ports
		.CLK_OUT1(clk1),     // OUT
		.CLK_OUT2(clk2)      // OUT
	);
	
	CPU cpu(
		.clk(clk1),
		.reset(reset),
		.HWInt(HWInt),
		.PC(PC),
		.ins(ins),
		.D_M(D_M),
		.O_M(O_M),
		.A_M(A_M),
		.E_M(E_M),
		.BE_M(BE_M)
	);
	
	//read logic
	assign UART_Addr=A_M-32'h7f10;
	assign timer_Addr={A_M[31:2],2'b0};
	assign key_Addr={A_M[31:2],2'b0};//useless
	assign led_Addr={A_M[31:2],2'b0};//useless
	assign switch_Addr={A_M[31:2],2'b0};
	assign DT_Addr={A_M[31:2],2'b0};
	assign DM_Addr=A_M;
	
	assign O_M=(A_M>=0 && A_M<=32'h1fff)?DM_Out:
			   (A_M>=32'h7f00 && A_M<=32'h7f0b)?timer_Out:
			   (A_M>=32'h7f10 && A_M<=32'h7f2b)?UART_Out:
			   (A_M>=32'h7f2c && A_M<=32'h7f33)?switch_Out:
			   (A_M>=32'h7f34 && A_M<=32'h7f37)?led_Out:
			   (A_M>=32'h7f38 && A_M<=32'h7f3f)?DT_Out:
			   (A_M>=32'h7f40 && A_M<=32'h7f43)?key_Out:
			   32'hffffffff;//debug
	
	//write logic
	assign UART_Data=D_M;
	assign timer_Data=D_M;
	assign led_Data=D_M;
	assign DT_Data=D_M;
	assign DM_Data=D_M;
	
	always@(*)begin
		UART_En=1'b0;
		timer_En=1'b0;
		led_En=1'b0;
		DT_En=1'b0;
		DM_En=1'b0;
		if(A_M>=32'h7f10 && A_M<=32'h7f2b)UART_En=E_M;
		else if(A_M>=32'h7f00 && A_M<=32'h7f0b)timer_En=E_M;
		else if(A_M>=32'h7f34 && A_M<=32'h7f37)led_En=E_M;
		else if(A_M>=32'h7f38 && A_M<=32'h7f3f)DT_En=E_M;
		else if(A_M>=0 && A_M<=32'h1fff)DM_En=E_M;
	end
	
	assign BE=DM_En?BE_M:4'b0;
	
	MiniUART miniUART(
		.CLK_I(clk1),
		.RST_I(reset),
		.DAT_I(UART_Data),
		.DAT_O(UART_Out),
		.ADD_I(UART_Addr[4:2]),
		.WE_I(UART_En),
		.STB_I(UART_En),//?
		.ACK_O(),
		.RxD(uart_rxd),
		.TxD(uart_txd),
		.interrupt(interrupt)
	);
	
	TC timer(
		.clk(clk1),
		.reset(reset),
		.Addr(timer_Addr[31:2]),
		.WE(timer_En),
		.Din(timer_Data),
		.Dout(timer_Out),
		.IRQ(timer_int)
	);
	
	UserKeyDriver userKeyDriver(
		.user_key(user_key),
		.data(key_Out)
	);
	
	LEDLightDriver LED_Driver(
		.clk(clk1),
		.reset(reset),
		.led_light(led_light),
		.LED_En(led_En),
		.LED_Data(led_Data),
		.LED_Out(led_Out)
	);
	
	DipSwitchDriver dipSwitchDriver(
		.dip_switch0(dip_switch0),
		.dip_switch1(dip_switch1),
		.dip_switch2(dip_switch2),
		.dip_switch3(dip_switch3),
		.dip_switch4(dip_switch4),
		.dip_switch5(dip_switch5),
		.dip_switch6(dip_switch6),
		.dip_switch7(dip_switch7),
		.addr(switch_Addr),
		.data(switch_Out)
	);
	
	DigitalTubeDriver digitalTubeDriver(
		.clk(clk1),
		.reset(reset),
		.DT_En(DT_En),
		.DT_Addr(DT_Addr),
		.DT_Data(DT_Data),
		.DT_Out(DT_Out),
		.digital_tube2(digital_tube2),
		.digital_tube_sel2(digital_tube_sel2),
		.digital_tube1(digital_tube1),
		.digital_tube_sel1(digital_tube_sel1),
		.digital_tube0(digital_tube0),
		.digital_tube_sel0(digital_tube_sel0)
	);
	
	//DM
	/*
	DataMemory dataMemory (
	  .clka(clk2), // input clka
	  .wea(BE_M), // input [3 : 0] wea
	  .addra(DM_Addr[12:2]), // input [10 : 0] addra
	  .dina(DM_Data), // input [31 : 0] dina
	  .douta(DM_Out) // output [31 : 0] douta
	);
	*/
	
	DataMemory dataMemory (
	  .clka(clk2), // input clka
	  .wea(BE), // input [3 : 0] wea
	  .addra(DM_Addr[12:2]), // input [10 : 0] addra
	  .dina(DM_Data), // input [31 : 0] dina
	  .douta(DM_Out) // output [31 : 0] douta
	);
	
	//IM
	/*
	IM im (
	  .clka(clk2), // input clka
	  .wea(4'b0), // input [3 : 0] wea //always disable WE
	  .addra(truePC[12:2]), // input [10 : 0] addra //ensure alignment
	  .dina(32'b0), // input [31 : 0] dina //useless
	  .douta(ins) // output [31 : 0] douta //instruction
	);
	*/
	assign truePC=PC-32'h3000;
	
	IM im (
	  .clka(clk2), // input clka
	  .wea(4'b0), // input [3 : 0] wea //always disable WE
	  .addra(truePC[12:2]), // input [10 : 0] addra //ensure alignment
	  .dina(32'b0), // input [31 : 0] dina //useless
	  .douta(ins) // output [31 : 0] douta //instruction
	);
	
endmodule
