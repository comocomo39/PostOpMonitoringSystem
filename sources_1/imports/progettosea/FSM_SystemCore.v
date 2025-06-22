`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2023 11:10:01
// Design Name: 
// Module Name: FSM_SystemCore
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


module FSM_SystemCore(
input wire clk,rst,
input wire status, history, lev, change,
input wire alarmon, // allarme generato dal contatore che confronta le soglie
input wire sw,
input wire clear, // clear che viene attivato quando il conta24h conta le 24h
output wire fwait, enalarm, enhours, enlev, enchange, enhist, enstatus
    ); // enhours attiverà il conteggio per le 24h
      
parameter IDLE=4'b0000, POST_OP = 4'b0001, STATUS = 4'b0010, CHANGE = 4'b0011, HISTORY = 4'b0100, SOMMA = 4'b0101, ALARM = 4'B0110;    
    
reg [3:0] state, state_nxt;    
    
always @(posedge clk,posedge rst)
if(rst==1'b1)state<=IDLE;
else state<=state_nxt;    
    
    
always@(state,status, history, lev, change, alarmon,sw, clear)   
case(state)
IDLE:   if(sw == 1'b1) state_nxt = POST_OP;
        else state_nxt = IDLE;
POST_OP:begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if ((change == 1'b1 && alarmon==1'b0 && sw == 1'b1)|| (clear == 1'b1 && sw==1'b1)) state_nxt = CHANGE;
        else if (alarmon==1'b1 && clear == 1'b0 && sw == 1'b1) state_nxt = ALARM;
        else if (lev == 1'b1 && clear == 1'b0 && change == 1'b0 && alarmon == 1'b0 && sw == 1'b1) state_nxt = SOMMA;
        else if (status == 1'b1 && lev == 1'b0 && history == 1'b0 && clear == 1'b0 && sw == 1'b1 && change == 1'b0) state_nxt = STATUS;
        else if (history == 1'b1 && lev == 1'b0 && alarmon == 1'b0 && change == 1'b0 && clear == 1'b0 && sw == 1'b1) state_nxt = HISTORY;
        else state_nxt = POST_OP;
        end
SOMMA:  begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if (clear == 1'b1 && sw==1'b1) state_nxt = CHANGE;
        else if(alarmon==1'b1 && lev==1'b0 && sw==1'b1 && clear == 1'b0) state_nxt = ALARM;
        else if(lev == 1'b1 && sw==1'b1 && clear == 1'b0) state_nxt = SOMMA;
        else state_nxt = POST_OP;    
        end
STATUS: begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if (clear == 1'b1 && sw==1'b1) state_nxt = CHANGE;
        else if(status == 1'b1 && sw==1'b1 && clear == 1'b0) state_nxt = STATUS;
        else state_nxt = POST_OP;    
        end
CHANGE: begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if((change == 1'b1 && sw==1'b1)||(clear == 1'b1 && sw == 1'b1)) state_nxt = CHANGE;
        else state_nxt = POST_OP;    
        end    
HISTORY:begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if (clear == 1'b1 && sw==1'b1) state_nxt = CHANGE;
        else if(alarmon==1'b1 && sw==1'b1 && history == 1'b0 && clear == 1'b0) state_nxt = ALARM;
        else if(history == 1'b1 && sw == 1'b1 && clear == 1'b0) state_nxt = HISTORY;
        else state_nxt = POST_OP;    
        end    
ALARM:  begin
        if(sw == 1'b0) state_nxt = IDLE;
        else if (clear == 1'b1 && sw==1'b1) state_nxt = CHANGE;
        else if(history == 1'b1 && sw == 1'b1 && lev == 1'b0 && clear == 1'b0) state_nxt = HISTORY;
        else if(lev==1'b1  && sw==1'b1 && clear == 1'b0) state_nxt = SOMMA;
        else state_nxt = ALARM;    
        end
        
default: state_nxt = IDLE;        
endcase
        
        
reg [6:0] out;
assign {fwait, enalarm, enhours, enlev, enchange, enstatus, enhist} = out;        
        
always@(state)
case(state)
IDLE:    out =  7'b1000000;       
POST_OP: out =  7'b0010000;
SOMMA:   out =  7'b0011000;
STATUS:  out =  7'b0010010;      
HISTORY: out =  7'b0010001;
ALARM:   out =  7'b0110000;
CHANGE:  out =  7'b0010100;
default: out =  7'b0000000;        
endcase         
        
            
endmodule
