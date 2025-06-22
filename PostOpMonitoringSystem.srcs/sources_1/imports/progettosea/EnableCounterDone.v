`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2021 16:55:58
// Design Name: 
// Module Name: EnableCounterDone
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


module EnableCounterDone#(parameter Nbit = 1, MAX = 1)(
    input wire clk, rst, start,
    output reg done
    );
    reg [Nbit-1:0]count, countnxt;
    
    //current state circuit
    always@(posedge clk, posedge rst)
    begin
    if(rst == 1'b1) count <= 1'b0;
    else count <= countnxt;
    end
    //next state circuit
    always@(count,start)
    begin
        if(count == 1'b0 && start == 1'b1) countnxt = count +1'b1;
        else
            if(count == 1'b0 && start == 1'b0) countnxt = count;
            else if(count == MAX-1) countnxt = 1'b0;
                else countnxt = count +1'b1;
    end
    //output circuit
    always@(count)
    begin
        if(count == 1'b0) done = 1'b1;
        else done = 1'b0;
    end
endmodule

