`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 15:39:22
// Design Name: 
// Module Name: Fifo
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


module Fifo(input write, read, clk, 
            [0:31] data_in, [2:0] capacity_in, [2:0] error_reg_in,
            output reg [0:31] data_out, reg [2:0] capacity_out, reg [2:0] error_reg_out, reg empty);

reg [0:31] data_arr      [0:3];
reg [2:0]  capacity_arr  [0:3];
reg [2:0]  error_reg_arr [0:3];

reg [1:0] wp;
reg [1:0] rp;
reg [2:0] c; 

initial begin
    wp = 0;
    rp = 0;
    empty = 1;
    c = 0;
end

always@(posedge clk) begin
    if(read && !empty) begin
        data_out <= data_arr[rp];
        capacity_out <= capacity_arr[rp];
        error_reg_out <= error_reg_arr[rp];
        rp <= rp + 1;
        c <= c - 1;
        if (c - 1 == 0)
            empty <= 1;
    end
    if(write) begin
        data_arr[wp] <= data_in;
        capacity_arr[wp] <= capacity_in;
        error_reg_arr[wp] <= error_reg_in;
        wp <= wp + 1;
        if (c < 4)
            c <= c + 1;
        if (wp + 1 == rp)
            rp <= rp + 1;
        empty <= 0;
    end
end


endmodule
