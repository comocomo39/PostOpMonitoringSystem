`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2023 11:22:54
// Design Name: 
// Module Name: top_LEV
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


module top_LEV #(parameter DATABITS = 8, SIZE = 1, Nbit = 200, MAX=1000) (
input wire clk, rst,
    input wire [SIZE-1:0] lev, //tasto lev da rendere a 8bit
    input wire [DATABITS-1:0]RX_Data,
    input wire RX_DV,
    
    output reg TX_DV,
    output wire [DATABITS-1:0]TX_Data
    );
    wire tasto_lev;
    
    always@(posedge clk, posedge rst)
    if(rst == 1'b1) TX_DV <= 1'b0;
    else TX_DV <= 1'b1;
    
    //debouncer #(.Nbit(Nbit), .MAX(MAX)) db1(.clk(clk), .rst(rst), .TASTO(lev), .TASTO_DB(tasto_lev));
   
    //il dato in uscita verso il Master ha il seguente formato: {0...0,x} dove x è il valore a 1 bit del bottone
    assign TX_Data = {{DATABITS-SIZE{1'b0}}, lev};
endmodule
