`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2023 17:49:26
// Design Name: 
// Module Name: Tr_module
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

module Tr_Module #(parameter ClkXBit = 10415, BitClk=14, Word = 8 , BitWord = 3)(//ClkXBit = 10415, BitClk=14, Word = 8 , BitWord = 3 funziona
   input wire clk, rst,
   input wire En_module,
   input wire [Word-1:0] In_Data, 
   output wire Out_Active,
   output reg Out_Data_Serial,
   output wire Out_Done
   );
   
   reg Out_Data_Serialn;
   
  reg Reg_En;
  reg [2:0] State, Next;
  reg [BitClk-1:0] Clock_count;
  reg [BitWord-1:0] Bit_Index;
  wire [Word-1:0] Data;
  reg Done;
  reg Active_en;
  RegPar #(.N(Word)) rp (clk,rst,Reg_En,In_Data,Data);
  
  localparam IDLE = 3'b000, TX_START_BIT = 3'b001, TX_DATA_BITS = 3'b010, TX_STOP_BIT = 3'b011, CLEANUP = 3'b100;
  
  always @(posedge clk,posedge rst)
  if(rst==1'b1) Out_Data_Serial<=1'b1;
  else Out_Data_Serial<=Out_Data_Serialn;
  
  always @(posedge clk, posedge rst) begin
  if(rst)State<=IDLE;
  else State<=Next;
  end
  
  always @(State, En_module, Clock_count, Bit_Index, Next)begin
  case (State)
IDLE:
    begin
       if (En_module == 1'b1)
       begin
         Next = TX_START_BIT;
       end
       else
       Next = IDLE;
     end // case: IDLE
      // Send out Start Bit. Start bit = 0
TX_START_BIT:
        begin
          // Wait ClkXBit-1 clock cycles for start bit to finish
          if (Clock_count < ClkXBit-1)
          begin
            Next = TX_START_BIT;
          end
          else
          begin
            Next = TX_DATA_BITS;
          end
        end // case: TX_START_BIT
      // Wait ClkXBit-1 clock cycles for data bits to finish         
TX_DATA_BITS:begin
            if (Clock_count < ClkXBit-1) Next = TX_DATA_BITS;
            else if (Bit_Index < Word-1) Next = TX_DATA_BITS;
            else Next = TX_STOP_BIT;

        end // case: TX_DATA_BITS
      // Send out Stop bit.  Stop bit = 1
TX_STOP_BIT:
        begin
          // Wait ClkXBit-1 clock cycles for Stop bit to finish
          if (Clock_count < ClkXBit-1) Next = TX_STOP_BIT;
          else Next = CLEANUP;
          
        end // case: TX_STOP_BIT
      
CLEANUP: Next = IDLE; // Stay here 1 clock
             
default: Next = IDLE;
endcase
end

always @(posedge clk, posedge rst)
  begin
  if(rst==1) Clock_count<=0;
  else if(Clock_count < ClkXBit-1 && Active_en==1) Clock_count<=Clock_count+1;
  else Clock_count<=0;
  end

always @(posedge clk, posedge rst) begin
  if(rst==1) Bit_Index<=0;
  else if(State==TX_DATA_BITS && !(Clock_count < ClkXBit-1)) Bit_Index <= Bit_Index+1;
  else if (State!=TX_DATA_BITS)Bit_Index <= 0;
  end
  
always @(State, Data, Bit_Index)
  begin 
  case (State)
IDLE:
  begin
     Out_Data_Serialn = 1'b1;         
     Done = 1'b0;
     Active_en = 1'b0;
     Reg_En=1;  
  end 

TX_START_BIT:
  begin
      Out_Data_Serialn = 1'b0;
      Done = 1'b0;
      Active_en = 1'b1;
      Reg_En=0;
  end 
             
TX_DATA_BITS:
  begin
     Out_Data_Serialn = Data[Bit_Index];
     Done = 1'b0;
     Active_en = 1'b1;
     Reg_En=0; 
  end 
        
TX_STOP_BIT:
  begin
     Out_Data_Serialn = 1'b1;
     Done = 1'b0;
     Active_en = 1'b1;
     Reg_En=0;
  end 
      
CLEANUP:
  begin
     Out_Data_Serialn = 1'b1;
     Active_en = 1'b0;
     Done = 1'b1;
     Reg_En=0;
  end
      
default: 
  begin
     Out_Data_Serialn = 1'b1;
     Done = 1'b0;
     Active_en = 1'b0;
     Reg_En=0;
  end

endcase
end

  assign Out_Active = Active_en;
  assign Out_Done   = Done;
  
endmodule

