`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2021 22:29:09
// Design Name: 
// Module Name: RegPar
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegPar#(parameter N = 32)(
input wire clk,reset,
input wire en, 
input wire [N-1:0]in,
output reg [N-1:0]out
);
reg [N-1:0]regi;

always @(posedge clk, posedge reset)
if(reset==1'b1)out<={N{1'b0}};
else out<=regi;

always @(in,en,out)
if(en==1'b1)regi=in;
else regi=out; 
endmodule
