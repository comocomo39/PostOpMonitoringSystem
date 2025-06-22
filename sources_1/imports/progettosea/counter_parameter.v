`timescale 1ns / 1ps
module counter_PARAM #(parameter CNT_MAX=1 //definisce il massimo del conteggio
                    )(
input wire clk, rst,
output wire enable,
output reg [$clog2(CNT_MAX-1):0] count 
    );
    
reg [$clog2(CNT_MAX-1):0] count_nxt;

always @ (posedge clk, posedge rst)
if (rst) count<={$clog2(CNT_MAX-1){1'b0}};
else count<=count_nxt;

always @ (count)
if (count<CNT_MAX-1) count_nxt=count+1;
else count_nxt={$clog2(CNT_MAX-1){1'b0}};

assign enable=(count==CNT_MAX-1)?1'b1:1'b0;
    
endmodule
