`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2021 17:05:56
// Design Name: 
// Module Name: register
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

module registro #(parameter N=16)(
input wire [N-1:0] D,
input wire load,
input wire clk, rst,
output reg [N-1:0] Q 
    );
     
 always@(posedge clk, posedge rst)
 if (rst==1'b1) Q<={N{1'b0}};
 else if(load==1'b1) Q<=D;   
 
endmodule

