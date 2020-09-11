`timescale 1ns / 1ps


module mips_tb;

	// Inputs
	reg clk;
	reg reset;
	reg interrupt;

	// Outputs
	wire [31:0] addr;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset), 
		.interrupt(interrupt), 
		.addr(addr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		interrupt = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		reset=0;
	end
	always #2 clk=~clk;
      
endmodule
