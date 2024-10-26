`timescale 1ns / 1ps

module RAM_tb;
reg clk;
reg rst;
reg read;
reg write;
reg [7:0] address;
reg [7:0] data;
wire [7:0] out;
RAM uut (
    .clk(clk),
    .rst(rst),
    .read(read),
    .write(write),
    .address(address),
    .data(data),
    .out(out)
);
always begin
    #1 clk = ~clk;
end
initial begin
    $dumpfile("ram_tb.vcd");
    $dumpvars(0, RAM_tb);
    clk   = 0;
    rst   = 0;
    read  = 0;
    write = 0;
    address = 8'b00000000;
    data    = 8'b00000010;
    #5; rst = 1; #5; rst = 0;
    #5; write = 1;
    address = 8'b00000001;
    data    = 8'b10101010;
    #10; write = 0;
    #10; read = 1;
    address = 8'b00000001;
    #10; read = 0;
    #10; write = 1;
    address = 8'b00001010;
    data = 8'b11001100;
    #10; write = 0;
    #10; read = 1;
    address = 8'b00011111;
    #10; read = 0;
    #20;
    $finish;
end
endmodule
