`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:41:46
// Design Name: 
// Module Name: clk_gen
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


module clk_gen #(parameter SPI_MODE =0,
                 parameter HALF_BIT_NUM = 2 //numero di bit per semi-periodo
                )(
    input wire clk, rst,
    input wire idle_v, en_oclk,
    output reg r_edge, f_edge,   
    output  reg  o_clk
    );
    
reg [$clog2(HALF_BIT_NUM*2)-1:0] counter , counter_nxt;

always @(posedge clk, posedge rst)
if (rst=='b1) counter<={$clog2(HALF_BIT_NUM*2){1'b0}};
else counter<=counter_nxt;

always@(counter,en_oclk)
if (en_oclk==1'b0) counter_nxt={$clog2(HALF_BIT_NUM*2){1'b0}}; //conteggio fermo fino a che non arriva l'abilitazione dalla FSM
else if (counter>=HALF_BIT_NUM*2-1) counter_nxt={$clog2(HALF_BIT_NUM*2){1'b0}};
          else  counter_nxt= counter + 1; 

//identificazione del fronte di discesa
always @(posedge clk, posedge rst)
if (rst=='b1) f_edge<=1'b0;
else if (counter==HALF_BIT_NUM*2-1) f_edge<=1'b1;
     else f_edge<=1'b0;

//identificazione del fronte di salita
always @(posedge clk, posedge rst)
if (rst=='b1) r_edge<=1'b0;
else if (counter==HALF_BIT_NUM-1) r_edge<=1'b1;
     else r_edge<=1'b0;

//generazione del clock di trasmissione   
always @(posedge clk, posedge rst)
if(rst==1'b1) o_clk <= idle_v;
else if (en_oclk==1'b0) o_clk <= idle_v;
     else if (f_edge==1'b1 || r_edge==1'b1) o_clk <= ~o_clk;
     
endmodule


