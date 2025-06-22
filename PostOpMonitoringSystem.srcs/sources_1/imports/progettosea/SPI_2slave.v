`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:35:36
// Design Name: 
// Module Name: SPI_3slave
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


module SPI_2slave #(
  //parametri modulo SPI
    parameter SPI_MODE = 3,                      //modalità di trasmissione
    parameter SPI_CLK_DIVIDER = 8,                //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,               //SPI_CLK_DIVIDER/2
    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
    parameter SPI_SIZE = 2,           //dimensione dell'SPI_Code
    parameter SS_SIZE = 2,             //Numero di Slave
    //parametri moduli slave
    parameter DATABITS = 8 //numero di bits dati in ingresso
    )

    (
    //INPUT
    input wire clk,rst,
    input wire lev,//clear,
    input wire i_TX_DV_M,
    input wire [DATABITS-1:0]i_TX_Byte_M,
    input wire [SPI_SIZE-1:0] SPI_Code,
    //OUTPUT
    output wire o_TX_Ready_M,
    output wire o_RX_DV_M,
    output wire [DATABITS-1:0]o_RX_Byte_M
    );
    
          //segnali di intefaccia SPI-slave
    wire [DATABITS-1:0]  i_TX_Byte_S0,i_TX_Byte_S1;
    wire i_TX_DV_S0,i_TX_DV_S1;
    //wire o_TX_Ready_S0,o_TX_Ready_S1,o_TX_Ready_S2,o_TX_Ready_S3;
    wire       o_RX_DV_S0,o_RX_DV_S1;
    wire [DATABITS-1:0] o_RX_Byte_S0,o_RX_Byte_S1;
    
      //SPI 1 master 2 slave
    SPI_top     #(SPI_MODE,SPI_CLK_DIVIDER,SPI_CLK_DIVIDER/2,SPI_CLK_DIVIDER*2,SPI_SIZE,SS_SIZE) SPI
    (
     clk, rst,
     i_TX_Byte_M,
     i_TX_Byte_S0,i_TX_Byte_S1,
     i_TX_DV_M,
     i_TX_DV_S0,i_TX_DV_S1,
     SPI_Code,
     o_TX_Ready_M,
     //o_TX_Ready_S0,o_TX_Ready_S1,o_TX_Ready_S2,o_TX_Ready_S3,        
     o_RX_DV_M,o_RX_Byte_M,
     o_RX_DV_S0,o_RX_DV_S1,
     o_RX_Byte_S0,o_RX_Byte_S1
     );
     
     top_LEV #(.DATABITS(DATABITS),.SIZE(1),.Nbit(200),.MAX(1000)) tlev(
    .clk(clk),.rst(rst),
    .lev(lev), 
    .RX_Data(o_RX_Byte_S0),
    .RX_DV(o_RX_DV_S0),
    .TX_Data(i_TX_Byte_S0),
    .TX_DV(i_TX_DV_S0)
    );
    
    top_POST #(.DATABITS(DATABITS),.SIZE(1),.Nbit(200),.MAX(1000)) tpost(
    .clk(clk),.rst(rst),
    //.clear(clear), 
    .RX_Data(o_RX_Byte_S1),
    .RX_DV(o_RX_DV_S1),
    .TX_Data(i_TX_Byte_S1),
    .TX_DV(i_TX_DV_S1)
    );
 
endmodule

