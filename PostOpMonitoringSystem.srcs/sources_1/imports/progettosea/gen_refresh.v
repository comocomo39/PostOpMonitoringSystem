`timescale 1ns / 1ps

module gen_refresh #(
                     parameter MAX=1000000
                     )(
                    input wire clk, rst,
                    output wire refresh
                    );

wire [$clog2(MAX-1):0] count;

counter_PARAM #(.CNT_MAX(MAX)) CNT_REFR(.clk(clk), .rst(rst),.enable(refresh),.count(count));
   
endmodule
