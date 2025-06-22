`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2023 11:49:41
// Design Name: 
// Module Name: Top_Dispatcher
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


module Top_Dispatcher#(
                 parameter SPI_MODE = 3,                      //modalità di trasmissione
                 parameter SPI_CLK_DIVIDER = 8,                //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                 parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,               //SPI_CLK_DIVIDER/2
                 parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
                 parameter SPI_SIZE = 2,           //dimensione dell'SPI_Code
                 parameter SS_SIZE = 2,             //Numero di Slave
                 parameter DATABITS = 8,
                 parameter BITSPI=8,
                 
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
                 parameter OVER_SAMPL_BIT=5,     /*ampiezza in bit per la definizione del sovra campionamento*/
                 parameter ClkXBit = 10415,
                 parameter BitClk=14,
                 parameter Word = 8 ,
                 parameter BitWord = 3,
                 parameter DATAB=8, DATAORE = 4, DATAL = 7, LIVELLO = 9, STAGE = 3
                 )(
    input wire clk, rst, 
    input wire sw,
    input wire [27:0] dob, //ingresso ram
    //input dottore
    input wire status, history, change,
    ///////
    input wire lev,
    /////
    input wire [3:0]o_min, o_dmin, o_ore, o_dore,
    //interfaccia verso la UART
    input wire [2:0] data,
    input wire [8:0] livello,
    input wire [6:0] cntL,
    output wire [6:0] o_massimo,
    input wire transmit,
    input wire [2:0] stage,
    //input
    input wire spi_e,
    input wire [BITSPI-1:0] spi_data1,
    input wire [SPI_SIZE-1:0] spi_code,
    //interfaccia in uscita dalla SPI
    output wire spi_r,spi_d,
    output wire [BITSPI-1:0]spi_data2,   
    //interfaccia verso dottore
    output wire o_status, o_history, o_change, o_sw,
    ////////////////
    //input wire clear,
    ////////////////
    output wire busy,ready,
    //output wire [DATA_BW-1:0] data_out
    output wire Out_Data_Serial
    );
    
    //assegnazione uscite dottore
    assign o_status = status;
    assign o_history = history;
    assign o_change = change;
    assign o_sw = sw;
   // assign o_clear=clear;
    wire [7:0] data_in;
    wire [DATA_BW-1:0] data_out;
    //top module uart
top_DUT#(DATA_BW,DATA_BW_BIT,BAUD_RATE,BAUD_COUNT,BAUD_BIT,BAUD_COUNT_x16,BAUD_BIT_x16,OVER_SAMPL,OVER_SAMPL_BIT) uart(
.clk(clk),.rst(rst),.transmit(transmit),.data_in(data_in),
.busy(busy),.data_out(data_out),.ready(ready));
    //modulo che ci permette di serializzare il dato e stamparlo a schermo tramite putty
Tr_Module  #(ClkXBit, BitClk, Word, BitWord) uart00
(clk,rst,transmit,data_out,uart_active,Out_Data_Serial,uart_done);
   //codifca del messaggio in ascii
Uart_codifica#(DATAB,DATAORE,DATAL,LIVELLO,STAGE) uc(.clk(clk),.rst(rst),.dob(dob),.datain(data),.livello(livello),.cntL(cntL),.minuti(o_min), .dminuti(o_dmin), .ore(o_ore), .dore(o_dore),.stage(stage),
.lunghezza(o_massimo),.dataout(data_in));
   //top module spi
SPI_2slave #(SPI_MODE,SPI_CLK_DIVIDER,CLKS_PER_HALF_BIT,MAX_EDGE_GEN,SPI_SIZE,SS_SIZE,DATABITS) SPI
(clk,rst,lev,spi_e,spi_data1,spi_code,
spi_r,spi_d,spi_data2);
    
endmodule
