`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:38:00
// Design Name: 
// Module Name: SPI_master
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


module SPI_master #(parameter SPI_MODE = 3,                         //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                  //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2, //SPI_CLK_DIVIDER/2
                    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2, //EDGES to be generated
                    parameter SPI_SIZE= 2,
                    parameter SS_SIZE = 2
                    )(
                    input wire clk, rst, //segnali globali di controllo
                    /*interfaccia MOSI verso il produttore*/
                    // i_TX_Byte --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [7:0]  i_TX_Byte,        
                    // i_TX_DV --> Se alto il byte ricevuto è valido
                    input wire        i_TX_DV,
                    // // SPI_Code -> codifica il segnale Slave Select (SS) da mandare al 
                    input wire [SPI_SIZE-1:0] SPI_Code, 
                    //  o_TX_Ready --> 1: .'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere al consumatore          
                    output wire       o_TX_Ready, 
                    // interfaccia MISO verso il produttore
                    output reg       o_RX_DV,     // Se alto il byte ricevuto sulla linea MISO è stato re-impacchettato in forma di byte ed è valido 
                    output reg [7:0] o_RX_Byte,   // Byte ricevuto sequenzialmente sulla linea MISO e re-impacchettato dall'interfaccia SPI
                    /*interfaccia master-slave*/
                    //clock di trasmissione generato internamente all'interfaccia SPI
                    output wire o_SPI_Clk, 
                    //linea MISO
                    input  wire i_SPI_MISO,
                    //linea MOSI
                    output reg o_SPI_MOSI, 
                    //slave select
                    output wire [$clog2(SS_SIZE):0] SS
                    );
      
  //segnali di sincronizzazione della trasmissione
  /*
  // CPHA=0 MOSI aggiornato sul fronte di discesa
  //        MISO aggiornato sul fronte di salita
  // CPHA=1 MOSI aggiornato sul fronte di salita
  //        MISO aggiornato sul fronte di discesa
  */
  wire w_CPOL;          // Clock polarity
  wire w_CPHA;          // Clock phase
  wire r_edge,f_edge;   // Rising and Falling Edge
  
  //memorizzazione interna del byte ricevuto dal produttore (disaccoppiamento produttore-interfaccia)
  wire [7:0]  prod_data;      
  
  //contatore dati spediti
  wire [3:0] count_data_S; //l'interfaccia MOSI gestisce 1 byte alla volta quindi la dimensione di questo contatore è fissa    
  wire hit_d;              //hit_d=1 tutti i dati del byte sono stati spediti 
  
  //contatore dati spediti
  wire [3:0] count_data_R; //l'interfaccia MISO gestisce 1 byte alla volta quindi la dimensione di questo contatore è fissa   
  wire en_r;               //en_r=1 abilita il conteggio dei dati ricevuti in funzione del protocollo
  
  //segnali di controllo
  wire en_d;                //generato dalla FSM indica che la fase di trasmissione è in corso
  wire en_oclk;             //generato dalla FSM per abilitare la generazione del clock di trasmissione
  
  /* last_LSB=1 indica l'ultimo colpo di clock della trasmissione del LSB lungo la linea MOSI*/
  wire last_LSB; 
  
  wire clear_d;
  
  // Signals to adapt the clk to the different modes
  wire last_edge;
  wire o_SPI_Clk_modeAdapter;  
  wire r_edge_modeAdapter;  
  wire f_edge_modeAdapter;
  
  // Definizione della Clock Polarity in funzione della modalità di funzionamento:
  assign w_CPOL = (SPI_MODE==2 || SPI_MODE==3) ? 1'b1 : 1'b0;
  assign w_CPHA = (SPI_MODE==1 || SPI_MODE==3) ? 1'b1 : 1'b0;
  
  /*Registro di Input: campionamento e memorizzazione del dato in ingresso nell'interfaccia SPI 
  per far si che il produttore non debba tenere il byte stabile fino alla fine della trasmissione*/  
  register #(.SIZE(8)) BYTE_IN_REG(.clk(clk), .rst(rst),.en(i_TX_DV),.data_in(i_TX_Byte),.data_out(prod_data));
   
  //macchina a stati che implementa il controllo della trasmissione
  fsm_SPI_master FSM_MASTER(.clk(clk), .rst(rst), .last_edge(last_edge),.tx(i_TX_DV),.en_d(en_d), .clear_d(clear_d),.en_oclk(en_oclk));
  
  /*Definizione del clock di trasmissione e identificazione dei fronti di campionamento (salita e discesa) in funzione 
  della modalità di funzionamento*/ 
  clk_gen #(.SPI_MODE(SPI_MODE),.HALF_BIT_NUM(CLKS_PER_HALF_BIT)) 
          C_GEN(.clk(clk), .rst(rst), .o_clk(o_SPI_Clk_modeAdapter),.r_edge(r_edge_modeAdapter),.f_edge(f_edge_modeAdapter), .idle_v(w_CPOL),.en_oclk(en_oclk));
   
  // Module to adapt the signals to the different modes
  modeAdapter #(.SPI_MODE(SPI_MODE),.MAX_EDGE_GEN(MAX_EDGE_GEN))
          modeAdapter(.clk(clk), .rst(rst), .in_sclk(o_SPI_Clk_modeAdapter),.in_r_edge(r_edge_modeAdapter),.in_f_edge(f_edge_modeAdapter), .clear_d(clear_d), .idle_v(w_CPOL),
          .out_sclk(o_SPI_Clk),.out_r_edge(r_edge),.out_f_edge(f_edge), .last_edge(last_edge));
  
  /*La SPI è pronta per una nuova trasmissione: o_TX_Ready=1 
  1) Di default (rst==1) la SPI deve essere disponibile ad accettare nuove transazioni,
  2) una richiesta di trasmissione (i_TX_DV==1) rende indisponibile la SPI ad accettare nuove transazioni
  3) quando viene completato il ciclo di trasmissione del LSB verso lo slave la SPI deve tornare disponibile*/
  Ready_Gen #(.HALF_BIT_NUM(CLKS_PER_HALF_BIT)) 
            R_GEN(.clk(clk), .rst(rst),.req(i_TX_DV),.set(hit_d),.ready(o_TX_Ready),.stop(o_TX_Done)); 
         
       
  /*Gestione dell'interfaccia MOSI verso lo slave
  CPHA=0 --> MOSI aggiornato sul fronte di discesa
  CPHA=1 --> MOSI aggiornato sul fronte di salita*/
  always@(posedge clk, posedge rst)
  if (rst==1'b1) o_SPI_MOSI<=1'b0;
  else if ((w_CPHA==1'b0 && f_edge==1'b1) || (w_CPHA==1'b1 && r_edge==1'b1))
       o_SPI_MOSI<=prod_data[count_data_S];     
  
  //Contatore dati trasmessi lungo la linea MOSI: da 7 a 0 visto che la trasmissione avviene da MSB a LSB
  
  // I explicitely synchronized the counterS with the corresponding edge, instead of plugging the sCLK
  wire en_s = (w_CPHA==1'b0 && f_edge==1'b1) || (w_CPHA==1'b1 && r_edge==1'b1) ? 1'b1:1'b0;
  //hit_d=1 indica che sulla porta MOSI verso lo slave stiamo trasmettendo LSB
  counter_SPI #(.MAX(8),.N_BIT(4)) CNT_DATA_S(.clk(clk), .rst(rst),.en(en_s), .clear(clear_d), .count(count_data_S), .hit(hit_d));
  //counter #(.MAX(8),.N_BIT(4)) CNT_DATA_S(.clk(o_SPI_Clk), .rst(rst),.en(en_d), .clear(clear_d), .count(count_data_S));
  //assign hit_d =(count_data_S==4'd0) ? 1'b1 : 1'b0; 
  
  //Decode per decodificare l'SPI_Code e selezionare lo slave
  decoder_SS#(.CODE_SIZE(SPI_SIZE), .SS_SIZE(SS_SIZE)) DEC(
 .SPI_Code(SPI_Code), 
 .SS(SS));
  
  /*Gestione dell'interfaccia MISO dallo slave
  CPHA=0 --> MISO aggiornato sul fronte di salita
  CPHA=1 --> MISO aggiornato sul fronte di discesa*/ 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) o_RX_Byte<=8'b0;
  else if ((w_CPHA==1'b0 && r_edge==1'b1) || (w_CPHA==1'b1 && f_edge==1'b1)) 
       o_RX_Byte<={o_RX_Byte[6:0],i_SPI_MISO};
       
  /*Contatore dati ricevuti lungo la linea MISO: da 7 a 0 per riutilizzare lo stesso contatore, ma il primo bit ricevuto
  viene scritto nella posizione meno significativa*/
  wire hit_R;
  assign en_r=((w_CPHA==1'b0 && r_edge==1'b1) || (w_CPHA==1'b1 && f_edge==1'b1))? 1'b1:1'b0;
  counter_SPI #(.MAX(8),.N_BIT(4)) CNT_DATA_R(.clk(clk), .rst(rst),.en(en_r), .clear(1'b0), .count(count_data_R), .hit(hit_R));
  
  /*Registro di Output: se alto segnala al produttore che il byte ricevuto sulla linea MISO è stato re-impacchettato ed 
  è valido*/
  always@(posedge clk, posedge rst)
  if (rst=='b1) o_RX_DV<=1'b0;
  else if  ( ((w_CPHA==1'b0 && r_edge==1'b1) || (w_CPHA==1'b1 && f_edge==1'b1)) && hit_R==1'b1 ) 
            o_RX_DV<=1'b1;
            else o_RX_DV<=1'b0;
   
endmodule