`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.01.2023 14:50:31
// Design Name: 
// Module Name: OMC
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


//one minute counter
module OMC #(parameter Max=1_000, Nbit=20)(
input wire clk,reset,
output wire OM_en
    );
    reg [Nbit-1:0] OneMinCount;

    always @(posedge clk or posedge reset)
    begin
        if(reset==1'b1) OneMinCount <= {Nbit{1'b0}};
        else if(OneMinCount>(Max-1'b1)) OneMinCount <= {Nbit{1'b0}};
            else OneMinCount <= OneMinCount + 1'b1;
    end 
    
    assign OM_en = (OneMinCount==(Max-1'b1))?(1'b1):(1'b0); //genera un enable ogni volta che si raggiunge max
    
endmodule


