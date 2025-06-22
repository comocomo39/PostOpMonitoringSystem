`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2023 15:31:31
// Design Name: 
// Module Name: CFSM
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


module CFSM#(parameter DATO = 2)(
input wire clk,rst,spi_data2,
input wire [DATO-1:0] SS,
input wire done,
output reg incremento, livello
    );
    
    localparam IDLE=3'd0, S1=3'd1, S2=2'd2,S1x=3'd3, S2x=3'd4;
    
    reg [2:0] state,snxt;
    
    always@(posedge clk,posedge rst)
    if(rst==1'b1) state<=IDLE;
    else state<=snxt;
    
    always@(state,SS,done)
    case(state)
    IDLE:if(SS==2'd1) snxt=S1;
    else if(SS==2'd2) snxt=S2;
    else snxt=IDLE;
    S2:if(done)snxt=S2x;
    else snxt=S2;
    S1:if(done)snxt=S1x;
    else snxt=S1;
    S1x:snxt=IDLE;
    S2x:snxt=IDLE;
    default: snxt=IDLE;
    endcase
    //passiamo il dato dalla spi al segnale appropriato
    //in base allo slave che avevamo selezionato prima dell'invio 
    always@(state, spi_data2)
    case(state)
    IDLE:begin incremento=1'd0;livello=1'd0; end  
    S1:begin incremento=1'd0;livello=spi_data2; end
    S2:begin incremento=spi_data2;livello=1'd0; end
    S1x:begin incremento=1'd0;livello=spi_data2; end
    S2x:begin incremento=spi_data2;livello=1'd0; end
    default: begin incremento=1'd0;livello=1'd0;end 
    endcase
    
endmodule
