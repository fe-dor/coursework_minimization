`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 00:18:46
// Design Name: 
// Module Name: test_fsm
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


module test();
reg        data_ready;
reg [0:31] data;
reg [2:0]  capacity;
reg        clk; 
wire        ready_result;
wire        result_end;
wire [5:0]  res_count;
wire [9:0] result;
integer cnt;
reg write;
reg [5:0] c;
integer file;

parameter count_res = 10000;

initial begin
    file = $fopen("results.json","w");
    $fwrite(file, "[");
    write = 0;
    clk = 0; 
    data_ready = 1;
    data = {32'b11010001000010010000000000000000};
    capacity = 4;
    cnt = 0;
    c = 0;
end

always #10 begin
    clk <= ~clk;
end


always@(posedge clk) begin
    if(ready_result) begin
        write <= 1;
        $fwrite(file, "{");
        $fwrite(file, "\"capacity\": %d,", capacity);
        $fwrite(file, "\"func\": \"%b\",", data);
        $fwrite(file, "\"result\" : [");
        c = 0;
        if (data_ready && cnt < count_res + 1) begin
            data_ready <= 0;
        end
    end    
    if (write && !result_end) begin
        $write("\"%b\"",result);
        $fwrite(file, "\"%b\"", result);
        c = c + 1;
        if (c < res_count) begin
            $fwrite(file, ",");
        end
    end
    if (result_end) begin
        data = $urandom();
        capacity = $urandom_range(3,5);
        case(capacity)
            3 : begin
                data[8:31] <= 24'b000000000000000000000000;
            end
            4 : begin
                data[16:31] <= 16'b0000000000000000;
            end
        endcase    
        data_ready <= 1;
        cnt <= cnt + 1; 
        write <= 0;
        $write("\n");
        $fwrite(file, "]}");
        //$fwrite(file, "%d\n", capacity);
        if(cnt < count_res) begin
            $fwrite(file, ",\n");
        end
    end
    
    if (cnt > count_res) begin
        $fwrite(file, "]");
        $fclose(file);
        $finish;
    end    
end

fsm3 m (.data_ready(data_ready), .data(data), .capacity(capacity), .clk(clk), 
.ready_result(ready_result), .result_end(result_end),
.res_count(res_count), .result(result));

endmodule

