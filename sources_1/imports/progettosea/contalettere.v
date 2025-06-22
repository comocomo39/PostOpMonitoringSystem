`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2023 12:26:14
// Design Name: 
// Module Name: contalettere
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


module contalettere#(parameter max = 9)(
input wire clk, rst, 
input wire DV, busy,
input wire [max-1:0] MAX,
output reg[6:0] cnt,
output reg transmit
    );
    
    localparam IDLE=3'd0, WAIT=3'd1, SEND=3'd2, WAIT2=3'd3, FINE=3'd4;
    
    reg[2:0] state, state_nxt;
    reg[6:0] cnt_nxt;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) state <= IDLE;
    else state <= state_nxt;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) cnt <= 7'd0;
    else cnt <= cnt_nxt;
    
    always@(state,DV, busy, MAX, cnt)
    case(state)
    IDLE:
    if (DV == 1'b1) state_nxt = SEND;
    else state_nxt = IDLE;
    SEND:
    if(busy == 1'b1) state_nxt = WAIT;
    else state_nxt = SEND;
    WAIT:
    if (busy == 1'b0) state_nxt = WAIT2;
    else state_nxt = WAIT;
    WAIT2:
    if(cnt == MAX) state_nxt = IDLE;
    else state_nxt = SEND;
    default : state_nxt = IDLE;
    endcase
    
    always@(state, cnt)
    case(state)
    IDLE: begin cnt_nxt = 7'd0; transmit = 1'b0;  end
    SEND: begin cnt_nxt = cnt; transmit = 1'b1;  end
    WAIT: begin cnt_nxt = cnt; transmit = 1'b0;  end
    WAIT2: begin cnt_nxt = cnt + 1'd1; transmit = 1'b0;  end
    default: begin cnt_nxt = 7'd0; transmit = 1'b0;  end
    endcase
    
endmodule
