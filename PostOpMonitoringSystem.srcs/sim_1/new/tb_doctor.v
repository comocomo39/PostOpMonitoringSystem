`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2023 12:00:31
// Design Name: 
// Module Name: tb_doctor
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


module tb_doctor;

parameter Nbit=4, nMAX=13;

reg clk, rst, status, history,change, sw;
wire postop, tasto_status, tasto_hist, tasto_change;

doctor #(Nbit, nMAX) d1(.clk(clk),.rst(rst),.status(status),.history(history),.change(change),.sw(sw),
.postop(postop),.tasto_change(tasto_change),.tasto_hist(tasto_hist),.tasto_status(tasto_status));


always #5 clk=~clk;

initial
begin
clk=1'b0;
rst=1'b1;
status = 1'b0;
history = 1'b0;
change = 1'b0;
sw = 1'b0;
#30 rst = 1'b0;
#30 sw = 1'b1;
#30 history = 1'b1;
#30 history = 1'b0;
#30 status = 1'b1;
#30 status = 1'b0;
#30 sw = 1'b0;
#30 sw = 1'b1;
#30 change = 1'b1;
#30 change = 1'b0;
#70 $stop;
end
endmodule
