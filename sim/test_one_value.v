`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 01:15:27
// Design Name: 
// Module Name: test_one_value
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


module test_one_value();
reg        data_ready;
reg [0:31] data;
reg [2:0]  capacity;
reg        clk; 
wire        ready_result;
wire        result_end;
wire [5:0]  res_count;
wire [9:0] result;

initial begin
    clk = 0; 
    data_ready = 1;
    data = {32'b10111111101111111111011011111111};
    capacity = 5;
end

always #10 begin
    clk <= ~clk;
end

always@(posedge clk) begin
    if(result_end) begin
        $finish;
    end
end

fsm3 m (.data_ready(data_ready), .data(data), .capacity(capacity), .clk(clk), 
.ready_result(ready_result), .result_end(result_end),
.res_count(res_count), .result(result));

endmodule
