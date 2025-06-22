`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:43:04
// Design Name: 
// Module Name: modeAdapter
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


module modeAdapter#(parameter SPI_MODE =3,
                    parameter MAX_EDGE_GEN = 16)(
    input wire clk, rst,
    input wire in_sclk,
    input wire in_r_edge, in_f_edge,
    input wire clear_d,
    input wire idle_v,
    output reg out_sclk,
    output reg out_r_edge, out_f_edge,
    output wire last_edge
    );
  // In order to make the system work in modes 0 and 2, where there is a problem of "receiving the data before sending it",
  // this piece of hardware has been added. This module skips the first front of sCLK in order
  // to send the data before receiving it.
  reg skipOne; 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) skipOne<=1'b0;
  else if (clear_d == 1'b1)
       skipOne<=1'b0;
  else if ((in_f_edge==1'b1 || in_r_edge==1'b1) && skipOne == 1'b0)
       skipOne<=1'b1; 
    
  always@(posedge clk, posedge rst)
  if (rst==1'b1) 
  begin
    out_sclk<=~idle_v;
    out_r_edge <= 1'b0;
    out_f_edge <= 1'b0;
  end
  else if (clear_d == 1'b1)
  begin
    out_sclk<=~idle_v;
    out_r_edge <= 1'b0;
    out_f_edge <= 1'b0;
  end
  else if (SPI_MODE == 1 || SPI_MODE == 3 || skipOne == 1'b1)
  begin
    out_sclk<=in_sclk;
    out_r_edge <= in_r_edge;
    out_f_edge <= in_f_edge;
  end 
  //assign out_sclk = (SPI_MODE == 1 || SPI_MODE == 3 || skipOne == 1'b1) ? in_sclk:~idle_v;
  //assign out_r_edge = (SPI_MODE == 1 || SPI_MODE == 3 || skipOne == 1'b1) ? in_r_edge:1'b0;
  //assign out_f_edge = (SPI_MODE == 1 || SPI_MODE == 3 || skipOne == 1'b1) ? in_f_edge:1'b0;
  
  // In order to make the system work in mode 1, where the sCLK generation is not enabled during enough time,
  // this piece of hardware has been added. This module counts the amount of valid sCLK fronts generated and, once it has
  // counted 2 times the bits composing the packet to be send (e.g., when sending 8 bits --1 byte--, it will count 16),
  // it generates an end_of_count signal to trigger the status to change from TX to IDLE in the FSM.
  reg[$clog2(MAX_EDGE_GEN):0] counterClkFronts; 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) counterClkFronts<={$clog2(MAX_EDGE_GEN){1'b0}};
  else if (counterClkFronts == MAX_EDGE_GEN || clear_d == 1'b1)
       counterClkFronts<={$clog2(MAX_EDGE_GEN){1'b0}};
  else if (out_f_edge==1'b1 || out_r_edge==1'b1)
       counterClkFronts<=counterClkFronts+1;  
  
  assign last_edge = (counterClkFronts == MAX_EDGE_GEN)?1'b1:1'b0;
endmodule


module modeAdapterS#(parameter SPI_MODE =3)(
    input wire clk, rst,
    input wire SPI_clk_M, 
    input wire [2:0] TX_cnt,
    input wire [2:0] RX_cnt,
    output reg  SPI_clk_S,
    output reg enableReception,
    output reg ignoreReturnToIdle
    );
  
  //Since we are always receiving in posedge and sending in negedge, 
  //for modes 1 and 2 we have to switch the Sclk
  always@(SPI_clk_M)
  if (SPI_MODE == 1 || SPI_MODE==2 ) SPI_clk_S=~SPI_clk_M;
  else SPI_clk_S=SPI_clk_M;
    
  //In modes 1 and 3 we have to skip the first Sclk edge, because we are receiving before sending
  always@(posedge clk, posedge rst)
  if (rst==1'b1) enableReception<=1'b0;
  else if (SPI_MODE == 0 || SPI_MODE == 2) enableReception <= 1'b1;
  else if (TX_cnt == 3'd6) enableReception<=1'b1;
  else if (RX_cnt == 3'd7) enableReception<=1'b0; 
  
  //Since we have not an idle state in here (no FSM at all), we have to skip the Sclk transition that occurs in the master
  //when it goes to idle --and, thus, the Sclk--
  always@(negedge SPI_clk_S, posedge rst)
  if (rst==1'b1) ignoreReturnToIdle<=1'b0;
  else if (SPI_MODE == 0 || SPI_MODE == 2) ignoreReturnToIdle <= 1'b0;
  else if (RX_cnt == 3'd0) ignoreReturnToIdle<=1'b1;
  else if (RX_cnt == 3'd7) ignoreReturnToIdle<=1'b0; 
  
endmodule
