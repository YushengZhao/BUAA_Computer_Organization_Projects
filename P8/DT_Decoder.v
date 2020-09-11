`timescale 1ns / 1ps

module DT_Decoder(
    input [3:0] data,
    output [7:0] DT_port
    );

	wire is0,is1,is2,is3,is4,is5,is6,is7,is8,is9,isA,isB,isC,isD,isE,isF;
	assign is0=(data==4'h0)?1'b1:1'b0;
	assign is1=(data==4'h1)?1'b1:1'b0;
	assign is2=(data==4'h2)?1'b1:1'b0;
	assign is3=(data==4'h3)?1'b1:1'b0;
	assign is4=(data==4'h4)?1'b1:1'b0;
	assign is5=(data==4'h5)?1'b1:1'b0;
	assign is6=(data==4'h6)?1'b1:1'b0;
	assign is7=(data==4'h7)?1'b1:1'b0;
	assign is8=(data==4'h8)?1'b1:1'b0;
	assign is9=(data==4'h9)?1'b1:1'b0;
	assign isA=(data==4'ha)?1'b1:1'b0;
	assign isB=(data==4'hb)?1'b1:1'b0;
	assign isC=(data==4'hc)?1'b1:1'b0;
	assign isD=(data==4'hd)?1'b1:1'b0;
	assign isE=(data==4'he)?1'b1:1'b0;
	assign isF=(data==4'hf)?1'b1:1'b0;
	
	assign DT_port[0]=~(is2|is3|is4|is5|is6|is8|is9|isA|isB|isD|isE|isF);
	assign DT_port[1]=~(is0|is4|is5|is6|is8|is9|isA|isB|isC|isE|isF);
	assign DT_port[2]=~(is0|is2|is6|is8|isA|isB|isC|isD|isE|isF);
	assign DT_port[3]=~(is0|is2|is3|is5|is6|is8|is9|isB|isC|isD|isE);
	assign DT_port[4]=~(is0|is1|is3|is4|is5|is6|is7|is8|is9|isA|isB|isD);
	assign DT_port[5]=~(is0|is1|is2|is3|is4|is7|is8|is9|isA|isD);
	assign DT_port[6]=~(is0|is2|is3|is5|is6|is7|is8|is9|isA|isC|isE|isF);
	assign DT_port[7]=~(1'b0);

endmodule
