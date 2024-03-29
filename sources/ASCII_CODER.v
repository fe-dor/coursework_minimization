`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2023 18:00:50
// Design Name: 
// Module Name: ASCII_CODER
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


module ASCII_CODER (code, ascii_code);
input [4:0] code;
output reg [7:0] ascii_code;

always @(*) begin
    case (code)
    
        5'b00001: ascii_code <= 8'h31;//1
        5'b00010: ascii_code <= 8'h32;//2
        5'b00011: ascii_code <= 8'h33;//3
        5'b00100: ascii_code <= 8'h34;//4
        5'b00101: ascii_code <= 8'h35;//5    
    
        5'b11010: ascii_code <= 8'h41;//A
        5'b11011: ascii_code <= 8'h42;//B
        5'b11100: ascii_code <= 8'h43;//C
        5'b11101: ascii_code <= 8'h44;//D
        5'b11110: ascii_code <= 8'h45;//E

        5'b01010: ascii_code <= 8'h61;//a
        5'b01011: ascii_code <= 8'h62;//b
        5'b01100: ascii_code <= 8'h63;//c
        5'b01101: ascii_code <= 8'h64;//d
        5'b01110: ascii_code <= 8'h65;//e

        5'b10001: ascii_code <= 8'h2b;//+
        5'b10000: ascii_code <= 8'h0d;//перенос картекти
    endcase
end
endmodule
