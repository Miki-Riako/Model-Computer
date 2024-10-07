`timescale 1ns / 1ps

module CPU_tb;
reg clk;
reg rstROM;
reg rst;
reg NEXT;
reg RUN;
reg SPEEDRUN;
reg edit;
reg [7:0] unit;
reg [7:0] code;
reg send;
reg [1:0] program;
reg [7:0] I;
wire [7:0] O;
wire IEnable;
wire OEnable;
wire [7:0] reg0_monitor_signal;
wire [7:0] reg1_monitor_signal;
wire [7:0] reg2_monitor_signal;
wire [7:0] reg3_monitor_signal;
wire [7:0] reg4_monitor_signal;
wire [7:0] reg5_monitor_signal;
wire [7:0] counter_monitor_signal;
wire [7:0] O_monitor_signal;

CPU uut (
    .clk(clk),
    .rstROM(rstROM),
    .rst(rst),
    .NEXT(NEXT),
    .RUN(RUN),
    .SPEEDRUN(SPEEDRUN),
    .edit(edit),
    .unit(unit),
    .code(code),
    .send(send),
    .program(program),
    .I(I),
    .O(O),
    .IEnable(IEnable),
    .OEnable(OEnable),
    .reg0_monitor_signal(reg0_monitor_signal),
    .reg1_monitor_signal(reg1_monitor_signal),
    .reg2_monitor_signal(reg2_monitor_signal),
    .reg3_monitor_signal(reg3_monitor_signal),
    .reg4_monitor_signal(reg4_monitor_signal),
    .reg5_monitor_signal(reg5_monitor_signal),
    .counter_monitor_signal(counter_monitor_signal),
    .O_monitor_signal(O_monitor_signal)
);
always begin
    #1; clk = ~clk;
end
always begin
    #1; I = 8'd1; #1;
    #1; I = 8'd2; #1;
    #1; I = 8'd3; #1;
    #1; I = 8'd4; #1;
    #1; I = 8'd5; #1;
    #1; I = 8'd6; #1;
    #1; I = 8'd0; #1;
end
initial begin
    $dumpfile("6.vcd");
    $dumpvars(0, CPU_tb);
    clk = 0;
    rst = 0;
    rstROM = 0;
    NEXT = 0;
    RUN = 0;
    SPEEDRUN = 0;
    edit = 0;
    unit = 8'b00000000;
    code = 8'b00000000;
    send = 0;
    program = 2'b10; /** Check the program in ROM:
                      *  当输入为0时，弹出（pop）栈顶值，并将其发送到输出设备中。
                      *  当输入不为0时，将输入的值压入（push）栈中。
                      *  When the input is 0,
                      *  pops the top-of-stack value and sends it to the output device.
                      *  When the input is not 0,
                      *  the input value is pressed into the stack.
                      *  用于检验栈STACK.
                      **/
    I = 8'b00001111;
    #2; rst = 1; rstROM = 1;
    #2; rst = 0; rstROM = 0;
    #2; RUN = 1; #2; RUN = 0;
    #1; I = 8'd0;
    #600; $finish;
end
endmodule