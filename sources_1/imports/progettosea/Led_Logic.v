`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2023 09:37:01
// Design Name: 
// Module Name: Led_Logic
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


module Led_Logic#(parameter STAGE = 3, LEDB = 16)(
input wire [STAGE-1:0] stage,
input wire alarm,
output reg [LEDB-1:0] led
    );
    
    
    always@(stage,alarm)
    if(stage == 3'd0)
    led = 16'd0;
    else if(stage == 3'd1 && alarm == 1'd1)
    led={12'd0,4'b1111};
    else if(stage == 3'd2 && alarm == 1'd1)
    led={8'd0,8'b11111111};
    else if(stage == 3'd3 && alarm == 1'd1)
    led={8'd0,8'b11111111};
    else if(stage == 3'd4 && alarm == 1'd1)
    led={4'd0,12'b111111111111};
    else if(stage == 3'd5 && alarm == 1'd1)
    led=16'b1111111111111111;
    else led = 16'd0;
endmodule
