`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2023 15:35:57
// Design Name: 
// Module Name: System_Core
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


module System_Core#(parameter MAXLEV = 500, MAXB = 9, Nbit = 20, MAXD = 20000, DATABITS =8,
parameter DATAB=8, DATAORE = 4, DATAL = 7, STAGE = 3, DATO = 2, DUMMY = 8, LEDB = 16,
parameter TT = 6_666_667, BITT= 23
)(
input wire clk, rst,
input wire history, change, status , sw , // pulsanti e switch che ci arrivano da dispatcher nel topmodule
//input che arrivano dall'spi
input wire spi_data2, 
input wire spi_done,
//input uart
input wire busy,
//
input wire [DATAL-1:0] lunghezza, // segnale che indica quale valore massimo può raggiungere cntL in base al tipo di messaggio che dobbiamo stampare sullo schermo
//
output wire [2:0] data, // segnale che ci indica in base al suo valore che messaggio stampare a schermo
output wire [LEDB-1:0] led, //led 
//output spi
output wire en_spi,
output wire [DATABITS-1:0] spi_data1,
output wire [1:0] SS,
//output display
output wire cg,cf,ce,cd,cc,cb,ca,
output wire an3, an2, an1, an0,

output wire DV, //segnale dato valido che ci indica quando dobbiamo andare a stampare sullo schermo un messaggio
output wire [MAXB-1:0] livello, // quantita di liquido nella sacca, da 0 a 500
output wire transmit, // segnale per il dispatcher, in particolare UART e Tr_module che indica quando trasmettiamo e 
output wire [DATAL-1:0] cntL, // contatore che conta la lunghezza del messaggio in base a lunghezza
output wire [DATAORE-1:0]o_min, o_dmin, o_ore, o_dore, // segnali di minuti , decine di minuti, ore e decine di ore
output wire [STAGE-1:0] stage, //segnale che indica lo stage in cui ci troviamo
output wire [27:0] dob //uscita ram
    );
wire clear0; //clear0 clear che viene generato ogni 24h per il cambiamento della sacca e resettare lev

 wire lev; // settare attraverso l'utilizzo di SS e spi_data2
 wire fwait, enalarm, enhours, enlev, enchange, enhist, enstatus; //enable generati dalla fsm principale del system core
 wire alarm; //segnale che ci indica se ci troviamo in una situazione di allarme o meno
 wire clear; //clear che verrà usato per resettare il conteggio del lev, generato da soglia 
 wire enchange_al; //enable che si alza in fase di errore dopo aver premuto history, rimane in attesa di un change alto
 // enchange_al verrà utilizzato anche per abilitare i pulsanti di status e change dopo aver cliccato history se ci troviamo in allarme
 
 wire incremento; //segnale che ci indica che siamo passati ad un nuovo stage, passa attraverso spi
 wire [MAXB-1:0] soglia; // segnale di soglia che varierà in base allo stage in cui ci troviamo
 wire o_spi_data2; //segnale che arriva dalla spi e passa prima per un db, può essere tasto lev alto oppure il fatto che son passate 24h 
 wire enram; // abilita scrittura ram quando viene premuto il tasto lev
 
 // ??? ci servono per history 
 /*
 wire [DATAL-1:0] cnt;
 wire [DATAL-1:0] addrr;
 wire alarm_scritta;
 wire sw_scritta;
 wire DVH;
 wire[3:0] countf, sogliaf;
 wire DVH_scritta; */
 
debouncer #(.Nbit(Nbit), .MAX(MAXD)) db1(.clk(clk), .rst(rst), .TASTO(spi_data2), .TASTO_DB(o_spi_data2));

//modulo che usiamo per l'incremento del livello
ContaLev  #(MAXLEV,MAXB) cLev (.clk(clk),.rst(rst),.sw(sw),.enlev(enlev),.lev(lev),.enchange(enchange),.clear(clear),
.livello(livello),.enram(enram));
//modulo che ci tiene conto del conteggio dell'ora
Conta24h #(TT, BITT, DATAORE) c24 (.clk(clk),.rst(rst),.sw(sw),
.clear(clear0),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore)); 

FSM_SystemCore F1(.clk(clk),.rst(rst),.change(change),.status(status),.history(history),.lev(lev),.sw(sw),.alarmon(alarm),.clear(incremento),
.fwait(fwait), .enalarm(enalarm), .enhours(enhours), .enlev(enlev), .enchange(enchange), .enhist(enhist), .enstatus(enstatus));  

Soglia #(MAXB) S1(.clk(clk),.rst(rst),.sw(sw),.change(change),.enchange_al(enchange_al),.soglia(soglia),.livello(livello),
.alarm(alarm),.clear(clear));    

FSM_Alarm F2 (.clk(clk),.rst(rst),.change(change),.clear0(incremento),.sw(sw),.history(history),.alarm(alarm),
.enchange_al(enchange_al)); 

FSM_GC #(DATO, DUMMY) fsmgc(.clk(clk),.rst(rst),.done(spi_done),.clear(clear0),.enh(enhours),
.dummy(spi_data1),.SS(SS),.i_TX_DV_M(en_spi));

FSM_stage#(MAXB,STAGE) fsmstage(.clk(clk),.rst(rst),.sw(sw),.incremento(incremento),
.stage(stage),.soglia(soglia));

CFSM #(DATO) cfsm(.clk(clk),.rst(rst),.done(spi_done),.SS(SS),.spi_data2(o_spi_data2),
.incremento(incremento),.livello(lev));

Led_Logic#(STAGE, LEDB) L1 (.stage(stage),.alarm(alarm),
.led(led));

display7segmenti #(MAXB) d7 (.clk(clk),.rst(rst),.alarm(alarm),.livello(livello),.status(status),.enchange_al(enchange_al),.sw(sw),
.ca(ca),.cb(cb),.cc(cc),.cd(cd),.ce(ce),.cf(cf),.cg(cg),.an0(an0),.an1(an1),.an2(an2),.an3(an3));

simple_dual_one_clock #(DATAORE, STAGE,MAXB,DATAL) ram(.clk(clk),.rst(rst),/*.DVH(DVH_scritta),.addrr(addrr),*/.history(enhist),.sw(sw),.enchange(enchange_al),.change(change),.clear(enchange),.enram(enram),.livello(livello),.stage(stage),.o_min(o_min), .o_dmin(o_dmin), .o_ore(o_ore), .o_dore(o_dore),
.dob(dob));

//DW downcounter (.clk(clk),.rst(rst),.set(enhist),.DVH(DVH_scritta),.init(cnt),
//.cnt(addrr),.soglia(sogliaf));

//wire[6:0] cnnt;

//contalettere #(3'd4)  contastampe (.clk(clk),.rst(rst),.DV(enhist),.busy(busy),.cnt(cnnt),.MAX(sogliaf),.transmit(DVH));

contalettere#(DATAL) cl (.clk(clk),.rst(rst),.DV(DV),.busy(busy),.MAX(lunghezza),.cnt(cntL),.transmit(transmit));

GCuart gcuart (.clk(clk),.rst(rst),.enlev(lev),/*.DVH(DVH_scritta),*/.history(enhist),.change(change),.data(data),.DV(DV),.clear0(incremento),.enchange(enchange),.enchange_al(enchange_al),.alarm(alarm_scritta),.sw(sw_scritta));

FSM_Scritta fscritta1(.clk(clk),.rst(rst),.x(alarm),.y(alarm_scritta));

FSM_Scritta fscritta2(.clk(clk),.rst(rst),.x(sw),.y(sw_scritta));

//FSM_Scritta fscritta3(.clk(clk),.rst(rst),.s0(DVH),.s1(DVH_scritta));

