`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2023 12:49:49
// Design Name: 
// Module Name: FSM_GC
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


module FSM_GC #(parameter DATO = 2, DUMMY =8)(
input wire clk,rst,done,clear,enh,
output reg i_TX_DV_M,
output reg [DATO-1:0] SS,
output reg [DUMMY-1:0] dummy
    );
    reg [1:0] state,snxt;
    reg [DATO-1:0] SSx;
    localparam IDLE=2'd0, SPI1=2'd1, SPI2=2'd2, Onecicle=2'd3;
    
    always@(posedge clk, posedge rst)
    if(rst==1'b1) state<=1'd0;
    else state<=snxt;
    //stati
    reg [1:0] clear_nxt;
    reg [1:0] c;
    //uscite
    reg c_final;
    
    localparam C1=2'd1, C2=2'd2,C3=2'd3;
    
    //creiamo questa macchina a stati per tenere il clear alto finche la SPI non finisce la vecchia trasmissione
    //per rimanere in ascolto per il cambio della sacca
    always@(posedge clk, posedge rst)
    if(rst==1'b1) c <= 1'b0;
    else c <= clear_nxt;
    
    always@(c, clear, done)
    case(c)
    IDLE: if(clear==1'b1)
    clear_nxt = C1;
    else clear_nxt = IDLE;
    C1: if(done) clear_nxt = C2;
    else clear_nxt = C1;
    C2: if(done) clear_nxt = C3;
    else clear_nxt = C2;
    C3: clear_nxt = IDLE;
    default: clear_nxt = IDLE;
    endcase
    
    always@(c)
    case(c)
    IDLE: c_final = 1'b0;
    C1: c_final = 1'b1;
    C2: c_final = 1'b1;
    C3: c_final = 1'b0;
    default: c_final = 1'b0;
    endcase
    
    //macchina a stati usata per farci comunicare correttamente con la spi
    //serve per coordinare l'invio in base alla situazione in cui ci troviamo
    //e per farci campionare il dato correttamente (onecicleclk)
    always@(state,c_final,done,enh)
    case(state)
    IDLE:begin if (enh==1'b1 && c_final==1'b1) snxt=SPI2;
    else if (enh==1'b1 && c_final==1'b0) snxt=SPI1;
    else snxt=IDLE;
    end
    SPI1: begin if(done)snxt=Onecicle;
    else snxt=SPI1;
    end
    SPI2: begin if(done)snxt=Onecicle;
    else snxt=SPI2;
    end
    Onecicle: snxt=IDLE;
    default: snxt=IDLE;
    endcase
    
    always@(posedge clk,posedge rst)
    if(rst==1'b1) SSx<=2'd0;
    else SSx<=SS;
    
    always@(state, SSx)
    case(state)
    IDLE:begin i_TX_DV_M=1'b0;SS=2'd0;dummy=8'b1010101; end
    SPI1:begin i_TX_DV_M=1'b1;SS=2'd1;dummy=8'b1010101; end
    SPI2:begin i_TX_DV_M=1'b1;SS=2'd2;dummy=8'b1010101; end
    Onecicle:begin i_TX_DV_M=1'b0;SS=SSx;dummy=8'b1010101; end
    endcase
    
endmodule
