`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2023 17:09:56
// Design Name: 
// Module Name: UART_TRANSMITTER
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


module UART_TRANSMITTER
#(parameter BRate = 9600)
(input CLK, start, [7:0] data,
output reg t, rNext);

localparam
    NEXCLK = 100_000_000,
    period = NEXCLK/BRate,
    bit0 = period,
    bit1 = 2*period,
    bit2 = 3*period,
    bit3 = 4*period,
    bit4 = 5*period,
    bit5 = 6*period,
    bit6 = 7*period,
    bit7 = 8*period,
    stop = 9*period,
    ending = 15*period;

reg [$clog2(ending):0] state;

initial 
begin
    t = 0;
    rNext = 0;
    state = 0;
end


always @(posedge CLK) begin
    case (state)
        0: begin
            t <= 1;
            rNext <= 0;
            if (start) state <= 1;
        end
        1: begin
            t <= 0;
            state <= state + 1;
        end
        bit0: begin
            t <= data[0];
            state <= state + 1;
        end
        bit1: begin
            t <= data[1];
            state <= state + 1;
        end
        bit2: begin
            t <= data[2];
            state <= state + 1;
        end
        bit3: begin
            t <= data[3];
            state <= state + 1;
        end
        bit4: begin
            t <= data[4];
            state <= state + 1;
        end
        bit5: begin
            t <= data[5];
            state <= state + 1;
        end
        bit6: begin
            t <= data[6];
            state <= state + 1;
        end
        bit7: begin
            t <= data[7];
            state <= state + 1;
        end
        stop: begin
            t <= 1;
            state <= state + 1;
        end
        ending: begin
            state <= 0;
            rNext <= 1;
        end
        default: state <= state + 1;
    endcase
end
endmodule