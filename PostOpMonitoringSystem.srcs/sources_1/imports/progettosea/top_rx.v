`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2021 14:38:06
// Design Name: 
// Module Name: top_rx
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

module top_rx #(parameter DATA_BW=8,
                parameter DATA_BW_BIT=4,
                parameter BAUD_COUNT_x16=651, //with BAUD_RATE 9600bps, oversampling 16 and system clk 100MHz --> baud rate counter x 16 is 651 represented with 10 bits
                parameter BAUD_BIT_x16=10,
                parameter OVER_SAMPL=15,
                parameter OVER_SAMPL_BIT=5)(
                input wire clk, rst,
                input wire RX,
                output wire RD,
                output wire [DATA_BW-1:0] data_chunck           
    );
    
//gestione sovra-campionamento
/*segnale di sincronizzazione generato sulla base del BAUD RATE x 16*/
wire baud_clk_16; 
/*segnale di identificazione del MIDBIT (hit_m=1) */
wire hit_m; 

//gestione contatore dati ricevuti
/*Conteggio dati*/
wire [DATA_BW_BIT-1:0] count_data; 
/*CONTATORE-->FSM segnala (hit_d=1) la trasmissione dell'ultimo bit di informazione*/
wire hit_d; 
/*FSM-->CONTATORE abilita (en_d=1) il conteggio dei dati ricevuti*/
wire en_d;

//gestione del registro di output
/* segnale di abilitazione campionamento dato ricevuto: 
ALTO in corrispondenza del MIDBIT (hit_m=1) dei bit di informazione (load=1) all'interno del frame*/
wire en_rx;
/*FSM-->REGISTRO DI USCITA segnala (load=1) la ricezione dei bit di informazione*/
wire load;

//altri segnali di controllo
/*FSM-->CONTATORE e FSM-->REGISTRO DI USCITA ripristino (clear=1) dei valori di default*/
wire clear; 

//gestione sovra-campionamento
/*with BAUD_RATE 9600bps, oversampling 16 and system clk 100MHz --> baud rate counter x 16 is 651 represented with 10 bits*/
baud_rate_clk_gen #(.BAUD_CNT(BAUD_COUNT_x16),.BAUD_BIT(BAUD_BIT_x16)) BR_GEN(.clk(clk), .rst(rst),.baud_clk(baud_clk_16));
/*mid_bit detector*/
mb_detector #(.OVER_SAMPL(OVER_SAMPL),.OVER_SAMPL_BIT(OVER_SAMPL_BIT)) MB_DET(.clk(baud_clk_16), .rst(rst),.hit_m(hit_m));

//gestione conteggio dati ricevuti
//ATTENZIONE: il contatore dei dati ricevuti su RX deve avanzare ogni MIDBIT
counter_clr #(.MAX(DATA_BW),.N_BIT(DATA_BW_BIT)) CNT_DATA(.clk(hit_m), .rst(rst),.en(en_d),.clear(clear),.count(count_data));
assign hit_d = (count_data==(DATA_BW-1)) ? 1'b1: 1'b0;

//macchina a stati di controllo della funzionalità del Sistema
fsm_r FSM_RX(.clk(baud_clk_16), .rst(rst),.RX(RX),.hit_d(hit_d),.hit_m(hit_m),.load(load),.en_d(en_d),.done(RD),.clear(clear)); 

//registro di uscita
assign en_rx = hit_m & load;
data_buf # (.BUF_SIZE(DATA_BW),.BUF_SIZE_BIT(DATA_BW_BIT)) 
          R_OUT(.clk(baud_clk_16), .rst(rst),.D(RX),.ld(en_rx),.clear(clear),.AD(count_data),.buffer(data_chunck));

endmodule

