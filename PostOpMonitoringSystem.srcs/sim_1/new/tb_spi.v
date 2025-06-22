`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2023 14:11:11
// Design Name: 
// Module Name: tb_spi
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


module tb_spi;
  parameter SPI_MODE = 3; //modalità di trasmissione
    parameter SPI_CLK_DIVIDER = 8;               //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2;               //SPI_CLK_DIVIDER/2
    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2;
    parameter SPI_SIZE = 2;          //dimensione dell'SPI_Code
    parameter SS_SIZE = 2;             //Numero di Slave
    //parametri moduli slave
    parameter DATABITS = 8; //numero di bits dati in ingresso
// Inputs
reg r_Clk;
reg rst;
reg lev;
reg i_TX_DV_M;
reg [DATABITS-1:0]i_TX_Byte_M;
reg [SPI_SIZE-1:0] SPI_Code;

// Outputs
wire o_TX_Ready_M;
wire o_RX_DV_M;
wire [DATABITS-1:0]o_RX_Byte_M;

SPI_2slave uut (
.clk(r_Clk),
.rst(rst),
.lev(lev),
.i_TX_DV_M(i_TX_DV_M),
.i_TX_Byte_M(i_TX_Byte_M),
.SPI_Code(SPI_Code),
.o_TX_Ready_M(o_TX_Ready_M),
.o_RX_DV_M(o_RX_DV_M),
.o_RX_Byte_M(o_RX_Byte_M)
);


always #5 r_Clk = ~r_Clk;

integer fd;
initial
    begin
    lev = 1'b1;
      fd = $fopen("log.txt", "w"); 
      r_Clk    = 1'b0;
      rst = 1'b0;
      i_TX_DV_M = 1'b0;
      #100
      rst  = 1'b1;
      #100
      @(negedge r_Clk) rst  = 1'b0;
      SendSingleByte(8'h00, 2'b00);
      SendSingleByte(8'h11, 2'b01);
      SendSingleByte(8'h25, 2'b01);
      SendSingleByte(8'h41, 2'b01);
      SendSingleByte(8'h82, 2'b01);
      SendSingleByte(8'h25, 2'b10);
      SendSingleByte(8'h11, 2'b10);
      SendSingleByte(8'h11, 2'b10);
      #1000
      $fclose(fd);
      $stop;      
    end // initial begin
    task SendSingleByte;
    input [7:0] data; //data da trasmettere  
    input [SPI_SIZE:0] spi_code; // slave select
    begin
       @(negedge r_Clk)
        //byte trasmesso alla SPI sollevando il valid contestualmente
        SPI_Code<=spi_code;
        i_TX_Byte_M <= data; 
        i_TX_DV_M   <= 1'b1; 
        @(negedge r_Clk)
        i_TX_DV_M <= 1'b0; // il valid rimane alto un colpo di clock 
        /*non si esce dal task (quindi non si abilitano potenzialmente nuove transazioni) 
        fino a che la SPI non è di nuovo disponibile*/
        @(negedge o_RX_DV_M); //wait for the answer to come
        $display("W-MASTER: Sent out 0x%X, Received 0x%X", data, i_TX_Byte_M); 
        $fwrite(fd, "MASTER: At %t sent out 0x%X, Received 0x%X \n", $time, data, i_TX_Byte_M);
     end
     endtask










endmodule
