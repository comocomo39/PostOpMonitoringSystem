`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 10:16:55
// Design Name: 
// Module Name: fsm_r
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


module fsm_r(
input wire clk,rst, //segnali di controllo globali
input wire RX,      //RX è il segnale in ingresso dalla UART trasmittente contenente il frame di trasmissione {start,dato,stop}
input wire hit_d,   //hit_d=1 --> segnalazione della ricezione dell'ultimo bit di informazione
input wire hit_m,   //hit_m=1 --> segnalazione identificazione MIDBIT
/*load=1  --> segnalazione che i singoli bit di data chunk su RX possono essere caricati sul registro interno del canale di ricezione della UART. 
ATTENZIONE: il bit di start è quello che fa passare da IDLE a START, da START in poi i successivi 8 bit sono i bit di informazione.
Il primo bit di informazione viene campionato da START, gli atri da DATA.*/
output reg load,    
output reg clear,   //clear=1 --> ripristina i valori di contatore dati ricevuti e registro interno dati ricevuti
output reg en_d,    //en_d=1  --> abilitazione conteggio dati ricevuti
output reg done     //done=1  --> frame completamente ricevuto e dato valido sul registro di uscita
    );
 
parameter IDLE=3'b000, START=3'b001 , DATA=3'b010, STOP_1=3'b011, STOP_2=3'b100;
    
reg [2:0] state, state_nxt; 

//logica sequenziale: registro di stato    
always @(posedge clk, posedge rst)
if (rst==1'b1) state<=IDLE;
else state<=state_nxt;

//logica combinatoria: determinazione dello stato futuro
always @(state, hit_m, hit_d, RX)
case(state) 
IDLE: /*uno 0 su RX in corrispondenza del MIDBIT --> trovato il bit di start viene avviata la ricezione del frame*/ 
    begin 
        if (RX==1'b0 && hit_m==1'b1) state_nxt=START;
        else state_nxt=IDLE;
    end
START: /*in corrispondenza del MIDBIT --> inizia la ricezione e il caricamento dei bit del data chunk*/
       begin 
        if (hit_m==1'b1) state_nxt=DATA;
        else state_nxt=START;
       end
DATA: /*hit_d=1 in corrispondenza del MIDBIT --> caricamento del data chunk terminato*/
      begin
        if(hit_d==1'b1 && hit_m==1'b1) state_nxt=STOP_1; 
        else state_nxt=DATA;
      end 
STOP_1: /*in corrispondenza del MIDBIT --> campionamento del primo dei bit di stop*/
        begin
            if(hit_m==1'b1) state_nxt=STOP_2; 
            else state_nxt=STOP_1;
        end 
STOP_2: /*in corrispondenza del MIDBIT --> campionamento del secondo dei bit di stop*/
       begin 
            if (hit_m==1'b1) state_nxt=IDLE;
            else state_nxt=STOP_2;
       end
default: state_nxt=IDLE;
endcase

//logica combinatoria: determinazione delle uscite
always @(state)
case(state) 
IDLE: 
    begin
    en_d=1'b0;  //contatore dati ricevuti disabilitato 
    done=1'b0;  //dato non valido sul registro di uscita
    load=1'b0;  /*sul MIDBIT troviamo start --> non va abilitata la scrittura del registro di uscita*/  
    clear=1'b1; //contatore dati e registro di uscita resettati internamente
    end
START: 
    begin
    en_d=1'b0;  //contatore dati ricevuti disabilitato
    done=1'b0;  //dato non valido sul registro di uscita
    load=1'b1;  /*sul MIDBIT troviamo il primo bit di data chunk --> va abilitata la scrittura del registro di uscita*/
    clear=1'b0;
    end 
DATA: 
    begin 
    en_d=1'b1;  //contatore dati ricevuti abilitato
    done=1'b0;  //dato non valido sul registro di uscita
    load=1'b1;  /*sul MIDBIT troviamo il resto dei bit di data chunk --> va abilitata la scrittura del registro di uscita*/
    clear=1'b0;
    end
STOP_1: 
    begin
    en_d=1'b0;  //contatore dati ricevuti disabilitato
    done=1'b0;  //dato non valido sul registro di uscita
    load=1'b0;  /*sul MIDBIT troviamo il primo bit di stop --> non va abilitata la scrittura del registro di uscita*/
    clear=1'b0;
    end
STOP_2: 
    begin
    en_d=1'b0;  //contatore dati ricevuti disabilitato
    done=1'b1;  //dato valido sul registro di uscita
    load=1'b0;  /*sul MIDBIT troviamo il secondo bit di stop --> non va abilitata la scrittura del registro di uscita*/
    clear=1'b0;
    end
default: 
    begin
    en_d=1'b0;
    done=1'b0;
    load=1'b0;
    clear=1'b1;
    end
endcase

endmodule

