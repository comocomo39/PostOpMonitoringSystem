`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2023 15:37:53
// Design Name: 
// Module Name: topmodule
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


module topmodule#(
//parametri modulo SPI
parameter BITSPI=8,
parameter SPI_MODE = 3,    //modalità di trasmissione
parameter SPI_CLK_DIVIDER = 8,    //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,  //SPI_CLK_DIVIDER/2
parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
parameter SPI_SIZE = 2,     //dimensione dell'SPI_Code
parameter SS_SIZE = 2,      //Numero di Slave
parameter DATABITS = 8, //numero di bits dati in ingresso
// parametri system core
parameter MAXD = 50_000_000, //50_000_000
parameter MAXLEV = 500,
parameter MAXB=9,
parameter Nbit = 26, 
parameter DATAB=8, DATAORE = 4, DATAL = 7, STAGE = 3, DATO = 2, DUMMY = 8, LEDB = 16,
                 parameter TT = 6_666_667, BITT= 23,
///// PARAMETRI UART
parameter DATA_BW=8,     //dimensione dato da trasmettere
                 parameter DATA_BW_BIT=4, /*ampiezza in bit contatore per i dati     da trasmettere*/
                 //parametri legati alla velocità di trasmissione
                 parameter BAUD_RATE=9600,   //baud rate: 9600bps 
                 parameter BAUD_COUNT=10416, /*contatore per generare enable baud rate: frequenza (100MHz)/baud_rate*/
                 parameter BAUD_BIT=14,      /*ampiezza in bit contatore baud rate*/
                 //parametri legati alla velocità di ricezione 
                 parameter BAUD_COUNT_x16=651,  /*contatore per generare enable baud rate sovracampionato: frequenza (100MHz)/(baud_rate*over_sampl)*/
                 parameter BAUD_BIT_x16=10,     /*ampiezza in bit contatore baud rate sovra campionato*/
                 //oversamplig rate
                 parameter OVER_SAMPL=16,       //fattore di sovracampionamento
                 parameter OVER_SAMPL_BIT=5, 
                 //parametri tr module
                 parameter ClkXBit = 10415, BitClk=14, Word = 8 , BitWord = 3
)(
 input wire clk, rst,
 input wire lev, history, change, status, sw,
 output wire [LEDB-1:0] led,
 output wire cg,cf,ce,cd,cc,cb,ca,
 output wire an3, an2, an1, an0,
 output wire Out_Data_Serial
    );
    //
    wire o_status, o_history, o_change, o_sw;
    //
/////////////////////    
wire spi_ready,spi_done, spi_e;
wire [BITSPI-1:0] spi_data1,spi_data2;
wire [SPI_SIZE-1:0] spi_code;
 ///////////////////
wire postop;
wire tasto_lev, tasto_change, tasto_hist, tasto_status;
wire fwait, enalarm, enhours, enlev, enchange, enhist, enstatus;
wire [2:0] data;
wire transmit;             /*produttore-UART: dato valido (transmit=1)*/
wire busy;                 /*UART-produttore: trasmissione in corso (busy=1)*/
 /////////
 wire [DATAORE-1:0]o_min, o_dmin, o_ore, o_dore;
 /////////
 wire ready; 
 wire uart_active;
 wire DV;
 wire [DATAL-1:0] cntL;
 wire [DATAL-1:0] o_massimo;
 wire [MAXB-1:0] livello;
 wire [STAGE-1:0] stage;
 wire [27:0] dob; 
 
 
 
System_Core #(MAXLEV,MAXB,Nbit,MAXD, DATABITS,DATAB, DATAORE,DATAL,STAGE,DATO,DUMMY, LEDB, TT, BITT) S1(
.clk(clk),.rst(rst),.busy(busy),.lunghezza(o_massimo),.change(o_change),.status(o_status),.history(o_history),.sw(postop),.spi_done(spi_done),.spi_data2(spi_data2[0]),
.SS(spi_code),.DV(DV),.data(data),.en_spi(spi_e),.spi_data1(spi_data1),.led(led),.ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg),.an0(an0),.an1(an1),.an2(an2),.an3(an3),.livello(livello),
.transmit(transmit), .cntL(cntL),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore),.stage(stage),.dob(dob)); 

doctor #(Nbit, MAXD) d1 (
.clk(clk),.rst(rst),.history(history),.status(status),.change(change),.sw(o_sw),
.postop(postop),.tasto_change(tasto_change),.tasto_hist(tasto_hist),.tasto_status(tasto_status));   

/*SPI_2slave #(SPI_MODE,SPI_CLK_DIVIDER,CLKS_PER_HALF_BIT,MAX_EDGE_GEN,SPI_SIZE,SS_SIZE,DATABITS) SPI
(clk,rst,lev,o_clear,O_spi_e,O_spi_data1,O_spi_code,
spi_ready,spi_done,spi_data2);*/

Top_Dispatcher#(SPI_MODE,SPI_CLK_DIVIDER,CLKS_PER_HALF_BIT,MAX_EDGE_GEN,SPI_SIZE,SS_SIZE,DATABITS,BITSPI,DATA_BW,DATA_BW_BIT,BAUD_RATE,BAUD_COUNT,BAUD_BIT,BAUD_COUNT_x16,BAUD_BIT_x16,OVER_SAMPL,OVER_SAMPL_BIT,ClkXBit, BitClk, Word, BitWord,DATAB,DATAORE,DATAL,MAXB,STAGE) dispatcher (
.clk(clk),.rst(rst),.sw(sw),.dob(dob),.lev(lev),.spi_r(spi_ready),.spi_d(spi_done),/*.clear(clear),*/.spi_e(spi_e),.spi_code(spi_code),.spi_data1(spi_data1),.spi_data2(spi_data2),.status(tasto_status),.history(tasto_hist),.change(tasto_change),.transmit(transmit),.data(data),.livello(livello),.cntL(cntL),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore),.stage(stage),
.o_status(o_status),.o_history(o_history),.o_sw(o_sw),.o_change(o_change),.Out_Data_Serial(Out_Data_Serial),.busy(busy),.ready(ready),.o_massimo(o_massimo)); 
      
endmodule
