`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:37:13
// Design Name: 
// Module Name: SPI_top
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


module SPI_top     #(parameter SPI_MODE = 3,                      //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,               //SPI_CLK_DIVIDER/2
                    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
                    parameter SPI_SIZE= 2,
                    parameter SS_SIZE = 2
                    )(
                    input wire clk, rst, //segnali globali di controllo
                    /*interfaccia MOSI verso il produttore*/
                    // i_TX_Byte_M --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [7:0]  i_TX_Byte_M,       
                     // i_TX_Byte_S --> Byte da trasmettere indietro al produttore sulla linea MISO
                    input wire [7:0]  i_TX_Byte_S0,i_TX_Byte_S1,      
                    // i_TX_DV_M --> Se alto il byte ricevuto dal produttore è valido
                    input wire        i_TX_DV_M,
                    // i_TX_DV_S --> Se alto il byte ricevuto dal consumatore è valido
                    input wire        i_TX_DV_S0,i_TX_DV_S1,
                    // SPI_Code -> Segnale che seleziona lo slave 
                    input wire [SPI_SIZE-1:0] SPI_Code, 
                    //  o_TX_Ready_M --> l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere al consumatore          
                    output wire       o_TX_Ready_M,
                    //  o_TX_Ready_S --> l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere indietro al produttore          
                    // output wire       o_TX_Ready_S0,o_TX_Ready_S1,o_TX_Ready_S2,o_TX_Ready_S3,        
                    // interfaccia MISO verso il produttore
                    output wire       o_RX_DV_M,     // Se alto il byte ricevuto sulla linea MISO è stato re-impacchettato in forma di byte ed è valido 
                    output wire [7:0] o_RX_Byte_M,   // Byte ricevuto sequenzialmente sulla linea MISO e re-impacchettato dall'interfaccia SPI
                    // interfaccia MOSI verso il consumatore
                    output wire       o_RX_DV_S0,o_RX_DV_S1,    // Se alto il byte ricevuto sulla linea MOSI è stato re-impacchettato in forma di byte ed è valido 
                    output wire [7:0] o_RX_Byte_S0,o_RX_Byte_S1    // Byte ricevuto sequenzialmente sulla linea MOSI e re-impacchettato dall'interfaccia SPI
                    );
/*interfaccia master-slave*/
//clock di trasmissione generato internamente all'interfaccia SPI
wire SPI_Clk; 
//linea MISO
wire w_SPI_MISO;
//linea MOSI
wire w_SPI_MOSI;
//slave select (SS)
wire [$clog2(SS_SIZE):0] SS;

// Istanziazione SPI master
  SPI_master #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT),.SPI_SIZE(SPI_SIZE),.SS_SIZE(SS_SIZE))
      DUT_M(.rst(rst),.clk(clk),
          .i_TX_Byte(i_TX_Byte_M),.i_TX_DV(i_TX_DV_M), .SPI_Code(SPI_Code), .o_TX_Ready(o_TX_Ready_M),
          .o_RX_DV(o_RX_DV_M),.o_RX_Byte(o_RX_Byte_M),
          .o_SPI_Clk(SPI_Clk),.i_SPI_MISO(w_SPI_MISO),.o_SPI_MOSI(w_SPI_MOSI),.SS(SS)); //MISO E MOSI still connected to each other

/* In generale in una comunicazione SPI ci sono 3 frequenze di funzionamento: quella del master, quella dello slave e quella della comunicazione master-slave. 
La terza (w_SPI_Clk) può essere qualsiasi frequenza a patto che 
a) il master possa generarla e usarla (proporzionalità rispetto a un fattore di scaling) 
b) lo slave possa accettarla (proporzionalità rispetto a un fattore di scaling)
In questa implementazione master e slave operano alla stessa velocità di riferimento, ma non sempre DEVE essere così.
*/


// Istanziazione SPI slave 0
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT))
      DUT_S0 (.rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk), .o_SPI_MISO(w_SPI_MISO),. i_SPI_MOSI(w_SPI_MOSI),
      .o_RX_DV(o_RX_DV_S0),.o_RX_Byte(o_RX_Byte_S0), .i_TX_Byte(i_TX_Byte_S0),.i_TX_DV(i_TX_DV_S0), 
      //.o_TX_Ready(o_TX_Ready_S0),
      .SS(SS[0]));
      
// Istanziazione SPI slave 1
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT))
      DUT_S1 (.rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk), .o_SPI_MISO(w_SPI_MISO),. i_SPI_MOSI(w_SPI_MOSI),
      .o_RX_DV(o_RX_DV_S1),.o_RX_Byte(o_RX_Byte_S1), .i_TX_Byte(i_TX_Byte_S1),.i_TX_DV(i_TX_DV_S1), 
      //.o_TX_Ready(o_TX_Ready_S1),
      .SS(SS[1]));
      

      
endmodule


