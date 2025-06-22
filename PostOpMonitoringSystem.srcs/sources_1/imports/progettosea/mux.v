`timescale 1ns / 1ps
module mux
(input wire [3:0] seg0, seg1, seg2, seg3,
input wire [1:0] sel,
output reg [3:0] in_seg
    );
   
   always @ (seg0, seg1, seg2, seg3, sel)
   case (sel)
   2'b00: in_seg=seg0;
   2'b01: in_seg=seg1;
   2'b10: in_seg=seg2;
   2'b11: in_seg=seg3;
   default: in_seg=4'bxxxx;
   endcase
   
   endmodule 