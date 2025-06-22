`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2022 11:36:54
// Design Name: 
// Module Name: CounterEn
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


module CounterEn #(parameter SIZE=4,MAX=9)(
input wire clk,reset,sw,En,clear,
output reg [SIZE-1:0]State,
output wire R //segnale che indica il passaggio da MAX a 0
    );
    reg [SIZE-1:0]Next;
    assign R = (En==1'b1 && State==MAX)?(1'b1):(1'b0);
    
    always@(posedge clk,posedge reset)
    if(reset==1'b1 || clear==1'b1)State<={SIZE{1'b0}};
    else if (sw==1'b0) State<={SIZE{1'b0}};
    else if(En==1'b1)begin
        if(State==MAX)State<={SIZE{1'b0}};
        else State<=State+1'b1;
    end 
    
endmodule
