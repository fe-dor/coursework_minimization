`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 15:46:09
// Design Name: 
// Module Name: TOP_MODULE
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


module TOP_MODULE(
    input clk, r,
    output t
);

//Fifo
reg read;
wire write;
wire [0:31] data_in, data_out; 
wire [2:0] capacity_in, capacity_out;
wire [2:0] error_reg_in, error_reg_out; 
wire empty;

//fsm
reg data_ready;
wire ready_result, result_end;
wire [5:0]  res_count;
wire [9:0]  result;

//Transmitter
reg send;
wire ready_next;

parameter CHECK_FIFO = 0;
parameter READ_FIFO = 1;
parameter WAIT_FOR_RESULT = 2;
parameter SAVE_RESULT = 3;
parameter SEND_RESULT = 4;
parameter SEND_RESULT_1 = 5;
parameter SEND_ERROR_RESULT = 6;
parameter END_OF_ERROR = 7;
parameter READ_0 = 8;

integer state;
reg [9:0] result_reg [0:15];
reg [5:0] res_count_reg;
reg [5:0] i;
reg [5:0] j;
reg [9:0] result_tr;

initial begin
    state = 0;
    read = 0; //Fifo
    data_ready = 0; // fsm
    send = 0; // Transmitter
    i = 0; j = 0;
    result_tr = 0;
    res_count_reg = 0;
end
    
always@(posedge clk)begin
    case(state) 
        CHECK_FIFO: begin
            if(!empty) begin
                read <= 1;
                state <= READ_0;        
            end
        end
        READ_0: begin
            read <= 0;
            state <= READ_FIFO; 
        end
        READ_FIFO: begin
            if (error_reg_out != 0) begin
                state <= SEND_ERROR_RESULT;
            end
            else begin
                data_ready <= 1;
                state <= state + 1;
            end
        end
        WAIT_FOR_RESULT: begin
            data_ready <= 0;
            if (ready_result) begin
                res_count_reg <= res_count;
                state <= state + 1;            
            end
        end
        SAVE_RESULT: begin
            if (i < res_count_reg) begin
                result_reg[i] <= result;
                i <= i + 1;
            end
            else begin
                state <= state + 1;
                i <= 0;
            end
        end
        SEND_RESULT: begin
            if (j < res_count_reg) begin
                result_tr <= result_reg[j];
                send <= 1;
                state <= state + 1;
            end
            else begin
                state <= 0;
                j <= 0;
            end 
        end
        SEND_RESULT_1: begin
            send <= 0;
            if (ready_next) begin
                j <= j + 1;
                state <= state - 1;
            end     
        end
        SEND_ERROR_RESULT: begin
            send <= 1;
            state <= state + 1;   
        end
        END_OF_ERROR: begin
            send <= 0;
            if (ready_next) begin
                state <= CHECK_FIFO;
            end     
        end
    endcase
end       
    
Fifo fifo (write, read, clk, data_in, capacity_in, error_reg_in, data_out, capacity_out, error_reg_out, empty);
fsm3 fsm3 (data_ready, data_out, capacity_out, clk, ready_result, result_end, res_count, result);
Transmitter tr (result_tr, res_count_reg, capacity_out, error_reg_out, empty, send, clk, t, ready_next);
Reciever rc (r, clk, data_in, capacity_in, error_reg_in, write);    
endmodule
