`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2023 23:55:18
// Design Name: 
// Module Name: top_module_test
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


module top_module_test();

integer state;
integer n;
reg [0:35] DATA1;
reg [0:67] DATA2;
reg [0:131] DATA3;
// [31:0] res;


//Работ с TOP_MODULE
wire t;
wire r;
reg clk;

//Работа с UART_TRANSMITTER
wire rNext;
reg start;
wire [0:7] out_symbol;
reg [0:3] out_num;

//Выходы из модуля UART_RECIEVER
wire R_RECIEVER; //Однотактовый сигнал, означающий, что пакет записан в received_data
wire [7:0] received_data;
wire [4:0] value;

initial begin
    clk = 0;
    state = 0;
    n = 0;
    DATA1 = 36'h301110101;
    DATA2 = 68'h40111111101110111;
    DATA3 = 132'h501111111011101110100000001110111;
end

always #10 begin
    clk = ~clk;
end

always@(posedge clk)
begin
    if (state == 0)
            begin 
                if (n == 0)
                    begin
                        out_num <= DATA1[0:3]; 
                        start <= 1;
                        n <= n + 1;
                    end
                else if (rNext)
                    begin
                        case(n)
                            1: begin
                                out_num <= DATA1[4:7];
                                start <= 1;
                                n <= n + 1;
                            end
                            2: begin
                                out_num <= DATA1[8:11];
                                start <= 1;
                                n <= n + 1;
                            end
                            3: begin
                                out_num <= DATA1[12:15];
                                start <= 1;
                                n <= n + 1;
                            end
                            4: begin
                                out_num <= DATA1[16:19];
                                start <= 1;
                                n <= n + 1;    
                            end
                            5: begin
                                out_num <= DATA1[20:23];
                                start <= 1;
                                n <= n + 1;    
                            end
                            6: begin
                                out_num <= DATA1[24:27];
                                start <= 1;
                                n <= n + 1;
                            end
                            7: begin
                                out_num <= DATA1[28:31];
                                start <= 1;
                                n <= n + 1;
                            end
                            8: begin
                                out_num <= DATA1[32:35];
                                start <= 1;
                                n <= n + 1;
                            end
                            9: begin                                
                                out_num <= 4'b1110;
                                start <= 1;
                                n <= n + 1;
                            end
                            10: begin
                                n <= 0; 
                                state <= 1;
                                start <= 0;
                            end
                        endcase    
                    end
                else 
                    begin
                        start <= 0;
                    end          
            end
    if (state == 1)
            begin 
                if (n == 0)
                    begin
                        out_num <= DATA2[0:3]; 
                        start <= 1;
                        n <= n + 1;
                    end
                else if (rNext)
                    begin
                        case(n)
                            1: begin
                                out_num <= DATA2[4:7];
                                start <= 1;
                                n <= n + 1;
                            end
                            2: begin
                                out_num <= DATA2[8:11];
                                start <= 1;
                                n <= n + 1;
                            end
                            3: begin
                                out_num <= DATA2[12:15];
                                start <= 1;
                                n <= n + 1;
                            end
                            4: begin
                                out_num <= DATA2[16:19];
                                start <= 1;
                                n <= n + 1;    
                            end
                            5: begin
                                out_num <= DATA2[20:23];
                                start <= 1;
                                n <= n + 1;    
                            end
                            6: begin
                                out_num <= DATA2[24:27];
                                start <= 1;
                                n <= n + 1;
                            end
                            7: begin
                                out_num <= DATA2[28:31];
                                start <= 1;
                                n <= n + 1;
                            end
                            8: begin
                                out_num <= DATA2[32:35];
                                start <= 1;
                                n <= n + 1;
                            end
                            9: begin
                                out_num <= DATA2[36:39];
                                start <= 1;
                                n <= n + 1;
                            end
                            10: begin
                                out_num <= DATA2[40:43];
                                start <= 1;
                                n <= n + 1;
                            end
                            11: begin
                                out_num <= DATA2[44:47];
                                start <= 1;
                                n <= n + 1;
                            end
                            12: begin
                                out_num <= DATA2[48:51];
                                start <= 1;
                                n <= n + 1;
                            end
                            13: begin
                                out_num <= DATA2[52:55];
                                start <= 1;
                                n <= n + 1;
                            end
                            14: begin
                                out_num <= DATA2[56:59];
                                start <= 1;
                                n <= n + 1;
                            end
                            15: begin
                                out_num <= DATA2[60:63];
                                start <= 1;
                                n <= n + 1;
                            end
                            16: begin
                                out_num <= DATA2[64:67];
                                start <= 1;
                                n <= n + 1;
                            end
                            17: begin                                
                                out_num <= 4'b1110;
                                start <= 1;
                                n <= n + 1;
                            end
                            18: begin
                                n <= 0; 
                                state <= 2;
                                start <= 0;
                            end
                        endcase    
                    end
                else 
                    begin
                        start <= 0;
                    end          
            end
    if (state == 2)
            begin 
                if (n == 0)
                    begin
                        out_num <= DATA3[0:3]; 
                        start <= 1;
                        n <= n + 1;
                    end
                else if (rNext)
                    begin
                        case(n)
                            1: begin
                                out_num <= DATA3[4:7];
                                start <= 1;
                                n <= n + 1;
                            end
                            2: begin
                                out_num <= DATA3[8:11];
                                start <= 1;
                                n <= n + 1;
                            end
                            3: begin
                                out_num <= DATA3[12:15];
                                start <= 1;
                                n <= n + 1;
                            end
                            4: begin
                                out_num <= DATA3[16:19];
                                start <= 1;
                                n <= n + 1;    
                            end
                            5: begin
                                out_num <= DATA3[20:23];
                                start <= 1;
                                n <= n + 1;    
                            end
                            6: begin
                                out_num <= DATA3[24:27];
                                start <= 1;
                                n <= n + 1;
                            end
                            7: begin
                                out_num <= DATA3[28:31];
                                start <= 1;
                                n <= n + 1;
                            end
                            8: begin
                                out_num <= DATA3[32:35];
                                start <= 1;
                                n <= n + 1;
                            end
                            9: begin
                                out_num <= DATA3[36:39];
                                start <= 1;
                                n <= n + 1;
                            end
                            10: begin
                                out_num <= DATA3[40:43];
                                start <= 1;
                                n <= n + 1;
                            end
                            11: begin
                                out_num <= DATA3[44:47];
                                start <= 1;
                                n <= n + 1;
                            end
                            12: begin
                                out_num <= DATA3[48:51];
                                start <= 1;
                                n <= n + 1;
                            end
                            13: begin
                                out_num <= DATA3[52:55];
                                start <= 1;
                                n <= n + 1;
                            end
                            14: begin
                                out_num <= DATA3[56:59];
                                start <= 1;
                                n <= n + 1;
                            end
                            15: begin
                                out_num <= DATA3[60:63];
                                start <= 1;
                                n <= n + 1;
                            end
                            16: begin
                                out_num <= DATA3[64:67];
                                start <= 1;
                                n <= n + 1;
                            end    
                            17: begin
                                out_num <= DATA3[68:71];
                                start <= 1;
                                n <= n + 1;
                            end
                            18: begin
                                out_num <= DATA3[72:75];
                                start <= 1;
                                n <= n + 1;
                            end
                            19: begin
                                out_num <= DATA3[76:79];
                                start <= 1;
                                n <= n + 1;
                            end
                            20: begin
                                out_num <= DATA3[80:83];
                                start <= 1;
                                n <= n + 1;    
                            end
                            21: begin
                                out_num <= DATA3[84:87];
                                start <= 1;
                                n <= n + 1;    
                            end
                            22: begin
                                out_num <= DATA3[88:91];
                                start <= 1;
                                n <= n + 1;
                            end
                            23: begin
                                out_num <= DATA3[92:95];
                                start <= 1;
                                n <= n + 1;
                            end
                            24: begin
                                out_num <= DATA3[96:99];
                                start <= 1;
                                n <= n + 1;
                            end
                            25: begin
                                out_num <= DATA3[100:103];
                                start <= 1;
                                n <= n + 1;
                            end
                            26: begin
                                out_num <= DATA3[104:107];
                                start <= 1;
                                n <= n + 1;
                            end
                            27: begin
                                out_num <= DATA3[108:111];
                                start <= 1;
                                n <= n + 1;
                            end
                            28: begin
                                out_num <= DATA3[112:115];
                                start <= 1;
                                n <= n + 1;
                            end
                            29: begin
                                out_num <= DATA3[116:119];
                                start <= 1;
                                n <= n + 1;
                            end
                            30: begin
                                out_num <= DATA3[120:123];
                                start <= 1;
                                n <= n + 1;
                            end
                            31: begin
                                out_num <= DATA3[124:127];
                                start <= 1;
                                n <= n + 1;
                            end
                            32: begin
                                out_num <= DATA3[128:131];
                                start <= 1;
                                n <= n + 1;    
                            end
                            33: begin                                
                                out_num <= 4'b1110;
                                start <= 1;
                                n <= n + 1;
                            end
                            34: begin
                                n <= 0; 
                                state <= 3;
                                start <= 0;
                            end
                        endcase    
                    end
                else 
                    begin
                        start <= 0;
                    end          
            end
    if (state == 3)
            begin 
                if (n == 0)
                    begin
                        out_num <= 4'b1110; 
                        start <= 1;
                        n <= n + 1;
                    end
                else if (rNext)
                    begin
                        case(n)
                            1: begin
                                out_num <= 4'b1110;
                                start <= 1;
                                n <= n + 1;
                            end
                            2: begin
                                out_num <= 4'b1101;
                                start <= 1;
                                n <= n + 1;
                            end
                            3: begin
                                out_num <= 4'b1100;
                                start <= 1;
                                n <= n + 1;
                            end
                            4: begin
                                out_num <= 4'b1111;
                                start <= 1;
                                n <= n + 1;    
                            end
                            5: begin
                                out_num <= 4'b0011;
                                start <= 1;
                                n <= n + 1;    
                            end
                            6: begin
                                out_num <= 4'b0000;
                                start <= 1;
                                n <= n + 1;
                            end
                            7: begin
                                out_num <= 4'b0001;
                                start <= 1;
                                n <= n + 1;
                            end
                            8: begin
                                out_num <= 4'b1101;
                                start <= 1;
                                n <= n + 1;
                            end
                            9: begin                                
                                out_num <= 4'b1110;
                                start <= 1;
                                n <= n + 1;
                            end
                            10: begin
                                n <= 0; 
                                state <= 0;
                                start <= 1;
                            end
                        endcase    
                    end
                else 
                    begin
                        start <= 0;
                    end          
            end                                             
end

TOP_MODULE tm (.clk(clk), .r(t), .t(r));

UART_TRANSMITTER #(9600) ut (.CLK(clk), .start(start), .data(out_symbol), .t(t), .rNext(rNext));
REVERSE_ASCII_CODER rac (.code(out_num), .ascii_code(out_symbol));

UART_RECIEVER #(9600) ur (.r(r), .CLK(clk), .R_O(R_RECIEVER), .received_data(received_data));
REVERSE_ASCII_DECODER rad (.ascii_code(received_data), .code(value));

endmodule
