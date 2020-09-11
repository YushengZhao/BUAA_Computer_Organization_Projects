`timescale 1ns / 1ps

module Extender#(parameter from=16,to=32)(
    input [from-1:0] din,
	input selZeroSign,
    output [to-1:0] dout
    );

	assign dout=selZeroSign?{{(to-from){din[15]}},din[15:0]}
							:{{(to-from){1'b0}},din};

endmodule
