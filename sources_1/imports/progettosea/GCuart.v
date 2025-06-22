`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2023 12:32:30
// Design Name: 
// Module Name: GCuart
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


module GCuart(
input wire clk, rst,
input wire enlev, enchange, clear0, alarm, sw, history,enchange_al, change, //DVH,
output reg[2:0] data,
output reg DV
    );
    reg [2:0] state, state_nxt;
    
    parameter IDLE = 3'd0, LEV =3'd1, CHANGE = 3'd2, ALARM = 3'd3, STAGE = 3'd4, POSTOP = 3'd5, HISTORY = 3'd6;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) state <= IDLE;
    else state <= state_nxt;
    
    always@(state, enlev,alarm,enchange,clear0,history, sw, enchange_al, change /*DVH */)
    case(state)
    IDLE:begin
    if(sw == 1'b1)
    state_nxt = POSTOP;
    else if (history == 1'b1 && sw == 1'b0 && enchange == 1'b0 && alarm == 1'b0 && clear0 == 1'b0) /*|| DVH == 1'b1)*/
    state_nxt = HISTORY;
    else if(enlev == 1'b1 && enchange == 1'b0 && clear0 == 1'b0 && alarm == 1'b0 && sw == 1'b0 && history == 1'b0)
    state_nxt = LEV;
    else if((enchange == 1'b1 && clear0 == 1'b0 && alarm == 1'b0 && sw == 1'b0) || (change == 1'b1 && enchange_al == 1'b1 && alarm == 1'b0 && sw == 1'b0&& clear0 == 1'b0))
    state_nxt = CHANGE;
    else if(clear0 == 1'b1 && sw == 1'b0)
    state_nxt = STAGE;
    else if(clear0 == 1'b0 && alarm == 1'b1 && sw == 1'b0)
    state_nxt = ALARM;
    else state_nxt = IDLE;
    end
    LEV: state_nxt = IDLE;
    STAGE: state_nxt = IDLE;
    ALARM: state_nxt = IDLE;
    CHANGE: state_nxt = IDLE;
    POSTOP: state_nxt = IDLE;
    HISTORY: state_nxt = IDLE;
    default: state_nxt = IDLE;
    endcase
    
    reg [2:0] data_v;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) data_v <= 3'd0;
    else data_v <= data;
    //facciamo questa operazione di memorizzazione del data vecchio perchè dobbiamo campionare il dato
    //in questo modo riusciamo a fare la trasmissione completa della stringa sullo schermo
    always@(state, data_v)
    case(state)
    LEV: begin DV = 1'b1; data = 3'd1; end
    CHANGE: begin DV = 1'b1; data = 3'd2; end
    ALARM: begin DV = 1'b1; data = 3'd3; end
    STAGE: begin DV = 1'b1; data = 3'd4; end
    POSTOP: begin DV = 1'b1; data = 3'd5; end
    HISTORY: begin DV = 1'b1; data = 3'd6; end
    default: begin DV = 1'b0; data = data_v; end
    endcase
    
endmodule
