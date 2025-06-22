`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2023 12:37:31
// Design Name: 
// Module Name: Conta24h
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


module Conta24h #(parameter OMmax=50000000,OMbit=23, DATAORE = 4) (
input wire clk,rst,sw,
output wire clear,
output wire [DATAORE-1:0] o_min, o_dmin, o_ore, o_dore);
localparam MIN=9,DMIN=5,ORE=9,DORE=2,SIZE=4;
wire o_OMC;

OMC #(OMmax,OMbit) omc(clk,rst,OM_en); //avvisa ogni "minuto" (1/15 di secondo)

CounterEn #(SIZE,MIN) CenMinuti (clk,rst,sw,OM_en,clear,o_min,en1);//minuti massimo 9
CounterEn #(SIZE,DMIN) CenDecineMinuti (clk,rst,sw,en1,clear,o_dmin,en2);//decine di minuti massimo 5
CounterEn #(SIZE,ORE) CenOre (clk,rst,sw,en2,clear,o_ore,en3);//ore massimo 9
CounterEn #(SIZE,DORE) CenDecineOre (clk,rst,sw,en3,clear,o_dore,en_lost);//decine di ore massimo 2

// devo controllare che il numero massimo sia 23:59, cosi da poter alzare il clear per il passaggio delle 24h
assign clear=(o_min==MIN && o_dmin==DMIN && o_ore==4'b0011 && o_dore==DORE && en2==1'b1)?1'b1:1'b0;

assign o_OMC=OM_en;


endmodule

