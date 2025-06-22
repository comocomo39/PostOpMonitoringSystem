`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:39:58
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


module register #(parameter SIZE=8)(
input wire clk, rst,
input wire en,
input wire [SIZE-1:0] data_in,
output reg [SIZE-1:0] data_out
    );
    
always @(posedge clk or posedge rst)
if (rst==1'b1) data_out <= {SIZE{1'b0}};
else if (en == 1'b1) data_out <= data_in;
 
endmodule


