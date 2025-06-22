`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:38:23
// Design Name: 
// Module Name: SPI_slave
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


module SPI_slave #(parameter SPI_MODE = 3,                         //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                  //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2 //SPI_CLK_DIVIDER/2
                    )(
                    input wire clk, rst, //segnali globali di controllo
                    
                    /*interfaccia MISO dal consumatore*/
                    // i_TX_Byte --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [7:0]  i_TX_Byte,        
                    // i_TX_DV --> Se alto il byte ricevuto è valido
                    input wire        i_TX_DV,
                    //  o_TX_Ready --> 1: l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere al consumatore          
                    //output wire       o_TX_Ready,      
                    // interfaccia MOSI verso il consumatore
                    output wire       o_RX_DV,     // Se alto il byte ricevuto sulla linea MOSI è stato re-impacchettato in forma di byte ed è valido 
                    output wire [7:0] o_RX_Byte,   // Byte ricevuto sequenzialmente sulla linea MOSI e re-impacchettato dall'interfaccia SPI
                    /*interfaccia master-slave*/
                    //clock di ricezione generato internamente all'interfaccia SPI
                    input wire i_SPI_Clk, 
                    //linea MISO connessa al master
                    output wire o_SPI_MISO,
                    //linea MOSI connessa al master
                    input wire i_SPI_MOSI,
                    //slave select
                    input wire SS
                    );
                    
     reg [7:0] RX_Byte;
     reg [2:0] RX_cnt; 
     
     reg [7:0] TX_Byte;
     
     wire [2:0] CLK_cnt; 
     wire hit_cnt;
     
     wire Last_LSB;
     
     reg RX_valid;
     
     reg [2:0] TX_cnt; 
     reg int_SPI_MISO;
     
     //buffer tri-state for 1:N SPI implementation
     assign o_SPI_MISO = (SS == 1'b0) ? int_SPI_MISO : 1'bz;
     
     // NEW MODULE
     wire enableReception;
     wire ignoreReturnToIdle;
     modeAdapterS #(.SPI_MODE(SPI_MODE)) CLK_GEN_SL(.clk(clk),.rst(rst), .TX_cnt(TX_cnt), .RX_cnt(RX_cnt),
                    .SPI_clk_M(i_SPI_Clk),.SPI_clk_S(SPI_Clk), .enableReception(enableReception), .ignoreReturnToIdle(ignoreReturnToIdle));
    
     always@(posedge SPI_Clk, posedge rst)
     if (rst==1'b1) RX_Byte<=8'd0;
     else if(SS == 1'b0) RX_Byte<={RX_Byte[6:0],i_SPI_MOSI};
        else RX_Byte <= RX_Byte;
  
     assign o_RX_Byte=RX_Byte;
      
     
     always@(posedge SPI_Clk, posedge rst)
     if (rst==1'b1) RX_cnt<=3'd7;
     else if (enableReception == 1'b1) RX_cnt<=RX_cnt-1;
    
     assign hit_cnt=(RX_cnt==3'd0)?1'b1:1'b0;
  
     /*Contatore dei CLK cycle rispetto al clock principale al fine di identificare il LAST_LSB*/
     counter_up #(.MAX(8),.N_BIT(3)) CNT_DATA_R(.clk(clk), .rst(rst),.en(hit_cnt),.count(CLK_cnt));
     assign Last_LSB=(CLK_cnt==3'd7)? 1'b1:1'b0;
     
     always@(posedge clk, posedge rst)
     if (rst==1'b1) RX_valid<=1'b0;
     else RX_valid<=Last_LSB;
     assign o_RX_DV=RX_valid;
        
     always@(posedge clk, posedge rst)
     if (rst==1'b1) TX_Byte<=8'd0;
     else if (i_TX_DV==1'b1) TX_Byte<=i_TX_Byte;
          else if(RX_valid==1'b1) TX_Byte<=RX_Byte;
       
  
     always@(negedge SPI_Clk, posedge rst)
     if (rst==1'b1) 
        begin 
        int_SPI_MISO <=1'b0;
        TX_cnt<=3'd7; 
        end 
     else if (ignoreReturnToIdle == 1'b0) begin
          int_SPI_MISO <=TX_Byte[TX_cnt];
          TX_cnt<=TX_cnt-3'd1;
          end   
  
endmodule
