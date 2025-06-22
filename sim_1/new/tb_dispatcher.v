`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2023 21:36:52
// Design Name: 
// Module Name: tb_dispatcher
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


module Top_Dispatcher_tb;
parameter SPI_MODE = 3,
SPI_CLK_DIVIDER = 8,
CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,
MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
SPI_SIZE = 2,
SS_SIZE = 2,
DATABITS = 8,
BITSPI=8,
DATA_BW=8,
DATA_BW_BIT=4,
//
BAUD_RATE=9600,
BAUD_COUNT=10416,
BAUD_BIT=14,
BAUD_COUNT_x16=651,
BAUD_BIT_x16=10,
OVER_SAMPL=16,
OVER_SAMPL_BIT=5,
//
ClkXBit = 10415,
BitClk=14,
Word = 8 ,
BitWord = 3,
//
DATAB=8,
DATAORE = 4,
DATAL = 7,
LIVELLO = 9,
STAGE = 3;

reg clk, rst, status, history, change, lev, transmit, sw;
reg [3:0] o_min, o_dmin, o_ore, o_dore;
reg[2:0] stage;
reg [2:0] data;
reg [8:0] livello;
reg [6:0] cntL;
reg [BITSPI-1:0] spi_data1;
reg [SPI_SIZE-1:0] spi_code;
reg spi_e;
wire spi_r, spi_d;
wire [BITSPI-1:0]spi_data2;
wire [6:0] o_massimo;
wire o_status, o_history, o_change, o_sw;
wire busy, ready;
wire Out_Data_Serial;
wire [27:0] dob;

Top_Dispatcher UUT (
.clk(clk),
.rst(rst),
.sw(sw),
.dob(dob),
.stage(stage),
.status(status),
.history(history),
.change(change),
.lev(lev),
.o_min(o_min),
.o_dmin(o_dmin),
.o_ore(o_ore),
.o_dore(o_dore),
.data(data),
.livello(livello),
.cntL(cntL),
.o_massimo(o_massimo),
.transmit(transmit),
.spi_e(spi_e),
.spi_data1(spi_data1),
.spi_code(spi_code),
.spi_r(spi_r),
.spi_d(spi_d),
.spi_data2(spi_data2),
.o_status(o_status),
.o_history(o_history),
.o_change(o_change),
.busy(busy),
.ready(ready),
.o_sw(o_sw),
.Out_Data_Serial(Out_Data_Serial)
);
//Conta24h c24(.clk(clk),.rst(rst),.clear(clear0),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore));

/*
always@(status, history, change, lev, transmit)
if(status == 1'b1 || history == 1'b1 || change == 1'b1 || lev == 1'b1)
begin
#200 transmit = 1'b1;
#200 transmit = 1'b0;
end
else transmit = 1'b0;

always@(lev, livello)
if(lev == 1'b1)
#200 livello = livello + 9'd5;

always@(status, history, change, lev, clear)
if(lev == 1'b1 && clear == 1'b0 && history == 1'b0 && change == 1'b0)
begin
#200 data = 3'd1;
end
else if(lev == 1'b0 && clear == 1'b1 && history == 1'b0 && change == 1'b0)
begin
#200 data = 3'd4;
end
else if(lev == 1'b0 && clear == 1'b0 && history == 1'b1 && change == 1'b0)
begin
#200 data = 3'd6;
end
else if(lev == 1'b0 && clear == 1'b0 && history == 1'b0 && change == 1'b1)
begin
#200 data = 3'd2;
end
else if(lev == 1'b1 && clear == 1'b0 && history == 1'b0 && change == 1'b0)
begin
#200 data = 3'd1;
end
else #200 data = 3'd0;
*/


always #5 clk = ~clk;
initial begin
transmit = 1'b0;
sw = 1'b0;
cntL = 1'b0;
stage = 1'b0;
data = 3'd0;
o_min =4'd0; 
o_dmin=4'd0;
o_ore =4'd0;
o_dore = 4'd0;
spi_code=2'b01;
livello = 9'd0;
spi_data1=8'b00100101;
spi_e=1'b0;
clk = 1'b0;
spi_e = 1'b0;
status = 1'b0;
history = 1'b0;
lev = 1'b0;
change = 1'b0;
rst = 1'b1;
#50 rst = 1'b0;
#50 sw = 1'b1;
#200 transmit = 1'b1;
#200 transmit = 1'b0;
#2000 lev = ~lev;
#100 spi_e = 1'b1;
#100 spi_e = 1'b0;
#1500 lev = ~lev;

/*
#2000 lev = ~lev;

#2000 lev = ~lev;
#2000 status = ~status;
#2000 status = ~status;
#2000 history = ~history;
#2000 history = ~history;
#2000 change = ~change;
#2000 change = ~change;
#2000 clear = 1'b1;
#2000 clear = 1'b0;
*/
end

endmodule
