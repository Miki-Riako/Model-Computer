`timescale 1ns / 1ps

module ROM_tb;
reg edit;
reg [7:0] unit;
reg [7:0] code;
reg send;
reg clk;
reg rst;
reg [7:0] address;
wire [31:0] opcode;
ROM uut (
    .edit(edit),
    .unit(unit),
    .code(code),
    .send(send),
    .clk(clk),
    .rst(rst),
    .address(address),
    .opcode(opcode)
);
initial begin
    clk = 0;
    forever #1 clk = ~clk;
end
initial begin
    $dumpfile("rom_tb.vcd");
    $dumpvars(0, ROM_tb);
    edit = 0;
    unit = 0;
    code = 0;
    send = 0;
    clk  = 0;
    address = 0;
    rst = 0;
    #5; rst = 1; #5; rst = 0;
    // 测试读取操作
    #1;  address = 8'h00;
    #10; address = 8'h04;
    #10; address = 8'h08;
    #10; address = 8'h20;
    // 意外输入
    #10; address = 8'hFF;
    #10; address = 8'h00;
    // 测试编程模式
    #5; rst = 1; #5; rst = 0;
    edit = 1;     // 进入编程模式
    unit = 8'h04; // 要编程的地址
    code = 8'hFF; // 要写入的代码
    #1; send = 1;
    #10;
    unit = 8'h05; // 要编程的地址
    code = 8'h00; // 要写入的代码
    #1; send = 1;
    #10;
    unit = 8'h06; // 要编程的地址
    code = 8'h1F; // 要写入的代码
    #1; send = 1;
    #10;
    unit = 8'h07; // 要编程的地址
    code = 8'h02; // 要写入的代码
    #1; send = 1;
    #10; send = 0;
    #2; edit = 0;
    address = 8'h04; // 读取指令
    #15; rst = 1;
    #5; rst = 0;
    #50; $finish;
end

endmodule
