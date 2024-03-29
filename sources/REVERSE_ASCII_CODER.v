`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2023 00:06:51
// Design Name: 
// Module Name: REVERSE_ASCII_DECODER
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


module REVERSE_ASCII_CODER(code, ascii_code);
input [3:0] code;
output reg [7:0] ascii_code;

always @(*) begin
    case (code)
    4'b0000: ascii_code <= 8'h30; //0 
    4'b0001: ascii_code <= 8'h31; //1
    
    4'b0011: ascii_code <= 8'h33; //3
    4'b0100: ascii_code <= 8'h34; //4
    4'b0101: ascii_code <= 8'h35; //5
    
    4'b1110: ascii_code <= 8'h3b; //;
    4'b1101: ascii_code <= 8'h0a; //LF
    4'b1100: ascii_code <= 8'h0d; //CR
    
    4'b1111: ascii_code <= 8'h46;
    default: ascii_code <= 8'h0d; 
    endcase 
end    


endmodule
