`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:42:28
// Design Name: 
// Module Name: Ready_Gen
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


module Ready_Gen #(parameter HALF_BIT_NUM = 4 //numero di bit per semi-periodo
                   )(
input wire clk, rst,
input wire set,req,
output wire stop,
output reg ready
    );
    
reg [$clog2(HALF_BIT_NUM*2)-1:0] counter , counter_nxt; //conta i colpi di clock necessari a trasmettere LSB

always @(posedge clk, posedge rst)
if (rst=='b1) counter<={$clog2(HALF_BIT_NUM*2){1'b0}};
else counter<=counter_nxt;

always@(counter,set)
if (set==1'b1) //quando inizia la trasmissione dell'ultimo bit verso lo slave viene abilitato il conteggio dei cicli
    if (counter>=HALF_BIT_NUM*2-1) counter_nxt={$clog2(HALF_BIT_NUM*2){1'b0}};
    else  counter_nxt= counter + 1;
else counter_nxt= counter;

assign stop =(counter==HALF_BIT_NUM*2-1) ? 1'b1: 1'b0; //identifica l'ultimo colpo di clock su cui è trasmesso LSB

/*Di default (rst==1) la SPI può accettare nuove transazioni (ready=1), cosa che potrà avvenire anche dopo che è stato trasmesso
completamente LSB.*/
always@(posedge clk, posedge rst)    
if(rst==1'b1) ready<=1'b1;
else if (stop==1'b1) ready<=1'b1;  
     else if (req==1'b1) ready<=1'b0;  


endmodule

