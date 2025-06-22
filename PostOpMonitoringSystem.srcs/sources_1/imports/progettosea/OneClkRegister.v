`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2021 16:57:52
// Design Name: 
// Module Name: OneClkRegister
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


module OneClkRegister(
    input wire clk,rst,on,
    output reg cs,out
    );
    reg outnxt;
    always@(posedge clk, posedge rst)
    begin
        if(rst == 1'b1) out <= 1'b0;
        else out <= outnxt;
    end
    
    always@(on,out)
    begin
        if( out == 1'b1) begin outnxt = 1'b0; cs = 1'b0; end
        else
        begin
            if(on == 1'b1) begin outnxt = 1'b1; cs = 1'b1; end
            else begin outnxt = 1'b0; cs = 1'b0; end
        end
    end
endmodule
