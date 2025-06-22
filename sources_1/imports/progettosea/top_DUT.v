`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 11:24:21
// Design Name: 
// Module Name: top_DUT
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



          

module top_DUT #(//parametri legati ai dati da trasmettere
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
                 parameter OVER_SAMPL_BIT=5     /*ampiezza in bit per la definizione del sovra campionamento*/
                )(
                  input wire clk, rst,     //segnali di controllo generali
                 //interfaccia con il produttore: trasmissione
                 input wire transmit,              /*produttore-UART: dato valido (transmit=1)*/
                 input wire [DATA_BW-1:0] data_in, /*produttore-UART: dato da trasmettere*/
                 output wire busy,                 /*UART-produttore: trasmissione in corso (busy=1)*/
                 //interfaccia con il produttore: ricezione
                 output wire [DATA_BW-1:0] data_out, /*UART-produttore: dato ricevuto*/
                 output wire ready                   /*UART-produttore: dato valido (ready=1)*/
    );

wire TX;
   
top_tx #(.DATA_BW(DATA_BW),.DATA_BW_BIT(DATA_BW_BIT),.BAUD_RATE(BAUD_RATE),.BAUD_COUNT(BAUD_COUNT), .BAUD_BIT(BAUD_BIT)) 
        TX_CH(.clk(clk), .rst(rst), .transmit(transmit),.data(data_in),.TX(TX),.busy(busy));
 
top_rx #(.DATA_BW(DATA_BW),.DATA_BW_BIT(DATA_BW_BIT),.BAUD_COUNT_x16(BAUD_COUNT_x16), .BAUD_BIT_x16(BAUD_BIT_x16), .OVER_SAMPL(OVER_SAMPL),.OVER_SAMPL_BIT(OVER_SAMPL_BIT)) 
                RX_CH(.clk(clk), .rst(rst), .RX(TX), .RD(ready),.data_chunck(data_out));

endmodule
