`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2023 16:38:23
// Design Name: 
// Module Name: UART_RECIEVER
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


module UART_RECIEVER
#(parameter BRate = 9600)

(input r, CLK,
output reg R_O, reg [7:0] received_data);

localparam
        NEXCLK = 100_000_000,
        period = NEXCLK/BRate/2,
        waiting = period,
        bit0 = 3*period,
        bit1 = 5*period,
        bit2 = 7*period,
        bit3 = 9*period,
        bit4 = 11*period,
        bit5 = 13*period,
        bit6 = 15*period,
        bit7 = 17*period,
        stop = 19*period;

reg [$clog2(stop):0] state;

initial
begin
    R_O = 0;
    state = 0;
    received_data = 0;
end


always @(posedge CLK) begin
    if (state == 0) begin
        R_O <= 0;
        state <= state + 1;
    end
    
    else if (state <= waiting)begin
        if (~r) state <= state + 1;
    end
    else case (state)
    bit0: begin
        received_data[0] <= r;
        state <= state + 1;
    end
    
    bit1: begin
        received_data[1] <= r;
        state <= state + 1;
    end
    
    bit2: begin
        received_data[2] <= r;
        state <= state + 1;
    end
    
    bit3: begin
        received_data[3] <= r;
        state <= state + 1;
    end
    
    bit4: begin
        received_data[4] <= r;
        state <= state + 1;
    end
    
    bit5: begin
        received_data[5] <= r;
        state <= state + 1;
    end
    
    bit6: begin
        received_data[6] <= r;
        state <= state + 1;
    end
    
    bit7: begin
        received_data[7] <= r;
        state <= state + 1;
    end
    
    stop: begin
        R_O <= 1;
        state <= 0;
    end
    
    default: state <= state + 1;
    endcase
end
endmodule
