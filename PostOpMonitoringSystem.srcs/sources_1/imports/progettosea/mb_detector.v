`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 14:13:24
// Design Name: 
// Module Name: mb_detector
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


module mb_detector #(parameter OVER_SAMPL=16,
                     parameter OVER_SAMPL_BIT=5
                    )(
                    input wire clk, rst,
                    output reg hit_m
    );
  
wire [OVER_SAMPL_BIT-1:0] count_mb;

counter #(.MAX(OVER_SAMPL),.N_BIT(OVER_SAMPL_BIT)) CNT_MB(.clk(clk), .rst(rst),.en(1'b1),.count(count_mb));
     
always@(posedge clk, posedge rst)
if (rst=='b1) hit_m<=1'b0;
else if(count_mb==(OVER_SAMPL/2)-1) hit_m<=1'b1;
     else hit_m<=1'b0; 

endmodule

