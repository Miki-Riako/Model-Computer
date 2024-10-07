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
    #1; I = I + 8'd1; #1;
end
initial begin
    $dumpfile("5.vcd");
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
    program = 2'b01; /** Check the program in ROM:
                      *  从输入端依次读取32个数值，再按照输入的顺序将32个数原样输出。
                      *  The 32 values are read from the inputs in sequence,
                      *  and then the 32 numbers are output as they are in the order of the inputs.
                      *  用于检验随机存储器RAM.
                      **/
    I = 8'b00001111;
    #2; rst = 1; rstROM = 1;
    #2; rst = 0; rstROM = 0;
    #2; RUN = 1; #2; RUN = 0;
    #1; I = 8'd0;
    #600; $finish;
end
endmodule