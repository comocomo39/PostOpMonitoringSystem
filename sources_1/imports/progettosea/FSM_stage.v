`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2023 14:52:08
// Design Name: 
// Module Name: FSM_stage
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


module FSM_stage#(parameter MAXB = 9, STAGE = 3)(
input wire clk,rst,
input wire incremento,sw,
output reg [MAXB-1:0] soglia,
output reg [STAGE-1:0] stage 
    );
    reg [2:0] state,snxt;
    
    localparam IDLE=3'd0, S0=3'd1, S1=3'd2, S2=3'd3,S3=3'd4, S4=3'd5;
    
    always@(posedge clk,posedge rst)
    if(rst==1'b1) state<=IDLE;
    else state<=snxt;
    
    always@(state,incremento,sw)
    case(state)
    IDLE:if(sw) snxt=S0;
    else snxt=IDLE;
    S0:begin if(sw==1'b0) snxt=IDLE;
    else if (sw && incremento) snxt=S1;
    else snxt=S0; end
    S1:begin if(sw==1'b0) snxt=IDLE;
    else if (sw && incremento) snxt=S2;
    else snxt=S1; end
    S2:begin if(sw==1'b0) snxt=IDLE;
    else if (sw && incremento) snxt=S3;
    else snxt=S2; end
    S3:begin if(sw==1'b0) snxt=IDLE;
    else if (sw && incremento) snxt=S4;
    else snxt=S3; end
    S4:begin if(sw==1'b0) snxt=IDLE;
    else snxt=S4; end
    default: snxt = IDLE;
    endcase
    
    always@(state)
    case(state)
    IDLE:begin soglia=9'd1; stage=3'd0; end
    S0:begin soglia=9'd375; stage=3'd1; end
    S1:begin soglia=9'd250; stage=3'd2; end
    S2:begin soglia=9'd250; stage=3'd3; end
    S3:begin soglia=9'd125; stage=3'd4; end
    S4:begin soglia=9'd50; stage=3'd5; end
    default: begin soglia=9'd1; stage=3'd0; end
    endcase
    
    
    
endmodule
