`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2021 17:10:55
// Design Name: 
// Module Name: debouncer
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


module debouncer #(parameter Nbit = 19, MAX = 500_000)(
    input wire clk,rst,
    input wire TASTO,
    output wire TASTO_DB
    );
     wire start,done,on;
       EnableCounterDone#(.Nbit(Nbit),.MAX(MAX))CC(clk, rst,start,done);
       OneClkRegister OCR(.clk(clk),.rst(rst),.on(on),.cs(cs),.out(out));
    
       assign TASTO_DB = out;
       assign start = cs;
       assign on = TASTO & done;
   
    
endmodule