`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2023 14:49:51
// Design Name: 
// Module Name: tb_topmodule
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

module tb_topmodule;
/*
parameter BITSPI=8, SPI_MODE = 3,SPI_CLK_DIVIDER = 8,CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2, MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,SPI_SIZE = 2;           //dimensione dell'SPI_Code
parameter SS_SIZE = 2,DATABITS = 8; //numero di bits dati in ingresso
// parametri system core
parameter MAXD = 500,MAXLEV = 500, MAXB=17, Nbit = 7, tt = 20, ttb = 5;
parameter DATAB=8, DATAORE = 4, DATAL = 7, STAGE = 3, DATO = 2, DUMMY = 8, LEDB = 16;
parameter DATA_BW=8,DATA_BW_BIT=4, BAUD_RATE=9600, BAUD_COUNT=10416; 
parameter BAUD_BIT=14, BAUD_COUNT_x16=651,  BAUD_BIT_x16=10, OVER_SAMPL=16,OVER_SAMPL_BIT=5;
parameter ClkXBit = 4, BitClk=3, Word = 8 , BitWord = 3; 
*/
reg clk, rst, status, history, lev, change, sw;
wire cg,cf,ce,cd,cc,cb,ca;
wire an3, an2, an1, an0;
wire [15:0] led;
wire Out_Data_Serial;

topmodule /*#(BITSPI,SPI_MODE, SPI_CLK_DIVIDER, CLKS_PER_HALF_BIT,MAX_EDGE_GEN, SPI_SIZE, SS_SIZE, DATABITS,MAXD, MAXLEV, MAXB, Nbit,
DATAB, DATAORE, DATAL, STAGE, DATO, DUMMY, LEDB, tt, ttb, DATA_BW, DATA_BW_BIT, BAUD_RATE, BAUD_COUNT, BAUD_BIT, BAUD_COUNT_x16,BAUD_BIT_x16, OVER_SAMPL,
OVER_SAMPL_BIT,ClkXBit, BitClk, Word,BitWord )*/ t1(.clk(clk),.rst(rst),.status(status),.history(history),.lev(lev),.change(change),.sw(sw),.led(led)
,.ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg),.an0(an0),.an1(an1),.an2(an2),.an3(an3),.Out_Data_Serial(Out_Data_Serial));

always #5 clk=~clk;

initial
begin
clk=1'b0;
rst=1'b1;
status = 1'b0;
history = 1'b0;
lev = 1'b0;
change = 1'b0;
sw = 1'b0;
#50 rst = 1'b0;
#50000 sw = 1'b1;
#10000 lev = ~lev;
#10000 lev = ~lev;
#10000 lev = ~lev;
#10000 lev = ~lev;
#10000 status = ~status;
#10000 status = ~status;
#10000 change = ~change;
#10000 change = ~change;
#10000 lev = ~lev;
#10000 lev = ~lev;
#10000 history = ~history;
#10000 history = ~history;

end

endmodule

