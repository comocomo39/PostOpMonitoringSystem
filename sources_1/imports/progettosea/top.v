`timescale 1ns / 1ps

module display7segmenti#(parameter MAXB = 9)(
input wire clk,rst,alarm,status,enchange_al,sw,
input wire[MAXB-1:0] livello,                               
output wire cg,cf,ce,cd,cc,cb,ca,
output wire an3, an2, an1, an0
    );
     reg [3:0] seg0,seg1,seg2,seg3; 
     wire refresh;
     reg en_status;

dp DISPLAY(.clk(clk), .rst(rst), .refresh(refresh),.seg0(seg0), .seg1(seg1), .seg2(seg2), .seg3(seg3),.CA(ca), .CB(cb), .CC(cc), .CD(cd), .CE(ce), .CF(cf), .CG(cg),.AN0(an0),.AN1(an1),.AN2(an2),.AN3(an3));
    //625000
gen_refresh #(.MAX(6250)) G_REFR_D(.clk(clk), .rst(rst), .refresh(refresh));

always@(status,enchange_al, alarm)
    if(alarm)
    begin
    if(status == 1'b1 && enchange_al == 1'b1)
    en_status = 1'b1;
    else en_status = 1'b0; 
    end
    else if(status) en_status= 1'b1;
    else en_status= 1'b0;
    
    
    reg [8:0] app2;
     
    always@(en_status, sw,livello)
    if(sw == 1'b0)
    begin
    seg3 = 4'd10; //W
    seg2 = 4'd11;  //A
    seg1 = 4'd1; //I
    seg0 = 4'd7; //T
    end
    else if(en_status == 1'b1 && sw == 1'b1)
    begin  //facciamo in modo di ottenere le 3 cifre sullo schermo
    seg3 = 4'd12;
    seg2 = livello / 100; 
    app2 = livello % 100;
    seg1 = app2 / 10; 
    seg0 = app2 % 10;
    end
    else begin
    seg3 = 4'd13; //P
    seg2 = 4'd0;  //O
    seg1 = 4'd14; //S
    seg0 = 4'd7;  //T
     end 
   
endmodule
