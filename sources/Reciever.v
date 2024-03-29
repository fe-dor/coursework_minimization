`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 15:36:58
// Design Name: 
// Module Name: Reciever
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


module Reciever(
    input 
    r,
    clk, 
    output
    reg [0:31] data,
    reg [2:0]  capacity,
    reg [2:0]  error_reg,
    reg write
);

parameter s_capacity = 0;
parameter s_data = 1;

//UART_RECIEVER
wire R_O;
wire [7:0] received_data;

//ASCII_DECODER
wire [0:3] code; //Полученное число

integer c;
    
integer state;
initial begin
    data = 0;
    capacity = 0;
    error_reg = 0;
    state = 0;
    c = 0;
    write = 0;
end    
    
always@(posedge clk) begin
    if(R_O) begin
        case(state)
            s_capacity: begin
                if (code == 4'b1110) begin
                    error_reg <= 4'b0010; //Недопустимое количество чисел | Incorrect count of numbers
                    write <= 1; //загрузить результат в fifo    
                end
                else if (code == 4'b1000 || code < 3) begin
                    error_reg <= 4'b0001; //Недопустимое число | Incorrect number 
                    state <= state + 1;   
                end
                else if (code <= 5 && code >= 3)begin
                    capacity <= code;
                    state <= state + 1;
                end
            end
            s_data: begin
                if (code == 4'b1110) begin
                    if(c != 2**capacity) begin
                        if(error_reg == 0) begin
                            error_reg <= 4'b0010; //Недопустимое количество чисел | Incorrect count of numbers 
                        end   
                    end
                    write <= 1;
                    state <= 0;
                    c <= 0; 
                end
                else if (code > 1 && code < 9) begin
                    if(error_reg == 0) begin
                        error_reg <= 4'b0001; //Недопустимое число | Incorrect number
                    end    
                    c <= c + 1;     
                end
                else if (code == 0 || code == 1) begin
                    if(c < 32)
                        data[c] <= code[3];
                    c <= c + 1;
                end
            end
        endcase
    end
    else if (write) begin
        write <= 0;
        data <= 0;
        capacity <= 0;
        error_reg <= 0;
    end    
end

UART_RECIEVER ur (r, clk, R_O, received_data);
ASCII_DECODER ad (received_data, code);
          
endmodule
