`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2023 14:33:54
// Design Name: 
// Module Name: FSM_Alarm
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


module FSM_Alarm(
input wire clk, rst,
input wire sw, clear0,
input wire alarm, history, change,
output reg enchange_al
    );
    
    parameter IDLE = 2'b00, POST_OP = 2'b01, ALARM = 2'b10, ALARM2 = 2'b11;
    
    reg[1:0] state, state_nxt;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) state <= IDLE;
    else state <= state_nxt;
    
    
    always@(state, sw, alarm, history, change,clear0)
    case(state)
    IDLE:    if(sw==1'b1) state_nxt = POST_OP;
             else state_nxt = IDLE;
    POST_OP: begin
             if(sw == 1'b0) state_nxt = IDLE;
             else if (alarm==1'b1 && sw == 1'b1) state_nxt = ALARM;   
             else state_nxt = POST_OP; 
             end
    ALARM:   begin
             if(sw == 1'b0) state_nxt = IDLE;
             else if (history == 1'b1 && alarm == 1'b1 && sw == 1'b1) state_nxt = ALARM2;
             else state_nxt = ALARM;
             end
    ALARM2:  begin
             if(sw==1'b0) state_nxt = IDLE;
             else if ((change == 1'b1 && sw == 1'b1)||(clear0 == 1'b1 && sw == 1'b1)) state_nxt = POST_OP;
             else state_nxt = ALARM2;
             end
    default: state_nxt = IDLE;                 
    endcase
    
    
    always@(state)
    case(state)
    IDLE:    enchange_al = 1'b0;
    POST_OP: enchange_al = 1'b0;
    ALARM:   enchange_al = 1'b0;
    ALARM2:  enchange_al = 1'b1;
    default: enchange_al = 1'b0;
    endcase
    
endmodule
