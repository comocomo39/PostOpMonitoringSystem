`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 10:44:38
// Design Name: 
// Module Name: data_buf
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


module data_buf # (
    parameter BUF_SIZE=8, //lunghezza del buffer
    parameter BUF_SIZE_BIT=4 //numero di bit per rappresentare posizione nel buffer
    )(
    input wire clk, rst,
    input wire D,
    input wire ld, clear,
    input wire [BUF_SIZE_BIT-1:0] AD,
    output reg [BUF_SIZE-1:0] buffer
    );
        
    always@(posedge clk, posedge rst)
        if (rst==1'b1) buffer<={BUF_SIZE{1'bx}};
        else if (clear==1'b1) buffer<={BUF_SIZE{1'bx}};
             else if (ld==1'b1) buffer[AD]<=D;
             
endmodule
