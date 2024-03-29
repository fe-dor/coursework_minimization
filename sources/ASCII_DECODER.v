`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2023 17:56:59
// Design Name: 
// Module Name: ASCII_DECODER
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


module ASCII_DECODER(ascii_code, code);
input [7:0] ascii_code;
output reg [3:0] code;
    
always @(*) begin
    case (ascii_code)
        8'h30: code <= 4'b0000;// 0
        8'h31: code <= 4'b0001;// 1
        
        8'h33: code <= 4'b0011;// 3
        8'h34: code <= 4'b0100;// 4
        8'h35: code <= 4'b0101;// 5
            
        8'h3b: code <= 4'b1110;// ;
        8'h0a: code <= 4'b1101;// LF
        8'h0d: code <= 4'b1100;// CR
        
        default: code <= 4'b1000;
    endcase
end
endmodule
