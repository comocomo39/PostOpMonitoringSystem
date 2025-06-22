`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 15:53:42
// Design Name: 
// Module Name: counter_clr
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


module counter_clr# (parameter MAX=10,
                     parameter N_BIT=4)(
input wire clk, rst,
input wire en,clear,
output reg [N_BIT-1:0] count
    );
    
reg [N_BIT-1:0] count_nxt;

always@(posedge clk, posedge rst)
if (rst==1'b1) count<={N_BIT{1'b0}};
else count<=count_nxt;  

always@(en,count,clear)
if (clear==1'b1) count_nxt={N_BIT{1'b0}};
else if (en==1'b0) count_nxt=count;
     else if (count==(MAX-1)) count_nxt={N_BIT{1'b0}};
          else count_nxt=count+1;   

endmodule
