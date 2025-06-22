`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2023 14:11:23
// Design Name: 
// Module Name: top_POST
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


module top_POST #(parameter DATABITS = 8, SIZE = 1, Nbit = 200, MAX=1000) (
input wire clk, rst,
   // input wire [SIZE-1:0] clear, 
    input wire [DATABITS-1:0]RX_Data,
    input wire RX_DV,
    
    output reg TX_DV,
    output wire [DATABITS-1:0]TX_Data
    );
    
    //abbiamo scelta questo approccio di dare in uscita direttamente un bit alto a 1
    //perche gestiamo il time scanner nel system core
    //in questo modo la SPI ci manda direttamente un bit alto
    //quando son passate 24h per effettuare il clear e tenere traccia dello stage
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) TX_DV <= 1'b0;
    else TX_DV <= 1'b1;
   
    //il dato in uscita verso il Master ha il seguente formato: {0...0,x} dove x è il valore a 1 bit del clear
    assign TX_Data = {{DATABITS-SIZE{1'b0}}, 1'b1};
endmodule
