`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2023 11:31:43
// Design Name: 
// Module Name: DW
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


module DW(
input wire clk,rst,set,
input wire DVH,
input wire[6:0] init,
output reg[6:0] cnt,
output reg[3:0] soglia
    );
    
    reg[6:0]cnt_nxt; // è il cnt delle celle delle ram, ci serve per tenere conto di quante volte abbiamo scritto e dare
    // l'indirizzo
    
    reg [3:0]snxt; 
    
    always@(posedge clk, posedge rst)
    if(rst==1'b1) cnt<= 7'd0;
    else cnt<=cnt_nxt;
    
    
    
    always@(posedge clk, posedge rst)
    if(rst==1'b1) soglia<= 4'd0;
    else soglia<=snxt;
    
    always@(set, init, cnt, DVH, soglia)
    if(set==1'b1)
    begin
    if(init<7'd10)
    begin
    cnt_nxt = init;
    snxt = init;
    end
    else begin cnt_nxt = init; snxt = 4'd10; end
    end
    else if(DVH == 1'b1 && cnt >= 7'd0)
    begin
    snxt = soglia;
    cnt_nxt = cnt - 1;
    end
    else begin cnt_nxt = cnt; snxt = soglia; end
    
    
    
endmodule
