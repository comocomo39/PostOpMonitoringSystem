`timescale 1ns / 1ps
module andecoder(
input wire [1:0] cnt,
output reg AN0, AN1, AN2, AN3
    );
    always@(cnt)
    case(cnt)
    2'b00:
    begin
    AN0=1'b0;
    AN1=1'b1;
    AN2=1'b1;
    AN3=1'b1;
    end
    2'b01:
    begin
    AN0=1'b1;
    AN1=1'b0;
    AN2=1'b1;
    AN3=1'b1;
    end
    2'b10:
    begin
    AN0=1'b1;
    AN1=1'b1;
    AN2=1'b0;
    AN3=1'b1;
    end
    2'b11:
    begin
    AN0=1'b1;
    AN1=1'b1;
    AN2=1'b1;
    AN3=1'b0;
    end
    endcase
endmodule
