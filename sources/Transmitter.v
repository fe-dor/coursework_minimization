`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 18:42:34
// Design Name: 
// Module Name: Transmitter
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


module Transmitter(
    input [9:0] result, [5:0] res_count, [2:0] capacity, [2:0] error_reg,
    input empty, send, clk,
    output t, reg ready_next
    );

// UART_TRANSMITTER
reg [7:0] data_ut;
reg start;
wire rNext;

// ASCII_CODER
reg [4:0] code;
wire [7:0] ascii_code;

reg [5:0] cnt;
reg [3:0] p;
reg [3:0] z;
reg [5:0] rc;


integer state;

parameter WAIT_SEND = 0;
parameter SEND_LETTER = 1; 
parameter WAIT_rNext = 2;
parameter SEND_ERROR = 3;
parameter SEND_NUM_ERROR = 4;
parameter SEND_CR = 5;
parameter END = 6;
parameter PART_END = 7;
parameter WAIT_NEXT_PART = 8;
parameter SEND_CR_ER = 9;
 
initial begin
    cnt = 0;
    p = 0;
    state = 0;
    start = 0;
    rc = 1;
    ready_next = 0;
end
    
always@(posedge clk)begin
    case(state)
        WAIT_SEND: begin
            ready_next <= 0;
            start <= 0;
            if(send) begin
                if (error_reg == 0) begin
                    p <= (10 - 2*(5 - capacity)) - 1;
                    state <= state + 1;
                end
                else begin
                    state <= state + 3;//SEND_ERROR
                end
            end
        end
        SEND_LETTER: begin
            if (cnt < capacity) begin
                case(cnt)
                    0: begin
                        if(result[p] == 0 && result[p-1] == 0) begin
                            code <= 5'b01010;
                            start <= 1;
                            state <= state + 1;
                        end    
                        else if(result[p-1] == 1) begin
                            code <= 5'b11010;
                            start <= 1;
                            state <= state + 1; 
                         end               
                    end 
                    1: begin
                        if(result[p-2] == 0 && result[p-3] == 0) begin
                            code <= 5'b01011;
                            start <= 1;
                            state <= state + 1;
                        end      
                        else if(result[p-3] == 1) begin
                            code <= 5'b11011;
                            start <= 1;
                            state <= state + 1;
                         end      
                    end              
                    2: begin
                        if(result[p-4] == 0 && result[p-5] == 0) begin
                            code <= 5'b01100;
                            start <= 1;
                            state <= state + 1;
                        end  
                        else if(result[p-5] == 1) begin
                            code <= 5'b11100;
                            start <= 1;
                            state <= state + 1;
                        end
                    end  
                    3: begin
                        if(result[p-6] == 0 && result[p-7] == 0) begin
                            code <= 5'b01101;
                            start <= 1;
                            state <= state + 1;
                        end
                        else if(result[p-7] == 1) begin
                            code <= 5'b11101;
                            start <= 1; 
                            state <= state + 1;
                        end
                    end 
                    4: begin
                        if(result[p-8] == 0 && result[p-9] == 0) begin
                            code <= 5'b01110;
                            start <= 1;
                            state <= state + 1;
                        end
                        else if(result[p-9] == 1) begin
                            code <= 5'b11110;
                            start <= 1; 
                            state <= state + 1;
                        end
                    end 
                endcase
                cnt <= cnt + 1;
            end    
            else begin
                cnt <= 0;
                if (rc != res_count) begin
                    code <= 5'b10001;
                    start <= 1; 
                    state <= PART_END;
                    rc <= rc + 1;
                end
                else begin
                    state <= SEND_CR;
                    rc <= 1;
                end        
            end 
        end
        WAIT_rNext: begin
            start <= 0;
            if(rNext) begin
                state <= state - 1;
            end
        end 
        SEND_ERROR: begin
            code <= 5'b01110;
            start <= 1;
            state <= state + 1; 
        end
        SEND_NUM_ERROR: begin
            if(rNext) begin
                case(error_reg)
                1: begin
                    code <= 5'b00001;
                end
                2: begin
                    code <= 5'b00010;  
                end
                endcase
                state <= SEND_CR_ER;    
            end
        end
        SEND_CR_ER: begin
            if (rNext) begin
                code <= 5'b10000;
                state <= END;
            end
        end
        SEND_CR: begin
            code <= 5'b10000;
            start <= 1;
            state <= state + 1;
        end
        END: begin
            if (rNext) begin
                start <= 0;
                state <= 0;
                ready_next <= 1;    
            end
        end
        PART_END: begin
            start <= 0;
            if (rNext) begin
                ready_next <= 1;
                state <= state + 1;
            end
        end
        WAIT_NEXT_PART: begin
            ready_next <= 0;
            if (send) begin
                state <= SEND_LETTER;    
            end
        end
    endcase
end
 

UART_TRANSMITTER ut (clk, start, ascii_code, t, rNext);
ASCII_CODER ac (code, ascii_code);
    
endmodule
