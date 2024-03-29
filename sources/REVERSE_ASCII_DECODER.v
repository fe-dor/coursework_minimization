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


module REVERSE_ASCII_DECODER(ascii_code, code);
input [7:0] ascii_code;
output reg [4:0] code;

always @(*) begin
    case (ascii_code)
        8'h31 : code <= 5'b00001;//1
        8'h32 : code <= 5'b00010;//2
        8'h33 : code <= 5'b00011;//3
        8'h34 : code <= 5'b00100;//4
        8'h35 : code <= 5'b00101;//5    
    
        8'h41 : code <= 5'b11010;//A
        8'h42 : code <= 5'b11011;//B
        8'h43 : code <= 5'b11100;//C
        8'h44 : code <= 5'b11101;//D
        8'h45 : code <= 5'b11110;//E

        8'h61 : code <= 5'b01010;//a
        8'h62 : code <= 5'b01011;//b
        8'h63 : code <= 5'b01100;//c
        8'h64 : code <= 5'b01101;//d
        8'h65 : code <= 5'b01110;//e

        8'h2b : code <= 5'b10001;//+
        8'h0d : code <= 5'b10000;//перенос картекти
    endcase
end    

endmodule
