`timescale 1ns / 1ps
module cnt(
input wire clk, rst,
input wire refresh,
output reg[1:0] count);

reg [1:0] cnt_nxt;

always@(posedge clk or posedge rst)
if(rst==1'b1) count<=2'd0;
else count<= cnt_nxt;

always@(count,refresh)
if(refresh==1'b1) cnt_nxt= count + 2'd1;
else cnt_nxt = count;

endmodule