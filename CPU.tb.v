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
    #5; clk = ~clk;
end
initial begin
    $dumpfile("a.vcd");
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
    program = 2'b00;
    I = 8'b00000000;
    #10;
    rst = 1;
    rstROM = 1;
    #10;
    rst = 0;
    rstROM = 0;
    #1; NEXT = 1; #1; NEXT = 0;
    // // Edit
    // edit = 1;
    // unit = 8'd1;
    // code = 8'b00010000;
    // send = 1; #10 send = 0; #5;
    // unit = 8'd2;
    // code = 8'b00110000;
    // send = 1; #10 send = 0; #5;
    // edit = 0;
    // // Run
    // RUN = 1;
    // #100;
    // #5; rst = 1; rstROM = 1; #5; rst =0; rstROM = 1; #5; rst =0;
    // #5; NEXT = 1; #5; NEXT = 0; #5;
    // #50; SPEEDRUN = 1; #5 SPEEDRUN = 0;
    #100; $finish;
end
endmodule
