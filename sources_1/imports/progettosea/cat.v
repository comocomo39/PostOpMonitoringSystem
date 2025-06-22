`timescale 1ns / 1ps

module cat(
 input wire[3:0] inseg,
 output reg CA,CB,CC,CD,CE,CF,CG
    );
    
    always@(CA,CB,CC,CD,CE,CF,CG,inseg)
    case(inseg)
    4'b0000:
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b0;CE=1'b0;CF=1'b0;CG=1'b1;
    end
    4'b0001:
    begin
    CA=1'b1;CB=1'b0;CC=1'b0;CD=1'b1;CE=1'b1;CF=1'b1;CG=1'b1;
    end
    4'b0010:
    begin
    CA=1'b0;CB=1'b0;CC=1'b1;CD=1'b0;CE=1'b0;CF=1'b1;CG=1'b0;
    end
    4'b0011:
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b0;CE=1'b1;CF=1'b1;CG=1'b0;
    end
    4'b0100:
    begin
    CA=1'b1;CB=1'b0;CC=1'b0;CD=1'b1;CE=1'b1;CF=1'b0;CG=1'b0;
    end
    4'b0101:
    begin
    CA=1'b0;CB=1'b1;CC=1'b0;CD=1'b0;CE=1'b1;CF=1'b0;CG=1'b0;
    end
    4'b0110:
    begin
    CA=1'b0;CB=1'b1;CC=1'b0;CD=1'b0;CE=1'b0;CF=1'b0;CG=1'b0;
    end
    4'b0111:
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b1;CE=1'b1;CF=1'b1;CG=1'b1;
    end
    4'b1000:
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b0;CE=1'b0;CF=1'b0;CG=1'b0;
    end
    4'b1001:
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b0;CE=1'b1;CF=1'b0;CG=1'b0;
    end
    4'b1010: //U
    begin
    CA=1'b1;CB=1'b0;CC=1'b0;CD=1'b0;CE=1'b0;CF=1'b0;CG=1'b1;
    end
    4'b1011: //A
    begin
    CA=1'b0;CB=1'b0;CC=1'b0;CD=1'b1;CE=1'b0;CF=1'b0;CG=1'b0;
    end
    4'b1100: //L
    begin
    CA=1'b1;CB=1'b1;CC=1'b1;CD=1'b0;CE=1'b0;CF=1'b0;CG=1'b1;
    end
     4'b1101: //P
    begin
    CA=1'b0;CB=1'b0;CC=1'b1;CD=1'b1;CE=1'b0;CF=1'b0;CG=1'b0;
    end
      4'b1110: //S
    begin
    CA=1'b0;CB=1'b1;CC=1'b0;CD=1'b0;CE=1'b1;CF=1'b0;CG=1'b0;
    end
    default:
    begin
    CA=1'b1;CB=1'b1;CC=1'b1;CD=1'b1;CE=1'b1;CF=1'b1;CG=1'b1;
    end
    endcase
    
    
endmodule
