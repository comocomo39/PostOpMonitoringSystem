`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.01.2023 20:44:24
// Design Name: 
// Module Name: decoder_SS
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


module decoder_SS#(parameter CODE_SIZE= 2, parameter SS_SIZE = 2)(
input wire [CODE_SIZE-1 : 0] SPI_Code, // Codice SPI
output reg [$clog2(SS_SIZE): 0] SS // Codifica da SPI_Code a Slave Select (SS)
    );

always@(SPI_Code)
case(SPI_Code)
2'b00: SS = 2'b11; //comunicazione terminata
2'b01: SS = 2'b10; //lev
2'b10: SS = 2'b01; //stage
default:
SS = 2'b11;
endcase
   
endmodule
