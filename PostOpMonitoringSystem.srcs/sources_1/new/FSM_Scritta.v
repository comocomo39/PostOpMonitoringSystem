`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2023 16:35:49
// Design Name: 
// Module Name: FSM_Scritta
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


module FSM_Scritta(
input wire clk, rst,
input wire x,
output reg y
    );
   //fsm usata per generare un segnale alto un istante di clock
   //per creare le stampe di sw e alarm (segnali che rimangono alti)
   parameter IDLE = 2'b00, S0 = 2'b01, S1 = 2'b10;
   
   reg[1:0] state, state_nxt;
   always@(posedge clk, posedge rst)
   if (rst) state <= IDLE;
   else state <= state_nxt;
   
   always@(state, x)
   case(state)
   IDLE: if (x == 1'b1) state_nxt = S0;
   else state_nxt = IDLE;
   S0: state_nxt = S1;
   S1: if(x == 1'b0) state_nxt = IDLE;
   else state_nxt = S1;
   default: state_nxt = IDLE;
   endcase
   
   always@(state)
   case(state)
   IDLE: y = 1'b0;
   S0:y = 1'b1;
   S1:y = 1'b0;
   default:y = 1'b0;
   endcase
   
endmodule
