`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2023 11:38:34
// Design Name: 
// Module Name: ContaLev
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


module ContaLev#(parameter MAX = 500, MAXB = 9)(
input wire clk, rst,
input wire enlev, lev, 
input wire enchange, // en generato dalla macchina a stati del system core che azzera il livello
input wire clear, // en generato dal modulo Soglia che azzera il livello
input wire sw,
output reg [MAXB-1:0] livello,
output reg enram
    );
    
    reg [MAXB-1:0] livello_nxt;
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) livello <= {MAX{1'b0}};
    else if (sw == 1'b0) livello <= {MAX{1'b0}};
    else livello <= livello_nxt;
    
    always@(enlev, enchange, clear,livello)
    if(enchange == 1'b1 || clear == 1'b1)
    begin
    livello_nxt = {MAX{1'b0}};
    enram = 1'b0;
    end
    else if(enlev == 1'b1 && enchange == 1'b0 && clear == 1'b0 && livello <= 9'd495)
    begin
    livello_nxt = livello + 3'd5;
    enram = 1'b1;
    end
    else begin
    livello_nxt = livello;
    enram = 1'b0;
    end
    
endmodule
