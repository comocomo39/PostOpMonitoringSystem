`timescale 1ns / 1ps

module dp(
input wire clk,rst,refresh, 
input wire[3:0]seg0,seg1,seg2,seg3,
output wire AN0,AN1,AN2,AN3,
output wire CA,CB,CC,CD,CE,CF,CG
    );
    
    wire [1:0] cnt0;
    wire [3:0] sel0;
    cnt CNT1(.clk(clk),.rst(rst),.refresh(refresh),.count(cnt0));
    mux MUX1(.seg0(seg0),.seg1(seg1),.seg2(seg2),.seg3(seg3),.sel(cnt0),.in_seg(sel0));
    cat CAT1(.inseg(sel0),.CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG));
    andecoder AN(.cnt(cnt0),.AN0(AN0),.AN1(AN1),.AN2(AN2),.AN3(AN3));
    
endmodule
