`timescale 1ns / 1ps

module UserKeyDriver(//implements ROM
    input [7:0] user_key,
    output [31:0] data
    );

	assign data={24'b0,~user_key[7:0]};

endmodule
