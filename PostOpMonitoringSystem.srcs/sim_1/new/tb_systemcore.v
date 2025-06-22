`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2023 14:50:50
// Design Name: 
// Module Name: tb_systemcore
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

module tb_systemcore;
parameter MAXLEV = 500, MAXB = 9, Nbit = 4, MAXD = 13, DATABITS =8;
parameter DATAB=8, DATAORE = 4, DATAL = 7, STAGE = 3, DATO = 2, DUMMY = 8, LEDB = 16;
parameter TT = 1, BITT= 1;

reg clk, rst;
reg history, change, status, lev , sw;
reg spi_data2;
reg spi_done, busy;
reg [DATAL-1:0] lunghezza;
//////////////////////////////////////
wire en_spi, cg,cf,ce,cd,cc,cb,ca, an3, an2, an1, an0,DV, transmit;
wire [2:0] data;
wire [LEDB-1:0] led;
wire [DATABITS-1:0] spi_data1;
wire [1:0] SS;
wire [MAXB-1:0] livello;
wire [DATAL-1:0] cntL;
wire [DATAORE-1:0]o_min, o_dmin, o_ore, o_dore;
wire[STAGE-1:0] stage;

System_Core #(MAXLEV,MAXB,Nbit,MAXD, DATABITS,DATAB, DATAORE,DATAL,STAGE,DATO,DUMMY, LEDB, TT, BITT) S1(
.clk(clk),.rst(rst),.busy(busy),.lunghezza(lunghezza),.change(change),.status(status),.history(history),.sw(sw),.spi_done(spi_done),.spi_data2(spi_data2),
.SS(SS),.DV(DV),.data(data),.en_spi(en_spi),.spi_data1(spi_data1),.led(led),.ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg),.an0(an0),.an1(an1),.an2(an2),.an3(an3),.livello(livello),
.transmit(transmit), .cntL(cntL),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore),.stage(stage)); 


 always@(spi_data2)
 if(spi_data2)
 begin
 #50 spi_done = 1'b1;
 #35 spi_done = 1'b0;
 end
 else spi_done = 1'b0;

 always #5 clk=~clk;
 initial
 begin
 clk=1'b0;
 rst=1'b1;
 history = 1'b0;
 sw = 1'b0;
 status = 1'b0;
 lev = 1'b0;
 change = 1'b0;
 spi_data2 = 1'b0;
 spi_done = 1'b0;
 busy = 1'b0;
 lunghezza = 7'd0;
 #50 rst = 1'b0;
 #10 sw = 1'b1;
 #10 lunghezza = 7'd31;
 #10 busy = 1'b1;
 #30 busy = 1'b0;
 #10 lev = ~lev;
 #10 spi_data2 = 1'b1;
 #10 spi_data2 = 1'b0;
 #10 lev = ~lev; 
 #10 lev = ~lev; 
 #10 lev = ~lev; 
 #10 lev = ~lev; 
 #10 spi_data2 = 1'b1;
 #10 spi_data2 = 1'b0;
 #10 lev = ~lev; 
 #10 busy = 1'b1;
 #30 busy = 1'b0;
 #10 change = 1'b1;
 #10 change =1'b0;
 #10 busy = 1'b1;
 #30 busy = 1'b0;
 #10 history = 1'b1;
 #10 history = 1'b0;
 end
endmodule
