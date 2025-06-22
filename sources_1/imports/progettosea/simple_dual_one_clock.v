`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2020 15:58:17
// Design Name: 
// Module Name: simple_dual_one_clock
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


module simple_dual_one_clock#(DATAORE = 4, STAGE = 3, LIVELLO = 9, CNTL= 7)(
input wire clk,rst,
input wire history, //
input wire clear,
input wire sw, enchange, change,
/*input wire[6:0] addrr, 
input wire DVH, */
input wire enram,
input wire [LIVELLO-1:0] livello,
input wire [STAGE-1:0] stage,
input wire [DATAORE-1:0] o_min, o_dmin, o_ore, o_dore, //
output reg [27:0] dob
); 
reg inc;
/*
reg [CNTL-1:0] cnt;
reg [CNTL-1:0]cnt_nxt;
always@(posedge clk, posedge rst)
if(rst == 1'b1) cnt <= 7'd0;
else if(clear == 1'b1) cnt <= 7'd0;
else cnt <= cnt_nxt;
*/
reg state, state_nxt;

localparam IDLE = 1'd0, LEV = 1'd1;

always@(posedge clk, posedge rst)
if(rst== 1'b1) state <= IDLE;
else state <= state_nxt;


always@(state, enram)
case(state)
IDLE: if (enram == 1'b1)
state_nxt = LEV;
else state_nxt = IDLE;
LEV: state_nxt = IDLE;
endcase

always@(state)
case(state)
IDLE: inc = 1'b0;
LEV: inc = 1'b1;
endcase

reg[27:0] dob_nxt;

always@(posedge clk, posedge rst)
if(rst==1'b1)
dob <= 1'b0;
else dob <= dob_nxt;


wire[27:0] dia;
assign dia = {livello, stage,o_min, o_dmin, o_ore, o_dore };


/*
reg [27:0] ram [99:0]; 
integer i;
always @(posedge clk) 
if(cnt==6'd0)begin
if (inc==1'b1)
begin 
ram[cnt] <= dia;
cnt_nxt <= 1'd1;
end
end
else if (cnt>6'd0)
begin
if (inc==1'b1)
begin 
ram[cnt] <= dia;
cnt_nxt <= cnt+1'd1;
end
end  //la ram viene resettata quando viene cambiata sacca, e quando si abbassa lo switch
else if (clear == 1'b1 || sw == 1'b0 || (change == 1'b1 && enchange == 1'b1))
begin
     cnt_nxt=7'd0;
    for (i = 0; i < 100; i = i + 1)
      ram[i] <= {27{1'b0}};
end 
else cnt_nxt=7'd0; 
*/
always @(inc, clear, sw, change, enchange, dob, dia) 
if (inc==1'b1)
dob_nxt = dia;
else if (clear == 1'b1 || sw == 1'b0 || (change == 1'b1 && enchange == 1'b1))
dob_nxt = 1'b0;
else dob_nxt = dob;

endmodule

