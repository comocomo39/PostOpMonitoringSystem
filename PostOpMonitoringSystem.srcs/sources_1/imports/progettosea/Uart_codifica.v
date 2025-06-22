`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2023 13:04:22
// Design Name: 
// Module Name: Uart_codifica
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


module Uart_codifica#(DATAB=8, DATAORE = 4, DATAL = 7, LIVELLO = 9, STAGE = 3)(
   input wire clk, rst,
   input wire [DATAORE-1:0] ore, dore, dminuti, minuti,
   input wire [STAGE-1:0] stage, 
   input wire [LIVELLO - 1:0] livello,
   input wire [2:0] datain,
   input wire [27:0] dob,
   input wire [DATAL-1:0] cntL,
   output reg [DATAB-1:0] dataout,
   output reg [DATAL-1:0] lunghezza
    );
    //questo modulo ci serve per codificare i dati in modo che possiamo stamparli su schermo
    
    reg [DATAB-1:0]minuti_ascii;
    reg [DATAB-1:0]ore_ascii;
    reg [DATAB-1:0]dminuti_ascii;
    reg [DATAB-1:0]dore_ascii;
    reg [DATAB-1:0]stage_ascii;
    reg [23:0] livello_ascii;
    
    
    
    
    
    reg [DATAB-1:0]ram_minuti_ascii;
    reg [DATAB-1:0]ram_ore_ascii;
    reg [DATAB-1:0]ram_dminuti_ascii;
    reg [DATAB-1:0]ram_dore_ascii;
    reg [DATAB-1:0]ram_stage_ascii;
    reg [23:0] ram_livello_ascii;

   always@(datain) 
    case(datain)
    3'd1:lunghezza=9'd31;//lev
    3'd2:lunghezza=9'd31;//change
    3'd3:lunghezza=9'd61;
    3'd4:lunghezza = 9'd43;
    3'd5:lunghezza = 9'd23;
    3'd6:lunghezza = 9'd12;
    default: lunghezza=9'd0;
    endcase
    
   always @(minuti) //minuti in input 
case(minuti)
4'd0: minuti_ascii=8'h30;
4'd1: minuti_ascii=8'h31;
4'd2: minuti_ascii=8'h32;
4'd3: minuti_ascii=8'h33;
4'd4: minuti_ascii=8'h34;
4'd5: minuti_ascii=8'h35;
4'd6: minuti_ascii=8'h36;
4'd7: minuti_ascii=8'h37;
4'd8: minuti_ascii=8'h38;
4'd9: minuti_ascii=8'h39;
default: minuti_ascii=8'h00;
endcase

//decine di minuti
always @(dminuti)
case(dminuti)
4'd0: dminuti_ascii=8'h30;
4'd1: dminuti_ascii=8'h31;
4'd2: dminuti_ascii=8'h32;
4'd3: dminuti_ascii=8'h33;
4'd4: dminuti_ascii=8'h34;
4'd5: dminuti_ascii=8'h35;
default: dminuti_ascii=8'h00;
endcase

//ore 
always @(ore)
case(ore)
4'd0: ore_ascii=8'h30;
4'd1: ore_ascii=8'h31;
4'd2: ore_ascii=8'h32;
4'd3: ore_ascii=8'h33;
4'd4: ore_ascii=8'h34;
4'd5: ore_ascii=8'h35;
4'd6: ore_ascii=8'h36;
4'd7: ore_ascii=8'h37;
4'd8: ore_ascii=8'h38;
4'd9: ore_ascii=8'h39;
default: ore_ascii=8'h00;
endcase
//decine ore
always @(dore)
case(dore)
4'd0: dore_ascii=8'h30;
4'd1: dore_ascii=8'h31;
4'd2: dore_ascii=8'h32;
default: dore_ascii=8'h00;
endcase 

always@(stage)
case(stage)
4'd0: stage_ascii=8'h30;
4'd1: stage_ascii=8'h31;
4'd2: stage_ascii=8'h32;
4'd3: stage_ascii=8'h33;
4'd4: stage_ascii=8'h34;
4'd5: stage_ascii=8'h35;
default: stage_ascii = 8'h00;
endcase

always@(livello)
case(livello)
9'd0: livello_ascii = {8'h30,8'h30,8'h30};
9'd5: livello_ascii = {8'h30,8'h30,8'h35};
9'd10: livello_ascii = {8'h30,8'h31,8'h30};
9'd15: livello_ascii = {8'h30,8'h31,8'h35};
9'd20: livello_ascii = {8'h30,8'h32,8'h30};
9'd25: livello_ascii = {8'h30,8'h32,8'h35};
9'd30: livello_ascii = {8'h30,8'h33,8'h30};
9'd35: livello_ascii = {8'h30,8'h33,8'h35};
9'd40: livello_ascii = {8'h30,8'h34,8'h30};
9'd45: livello_ascii = {8'h30,8'h34,8'h35};
9'd50: livello_ascii = {8'h30,8'h35,8'h30};
9'd55: livello_ascii = {8'h30,8'h35,8'h35};
9'd60: livello_ascii = {8'h30,8'h36,8'h30};
9'd65: livello_ascii = {8'h30,8'h36,8'h35};
9'd70: livello_ascii = {8'h30,8'h37,8'h30};
9'd75: livello_ascii = {8'h30,8'h37,8'h35};
9'd80: livello_ascii = {8'h30,8'h38,8'h30};
9'd85: livello_ascii = {8'h30,8'h38,8'h35};
9'd90: livello_ascii = {8'h30,8'h39,8'h30};
9'd95: livello_ascii = {8'h30,8'h39,8'h35};
9'd100: livello_ascii = {8'h31,8'h30,8'h30};
9'd105: livello_ascii = {8'h31,8'h30,8'h35};
9'd110: livello_ascii = {8'h31,8'h31,8'h30};
9'd115: livello_ascii = {8'h31,8'h31,8'h35};
9'd120: livello_ascii = {8'h31,8'h32,8'h30};
9'd125: livello_ascii = {8'h31,8'h32,8'h35};
9'd130: livello_ascii = {8'h31,8'h33,8'h30};
9'd135: livello_ascii = {8'h31,8'h33,8'h35};
9'd140: livello_ascii = {8'h31,8'h34,8'h30};
9'd145: livello_ascii = {8'h31,8'h34,8'h35};
9'd150: livello_ascii = {8'h31,8'h35,8'h30};
9'd155: livello_ascii = {8'h31,8'h35,8'h35};
9'd160: livello_ascii = {8'h31,8'h36,8'h30};
9'd165: livello_ascii = {8'h31,8'h36,8'h35};
9'd170: livello_ascii = {8'h31,8'h37,8'h30};
9'd175: livello_ascii = {8'h31,8'h37,8'h35};
9'd180: livello_ascii = {8'h31,8'h38,8'h30};
9'd185: livello_ascii = {8'h31,8'h38,8'h35};
9'd190: livello_ascii = {8'h31,8'h39,8'h30};
9'd195: livello_ascii = {8'h31,8'h39,8'h35};
9'd200: livello_ascii = {8'h32,8'h30,8'h30};
9'd205: livello_ascii = {8'h32,8'h30,8'h35};
9'd210: livello_ascii = {8'h32,8'h31,8'h30};
9'd215: livello_ascii = {8'h32,8'h31,8'h35};
9'd220: livello_ascii = {8'h32,8'h32,8'h30};
9'd225: livello_ascii = {8'h32,8'h32,8'h35};
9'd230: livello_ascii = {8'h32,8'h33,8'h30};
9'd235: livello_ascii = {8'h32,8'h33,8'h35};
9'd240: livello_ascii = {8'h32,8'h34,8'h30};
9'd245: livello_ascii = {8'h32,8'h34,8'h35};
9'd250: livello_ascii = {8'h32,8'h35,8'h30};
9'd255: livello_ascii = {8'h32,8'h35,8'h35};
9'd260: livello_ascii = {8'h32,8'h36,8'h30};
9'd265: livello_ascii = {8'h32,8'h36,8'h35};
9'd270: livello_ascii = {8'h32,8'h37,8'h30};
9'd275: livello_ascii = {8'h32,8'h37,8'h35};
9'd280: livello_ascii = {8'h32,8'h38,8'h30};
9'd285: livello_ascii = {8'h32,8'h38,8'h35};
9'd290: livello_ascii = {8'h32,8'h39,8'h30};
9'd295: livello_ascii = {8'h32,8'h39,8'h35};
9'd300: livello_ascii = {8'h33,8'h30,8'h30};
9'd305: livello_ascii = {8'h33,8'h30,8'h35};
9'd310: livello_ascii = {8'h33,8'h31,8'h30};
9'd315: livello_ascii = {8'h33,8'h31,8'h35};
9'd320: livello_ascii = {8'h33,8'h32,8'h30};
9'd325: livello_ascii = {8'h33,8'h32,8'h35};
9'd330: livello_ascii = {8'h33,8'h33,8'h30};
9'd335: livello_ascii = {8'h33,8'h33,8'h35};
9'd340: livello_ascii = {8'h33,8'h34,8'h30};
9'd345: livello_ascii = {8'h33,8'h34,8'h35};
9'd350: livello_ascii = {8'h33,8'h35,8'h30};
9'd355: livello_ascii = {8'h33,8'h35,8'h35};
9'd360: livello_ascii = {8'h33,8'h36,8'h30};
9'd365: livello_ascii = {8'h33,8'h36,8'h35};
9'd370: livello_ascii = {8'h33,8'h37,8'h30};
9'd375: livello_ascii = {8'h33,8'h37,8'h35};
9'd380: livello_ascii = {8'h33,8'h38,8'h30};
9'd385: livello_ascii = {8'h33,8'h38,8'h35};
9'd390: livello_ascii = {8'h33,8'h39,8'h30};
9'd395: livello_ascii = {8'h33,8'h39,8'h35};
9'd400: livello_ascii = {8'h34,8'h30,8'h30};
9'd405: livello_ascii = {8'h34,8'h30,8'h35};
9'd410: livello_ascii = {8'h34,8'h31,8'h30};
9'd415: livello_ascii = {8'h34,8'h31,8'h35};
9'd420: livello_ascii = {8'h34,8'h32,8'h30};
9'd425: livello_ascii = {8'h34,8'h32,8'h35};
9'd430: livello_ascii = {8'h34,8'h33,8'h30};
9'd435: livello_ascii = {8'h34,8'h33,8'h35};
9'd440: livello_ascii = {8'h34,8'h34,8'h30};
9'd445: livello_ascii = {8'h34,8'h34,8'h35};
9'd450: livello_ascii = {8'h34,8'h35,8'h30};
9'd455: livello_ascii = {8'h34,8'h35,8'h35};
9'd460: livello_ascii = {8'h34,8'h36,8'h30};
9'd465: livello_ascii = {8'h34,8'h36,8'h35};
9'd470: livello_ascii = {8'h34,8'h37,8'h30};
9'd475: livello_ascii = {8'h34,8'h37,8'h35};
9'd480: livello_ascii = {8'h34,8'h38,8'h30};
9'd485: livello_ascii = {8'h34,8'h38,8'h35};
9'd490: livello_ascii = {8'h34,8'h39,8'h30};
9'd495: livello_ascii = {8'h34,8'h39,8'h35};
9'd500: livello_ascii = {8'h35,8'h30,8'h30};
default:livello_ascii = {8'h0,8'h00,8'h00};
 endcase
 
 //codifica per la ram
 always@(dob)
case(dob[27:19])
9'd0: ram_livello_ascii = {8'h30,8'h30,8'h30};
9'd5: ram_livello_ascii = {8'h30,8'h30,8'h35};
9'd10: ram_livello_ascii = {8'h30,8'h31,8'h30};
9'd15: ram_livello_ascii = {8'h30,8'h31,8'h35};
9'd20: ram_livello_ascii = {8'h30,8'h32,8'h30};
9'd25: ram_livello_ascii = {8'h30,8'h32,8'h35};
9'd30: ram_livello_ascii = {8'h30,8'h33,8'h30};
9'd35: ram_livello_ascii = {8'h30,8'h33,8'h35};
9'd40: ram_livello_ascii = {8'h30,8'h34,8'h30};
9'd45: ram_livello_ascii = {8'h30,8'h34,8'h35};
9'd50: ram_livello_ascii = {8'h30,8'h35,8'h30};
9'd55: ram_livello_ascii = {8'h30,8'h35,8'h35};
9'd60: ram_livello_ascii = {8'h30,8'h36,8'h30};
9'd65: ram_livello_ascii = {8'h30,8'h36,8'h35};
9'd70: ram_livello_ascii = {8'h30,8'h37,8'h30};
9'd75: ram_livello_ascii = {8'h30,8'h37,8'h35};
9'd80: ram_livello_ascii = {8'h30,8'h38,8'h30};
9'd85: ram_livello_ascii = {8'h30,8'h38,8'h35};
9'd90: ram_livello_ascii = {8'h30,8'h39,8'h30};
9'd95: ram_livello_ascii = {8'h30,8'h39,8'h35};
9'd100: ram_livello_ascii = {8'h31,8'h30,8'h30};
9'd105: ram_livello_ascii = {8'h31,8'h30,8'h35};
9'd110: ram_livello_ascii = {8'h31,8'h31,8'h30};
9'd115: ram_livello_ascii = {8'h31,8'h31,8'h35};
9'd120: ram_livello_ascii = {8'h31,8'h32,8'h30};
9'd125: ram_livello_ascii = {8'h31,8'h32,8'h35};
9'd130: ram_livello_ascii = {8'h31,8'h33,8'h30};
9'd135: ram_livello_ascii = {8'h31,8'h33,8'h35};
9'd140: ram_livello_ascii = {8'h31,8'h34,8'h30};
9'd145: ram_livello_ascii = {8'h31,8'h34,8'h35};
9'd150: ram_livello_ascii = {8'h31,8'h35,8'h30};
9'd155: ram_livello_ascii = {8'h31,8'h35,8'h35};
9'd160: ram_livello_ascii = {8'h31,8'h36,8'h30};
9'd165: ram_livello_ascii = {8'h31,8'h36,8'h35};
9'd170: ram_livello_ascii = {8'h31,8'h37,8'h30};
9'd175: ram_livello_ascii = {8'h31,8'h37,8'h35};
9'd180: ram_livello_ascii = {8'h31,8'h38,8'h30};
9'd185: ram_livello_ascii = {8'h31,8'h38,8'h35};
9'd190: ram_livello_ascii = {8'h31,8'h39,8'h30};
9'd195: ram_livello_ascii = {8'h31,8'h39,8'h35};
9'd200: ram_livello_ascii = {8'h32,8'h30,8'h30};
9'd205: ram_livello_ascii = {8'h32,8'h30,8'h35};
9'd210: ram_livello_ascii = {8'h32,8'h31,8'h30};
9'd215: ram_livello_ascii = {8'h32,8'h31,8'h35};
9'd220: ram_livello_ascii = {8'h32,8'h32,8'h30};
9'd225: ram_livello_ascii = {8'h32,8'h32,8'h35};
9'd230: ram_livello_ascii = {8'h32,8'h33,8'h30};
9'd235: ram_livello_ascii = {8'h32,8'h33,8'h35};
9'd240: ram_livello_ascii = {8'h32,8'h34,8'h30};
9'd245: ram_livello_ascii = {8'h32,8'h34,8'h35};
9'd250: ram_livello_ascii = {8'h32,8'h35,8'h30};
9'd255: ram_livello_ascii = {8'h32,8'h35,8'h35};
9'd260: ram_livello_ascii = {8'h32,8'h36,8'h30};
9'd265: ram_livello_ascii = {8'h32,8'h36,8'h35};
9'd270: ram_livello_ascii = {8'h32,8'h37,8'h30};
9'd275: ram_livello_ascii = {8'h32,8'h37,8'h35};
9'd280: ram_livello_ascii = {8'h32,8'h38,8'h30};
9'd285: ram_livello_ascii = {8'h32,8'h38,8'h35};
9'd290: ram_livello_ascii = {8'h32,8'h39,8'h30};
9'd295: ram_livello_ascii = {8'h32,8'h39,8'h35};
9'd300: ram_livello_ascii = {8'h33,8'h30,8'h30};
9'd305: ram_livello_ascii = {8'h33,8'h30,8'h35};
9'd310: ram_livello_ascii = {8'h33,8'h31,8'h30};
9'd315: ram_livello_ascii = {8'h33,8'h31,8'h35};
9'd320: ram_livello_ascii = {8'h33,8'h32,8'h30};
9'd325: ram_livello_ascii = {8'h33,8'h32,8'h35};
9'd330: ram_livello_ascii = {8'h33,8'h33,8'h30};
9'd335: ram_livello_ascii = {8'h33,8'h33,8'h35};
9'd340: ram_livello_ascii = {8'h33,8'h34,8'h30};
9'd345: ram_livello_ascii = {8'h33,8'h34,8'h35};
9'd350: ram_livello_ascii = {8'h33,8'h35,8'h30};
9'd355: ram_livello_ascii = {8'h33,8'h35,8'h35};
9'd360: ram_livello_ascii = {8'h33,8'h36,8'h30};
9'd365: ram_livello_ascii = {8'h33,8'h36,8'h35};
9'd370: ram_livello_ascii = {8'h33,8'h37,8'h30};
9'd375: ram_livello_ascii = {8'h33,8'h37,8'h35};
9'd380: ram_livello_ascii = {8'h33,8'h38,8'h30};
9'd385: ram_livello_ascii = {8'h33,8'h38,8'h35};
9'd390: ram_livello_ascii = {8'h33,8'h39,8'h30};
9'd395: ram_livello_ascii = {8'h33,8'h39,8'h35};
9'd400: ram_livello_ascii = {8'h34,8'h30,8'h30};
9'd405: ram_livello_ascii = {8'h34,8'h30,8'h35};
9'd410: ram_livello_ascii = {8'h34,8'h31,8'h30};
9'd415: ram_livello_ascii = {8'h34,8'h31,8'h35};
9'd420: ram_livello_ascii = {8'h34,8'h32,8'h30};
9'd425: ram_livello_ascii = {8'h34,8'h32,8'h35};
9'd430: ram_livello_ascii = {8'h34,8'h33,8'h30};
9'd435: ram_livello_ascii = {8'h34,8'h33,8'h35};
9'd440: ram_livello_ascii = {8'h34,8'h34,8'h30};
9'd445: ram_livello_ascii = {8'h34,8'h34,8'h35};
9'd450: ram_livello_ascii = {8'h34,8'h35,8'h30};
9'd455: ram_livello_ascii = {8'h34,8'h35,8'h35};
9'd460: ram_livello_ascii = {8'h34,8'h36,8'h30};
9'd465: ram_livello_ascii = {8'h34,8'h36,8'h35};
9'd470: ram_livello_ascii = {8'h34,8'h37,8'h30};
9'd475: ram_livello_ascii = {8'h34,8'h37,8'h35};
9'd480: ram_livello_ascii = {8'h34,8'h38,8'h30};
9'd485: ram_livello_ascii = {8'h34,8'h38,8'h35};
9'd490: ram_livello_ascii = {8'h34,8'h39,8'h30};
9'd495: ram_livello_ascii = {8'h34,8'h39,8'h35};
9'd500: ram_livello_ascii = {8'h35,8'h30,8'h30};
default:ram_livello_ascii = {8'h0,8'h00,8'h00};
 endcase
 
    always @(dob) //minuti in input 
case(dob[15:12])
4'd0: ram_minuti_ascii=8'h30;
4'd1: ram_minuti_ascii=8'h31;
4'd2: ram_minuti_ascii=8'h32;
4'd3: ram_minuti_ascii=8'h33;
4'd4: ram_minuti_ascii=8'h34;
4'd5: ram_minuti_ascii=8'h35;
4'd6: ram_minuti_ascii=8'h36;
4'd7: ram_minuti_ascii=8'h37;
4'd8: ram_minuti_ascii=8'h38;
4'd9: ram_minuti_ascii=8'h39;
default: ram_minuti_ascii=8'h00;
endcase

//decine di minuti
always @(dob)
case(dob[11:8])
4'd0: ram_dminuti_ascii=8'h30;
4'd1: ram_dminuti_ascii=8'h31;
4'd2: ram_dminuti_ascii=8'h32;
4'd3: ram_dminuti_ascii=8'h33;
4'd4: ram_dminuti_ascii=8'h34;
4'd5: ram_dminuti_ascii=8'h35;
default: ram_dminuti_ascii=8'h00;
endcase

//ore 
always @(dob)
case(dob[7:4])
4'd0: ram_ore_ascii=8'h30;
4'd1: ram_ore_ascii=8'h31;
4'd2: ram_ore_ascii=8'h32;
4'd3: ram_ore_ascii=8'h33;
4'd4: ram_ore_ascii=8'h34;
4'd5: ram_ore_ascii=8'h35;
4'd6: ram_ore_ascii=8'h36;
4'd7: ram_ore_ascii=8'h37;
4'd8: ram_ore_ascii=8'h38;
4'd9: ram_ore_ascii=8'h39;
default: ram_ore_ascii=8'h00;
endcase
//decine ore
always @(dob)
case(dob[3:0])
4'd0: ram_dore_ascii=8'h30;
4'd1: ram_dore_ascii=8'h31;
4'd2: ram_dore_ascii=8'h32;
default: ram_dore_ascii=8'h00;
endcase 

always@(dob)
case(dob[18:16])
4'd0: ram_stage_ascii=8'h30;
4'd1: ram_stage_ascii=8'h31;
4'd2: ram_stage_ascii=8'h32;
4'd3: ram_stage_ascii=8'h33;
4'd4: ram_stage_ascii=8'h34;
4'd5: ram_stage_ascii=8'h35;
default: ram_stage_ascii = 8'h00;
endcase
 
 
 
 
 
 
 
 always @(datain, cntL,livello_ascii,stage_ascii,dore_ascii,ore_ascii,dminuti_ascii,minuti_ascii, ram_livello_ascii,ram_stage_ascii,ram_dore_ascii,ram_ore_ascii,ram_dminuti_ascii,ram_minuti_ascii)
    case(datain)
    3'b000: begin
    dataout = 8'h00;
    end
    3'd1: begin
    case(cntL) //id = 1, the value of the bag increased
    6'd0:  dataout = 8'h74; //t
    6'd1:  dataout = 8'h68; //h
    6'd2 : dataout = 8'h65; //e
    6'd3 : dataout = 8'h20;
    6'd4 : dataout = 8'h76; //v 
    6'd5 : dataout = 8'h61; // a
    6'd6 : dataout = 8'h6C; // l
    6'd7 : dataout = 8'h75; // u
    6'd8 : dataout = 8'h65; // e
    6'd9 : dataout = 8'h20; // 
    6'd10 : dataout = 8'h6F; // o
    6'd11 : dataout = 8'h66; // f
    6'd12 : dataout = 8'h20; // 
    6'd13 : dataout = 8'h74; // t
    6'd14 : dataout = 8'h68; // h
    6'd15 : dataout = 8'h65; // e
    6'd16 : dataout = 8'h20; // 
    6'd17 : dataout = 8'h62; // b
    6'd18 : dataout = 8'h61; // a
    6'd19 : dataout = 8'h67; // g
    6'd20: dataout = 8'h20; // 
    6'd21: dataout = 8'h69; // i
    6'd22: dataout = 8'h6E; // n
    6'd23: dataout = 8'h63; // c
    6'd24: dataout = 8'h72; // r
    6'd25: dataout = 8'h65; // e
    6'd26: dataout = 8'h61; // a
    6'd27: dataout = 8'h73; // s
    6'd28: dataout = 8'h65; // e
    6'd29: dataout = 8'h64; // d
    6'd30: dataout=8'h0A; //line feed
    6'd31: dataout=8'h0D; //carriage return 
    default: dataout=8'h00;
    endcase
    end
    3'd2: begin
       case(cntL) //id = 2, the doctor has changed the bag
           6'd0:  dataout = 8'h74; //t
           6'd1:  dataout = 8'h68; //h
           6'd2:  dataout = 8'h65; //e
           6'd3:  dataout = 8'h20; //
           6'd4:  dataout = 8'h64; //d
           6'd5:  dataout = 8'h6F; //o
           6'd6:  dataout = 8'h63; //c
           6'd7:  dataout = 8'h74; //t
           6'd8:  dataout = 8'h6F; //o
           6'd9:  dataout = 8'h72; //r
           6'd10:  dataout = 8'h20; //
           6'd11:  dataout = 8'h68; //h
           6'd12:  dataout = 8'h61; //a
           6'd13:  dataout = 8'h73; //s
           6'd14:  dataout = 8'h20; //
           6'd15:  dataout = 8'h63; //c
           6'd16:  dataout = 8'h68; //h
           6'd17:  dataout = 8'h61; //a
           6'd18:  dataout = 8'h6E; //n
           6'd19:  dataout = 8'h67; //g
           6'd20:  dataout = 8'h65; //e
           6'd21:  dataout = 8'h64; //d
           6'd22:  dataout = 8'h20; //
           6'd23:  dataout = 8'h74; //t
           6'd24:  dataout = 8'h68; //h
           6'd25:  dataout = 8'h65; //e
           6'd26:  dataout = 8'h20; //
           6'd27:  dataout = 8'h62; //b
           6'd28:  dataout = 8'h61; //a
           6'd29:  dataout = 8'h67; //g
           6'd30:  dataout = 8'h0A; // line feed
           6'd31:  dataout = 8'h0D; //carriage return
           default: dataout=8'h00;
       endcase
    end 
    3'd3: begin
       case(cntL) //id = 3, alarm on: the drainage level is XXX in Stage Y at hour KKKK
           6'd0:  dataout = 8'h61; //a
           6'd1:  dataout = 8'h6C; //l
           6'd2:  dataout = 8'h61; //a
           6'd3:  dataout = 8'h72; //r
           6'd4:  dataout = 8'h6D; //m
           6'd5:  dataout = 8'h20; //
           6'd6:  dataout = 8'h6F; //o
           6'd7:  dataout = 8'h6E; //n
           6'd8:  dataout = 8'h3A; //:
           6'd9:  dataout = 8'h74; //t
           6'd10:  dataout = 8'h68; //h
           6'd11:  dataout = 8'h65; //e
           6'd12:  dataout = 8'h20; //
           6'd13:  dataout = 8'h64; //d
           6'd14:  dataout = 8'h72; //r
           6'd15:  dataout = 8'h61; //a
           6'd16:  dataout = 8'h69; //i
           6'd17:  dataout = 8'h6E; //n
           6'd18:  dataout = 8'h61; //a
           6'd19:  dataout = 8'h67; //g
           6'd20:  dataout = 8'h65; //e
           6'd21:  dataout = 8'h20; //
           6'd22:  dataout = 8'h6C; //l
           6'd23:  dataout = 8'h65; //e
           6'd24:  dataout = 8'h76; //v
           6'd25:  dataout = 8'h65; //e
           6'd26:  dataout = 8'h6C; //l
           6'd27:  dataout = 8'h20; //
           6'd28:  dataout = 8'h69; //i
           6'd29:  dataout = 8'h73; //s
           6'd30:  dataout = 8'h20; //
           6'd31:  dataout = livello_ascii[23:16]; //ultima cifra liv
           6'd32:  dataout = livello_ascii[15:8]; //mid cifra
           6'd33:  dataout = livello_ascii[7:0]; //prima cifra
           6'd34:  dataout = 8'h20; //
           6'd35:  dataout = 8'h69; //i
           6'd36:  dataout = 8'h6E; //n
           6'd37:  dataout = 8'h20; //
           6'd38:  dataout = 8'h73; //s
           6'd39:  dataout = 8'h74; //t
           6'd40:  dataout = 8'h61; //a
           6'd41:  dataout = 8'h67; //g
           6'd42:  dataout = 8'h65; //e
           6'd43:  dataout = 8'h20; //
           6'd44:  dataout = stage_ascii; //stage
           6'd45:  dataout = 8'h20; //
           6'd46:  dataout = 8'h61; //a
           6'd47:  dataout = 8'h74; //t
           6'd48:  dataout = 8'h20; //
           6'd49:  dataout = 8'h68; //h
           6'd50:  dataout = 8'h6F; //o
           6'd51:  dataout = 8'h75; //u
           6'd52:  dataout = 8'h72; //r
           6'd53:  dataout = 8'h20; //
           6'd54:  dataout = dore_ascii; //d ore
           6'd55:  dataout = ore_ascii; //ore
           6'd56:  dataout = 8'h3A; //:
           6'd57:  dataout = dminuti_ascii; //dmin
           6'd58:  dataout = minuti_ascii; //min
           6'd59:  dataout = 8'h20; //
           6'd60:  dataout = 8'h0A; // line feed
           6'd61:  dataout = 8'h0D; //carriage return
           default: dataout=8'h00;
       endcase
    end 
    3'd4: // id = 4, 24 hours have passed, automatic bag change
     begin
    case(cntL) 
          6'd0:  dataout = 8'h32; //2
          6'd1:  dataout = 8'h34; //4
          6'd2:  dataout = 8'h20; //
          6'd3:  dataout = 8'h68; //h
          6'd4:  dataout = 8'h6F; //o
          6'd5:  dataout = 8'h75; //u
          6'd6:  dataout = 8'h72; //r
          6'd7:  dataout = 8'h73; //s
          6'd8:  dataout = 8'h20; //
          6'd9:  dataout = 8'h68; //h
          6'd10:  dataout = 8'h61; //a
          6'd11:  dataout = 8'h76; //v
          6'd12:  dataout = 8'h65; //e
          6'd13:  dataout = 8'h20; //
          6'd14:  dataout = 8'h70; //p
          6'd15:  dataout = 8'h61; //a
          6'd16:  dataout = 8'h73; //s
          6'd17:  dataout = 8'h73; //s
          6'd18:  dataout = 8'h65; //e
          6'd19:  dataout = 8'h64; //d
          6'd20:  dataout = 8'h2C; //,
          6'd21:  dataout = 8'h20; //
          6'd22:  dataout = 8'h61; //a
          6'd23:  dataout = 8'h75; //u
          6'd24:  dataout = 8'h74; //t
          6'd25:  dataout = 8'h6F; //o
          6'd26:  dataout = 8'h6D; //m
          6'd27:  dataout = 8'h61; //a
          6'd28:  dataout = 8'h74; //t
          6'd29:  dataout = 8'h69; //i
          6'd30:  dataout = 8'h63; //c
          6'd31:  dataout = 8'h20; //
          6'd32:  dataout = 8'h62; //b
          6'd33:  dataout = 8'h61; //a
          6'd34:  dataout = 8'h67; //g
          6'd35:  dataout = 8'h20; //
          6'd36:  dataout = 8'h63; //c
          6'd37:  dataout = 8'h68; //h
          6'd38:  dataout = 8'h61; //a
          6'd39:  dataout = 8'h6E; //n
          6'd40:  dataout = 8'h67; //g
          6'd41:  dataout = 8'h65; //e
          6'd42:  dataout = 8'h0A; // line feed
          6'd43:  dataout = 8'h0D; //carriage return
          default: dataout=8'h00;
     endcase
      end
      3'd5: // id = 5, the post-op phase is started
     begin
    case(cntL) 
          6'd0:  dataout = 8'h74; //t
          6'd1:  dataout = 8'h68; //h
          6'd2:  dataout = 8'h65; //e
          6'd3:  dataout = 8'h20; //
          6'd4:  dataout = 8'h70; //p
          6'd5:  dataout = 8'h6F; //o
          6'd6:  dataout = 8'h73; //s
          6'd7:  dataout = 8'h74; //t
          6'd8:  dataout = 8'h2D; //-
          6'd9:  dataout = 8'h6F; //o
          6'd10:  dataout = 8'h70; //p
          6'd11:  dataout = 8'h20; //
          6'd12:  dataout = 8'h69; //i
          6'd13:  dataout = 8'h73; //s
          6'd14:  dataout = 8'h20; // 
          6'd15:  dataout = 8'h73; //s
          6'd16:  dataout = 8'h74; //t
          6'd17:  dataout = 8'h61; //a
          6'd18:  dataout = 8'h72; //r
          6'd19:  dataout = 8'h74; //t
          6'd20:  dataout = 8'h65; //e
          6'd21:  dataout = 8'h64; //d
          6'd22:  dataout = 8'h0A; // line feed
          6'd23:  dataout = 8'h0D; //carriage return
          default: dataout=8'h00;
     endcase
     end
     3'd6: // id = 6, livello, stage,o_min, o_dmin, o_ore, o_dore
     begin
    case(cntL) 
          6'd0:  dataout = ram_livello_ascii[23:16]; // 
          6'd1:  dataout = ram_livello_ascii[15:8];
          6'd2:  dataout = ram_livello_ascii[7:0];
          6'd3:  dataout = 8'h20; // 
          6'd4:  dataout = ram_stage_ascii; //stage
          6'd5:  dataout = 8'h20; //
          6'd6:  dataout = ram_dore_ascii; //
          6'd7:  dataout = ram_ore_ascii; //
          6'd8:  dataout = 8'h3A; // :
          6'd9:  dataout = ram_dminuti_ascii; //
          6'd10:  dataout = ram_minuti_ascii; //
          6'd11:  dataout = 8'h0A; // line feed
          6'd12:  dataout = 8'h0D; //carriage return
          default: dataout=8'h00;
     endcase
     end
default: dataout=8'h00;
endcase

endmodule
