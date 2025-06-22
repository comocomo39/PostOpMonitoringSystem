`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2023 15:37:16
// Design Name: 
// Module Name: doctor
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


module doctor#(parameter Nbit = 4, nMAX = 13)( // Nbit = 26, MAX = 50_000_000   --> Parametri utilizzati nel sistema completo
input wire clk, rst, sw, change, history, status,
output wire postop,
output wire tasto_change, tasto_hist, tasto_status
    );
    
    debouncer #(.Nbit(Nbit), .MAX(nMAX)) db2(.clk(clk), .rst(rst), .TASTO(change), .TASTO_DB(tasto_change));
    debouncer #(.Nbit(Nbit), .MAX(nMAX)) db3(.clk(clk), .rst(rst), .TASTO(history), .TASTO_DB(tasto_hist));
    //debouncer #(.Nbit(Nbit), .MAX(nMAX)) db4(.clk(clk), .rst(rst), .TASTO(status), .TASTO_DB(tasto_status));
    assign tasto_status = status;
    
    assign postop = sw;
    
    
    
 
endmodule
