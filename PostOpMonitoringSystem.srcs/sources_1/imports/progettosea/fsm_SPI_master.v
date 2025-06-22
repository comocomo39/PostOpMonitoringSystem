`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:41:21
// Design Name: 
// Module Name: fsm_SPI_master
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


module fsm_SPI_master(
    input wire clk, rst,    //segnali di controllo globali
    input wire last_edge,    //identifica l'ultimo colpo di clock del LSB su MOSI 
    input wire tx,          //i_TX_DV
    output reg en_d,        //identifica la trasmissione in corso su MOSI
    output reg clear_d,
    output reg en_oclk      //abilita generazione clock di sincronizzazione
    );
    
parameter IDLE=1'b0, TRX=1'b1;

reg state, state_nxt;    

//logica sequenziale: registro di stato    
always @(posedge clk, posedge rst)
if (rst==1'b1) state<=IDLE;
else state<=state_nxt;

//logica combinatoria: stato futuro
always@(state,last_edge,tx)
case(state)
//stato di riposo da cui si esce se c'è un dato valido da trasmettere su MOSI
IDLE: if (tx==1'b1) state_nxt=TRX;
      else state_nxt=IDLE;
/*stato di trasmissione da cui si esce quando su MOSI si completa la trasmissione del LSB*/
TRX:  if (last_edge==1'b1) state_nxt=IDLE;
      else state_nxt=TRX;
default: state_nxt=IDLE;
endcase

//logica combinatoria: uscite
always@(state, last_edge, tx)
case(state)
IDLE: begin
      en_d=1'b0; //trasmissione non in corso
      clear_d = 1'b1;
      /*quando si va verso la trasmissione si deve abilitare la generazione del    clock di sincronizzazione*/
      if (tx==1'b1) en_oclk=1'b1;
      else en_oclk=1'b0;
      end
TRX:  begin
      en_d=1'b1; //trasmissione non in corso
/*quando si esce dalla trasmissione si deve disabilitare la generazione del clock di sincronizzazione*/
      if (last_edge==1'b1)
        begin
        en_oclk=1'b0; 
        clear_d = 1'b1;
        end
      else 
        begin
        en_oclk=1'b1; 
        clear_d = 1'b0;
        end
      end

default: begin
         en_d=1'b0;
         en_oclk=1'b0;
         end
endcase

endmodule
