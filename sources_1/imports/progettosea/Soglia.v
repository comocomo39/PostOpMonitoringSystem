`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2023 15:35:35
// Design Name: 
// Module Name: Soglia
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


module Soglia#(parameter MAXB = 9)(
input wire clk, rst, sw,
input wire change, enchange_al,  
input wire [MAXB-1:0]livello, soglia,
output reg alarm, clear
    );
    
    reg alarm_nxt;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) alarm <= 1'b0;
    else alarm <= alarm_nxt;
    
    always@(change,enchange_al, soglia, livello, sw)
    if (sw == 1'b1)
    begin
        if(livello >= soglia)
        begin               
            if(change == 1'b1 && enchange_al == 1'b1)
            begin       
            alarm_nxt = 1'b0;
            clear = 1'b1;
            end
            else
            begin
            alarm_nxt = 1'b1; clear = 1'b0; 
        end
    end
    else
     begin alarm_nxt = 1'b0; clear = 1'b0; 
     end 
    end
    else
     begin alarm_nxt = 1'b0; clear = 1'b0; 
     end 
endmodule
