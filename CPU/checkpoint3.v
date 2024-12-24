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

localparam IMM1 = 8'b10000000;
localparam IMM2 = 8'b01000000;
localparam MOV  = 8'b01000000;
localparam JMP  = 8'b10000000;
localparam TO   = 8'b00000000;
localparam ADD = 8'b00000000;
localparam SUB = 8'b00000001;
localparam AND = 8'b00000010;
localparam OR  = 8'b00000011;
localparam NOT = 8'b00000100;
localparam XOR = 8'b00000101;
localparam SHL = 8'b00000110;
localparam SHR = 8'b00000111;
localparam MUL = 8'b00001000;
localparam DIV = 8'b00001001;
localparam MOD = 8'b00001010;
localparam NULL    = 8'b00000000;
localparam REG0    = 8'b00000000;
localparam REG1    = 8'b00000001;
localparam REG2    = 8'b00000010;
localparam REG3    = 8'b00000011;
localparam REG4    = 8'b00000100;
localparam REG5    = 8'b00000101;
localparam COUNTER = 8'b00000110;
localparam INPUT   = 8'b00000111;
localparam OUTPUT  = 8'b00000111;
localparam HALT = 8'b00110010;

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
initial begin
    $dumpfile("3.vcd");
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
    I = 8'b00001111;
    #2; rst = 1; rstROM = 1;
    #2; rst = 0; rstROM = 0;
    #2; edit = 1;
    #2; code = IMM2|ADD; unit = 8'd0; #2; send = 1; #2; send = 0;
    #2; code = INPUT; unit = 8'd1; #2; send = 1; #2; send = 0;
    #2; code = 8'd1; unit = 8'd2; #2; send = 1; #2; send = 0;
    #2; code = REG0; unit = 8'd3; #2; send = 1; #2; send = 0;

    #2; code = IMM2|SUB; unit = 8'd4; #2; send = 1; #2; send = 0;
    #2; code = REG0; unit = 8'd5; #2; send = 1; #2; send = 0;
    #2; code = 8'd123; unit = 8'd6; #2; send = 1; #2; send = 0;
    #2; code = REG1; unit = 8'd7; #2; send = 1; #2; send = 0;

    #2; code = MOV; unit = 8'd8; #2; send = 1; #2; send = 0;
    #2; code = REG0; unit = 8'd9; #2; send = 1; #2; send = 0;
    #2; code = TO; unit = 8'd10; #2; send = 1; #2; send = 0;
    #2; code = REG2; unit = 8'd11; #2; send = 1; #2; send = 0;

    #2; code = IMM2|OR; unit = 8'd12; #2; send = 1; #2; send = 0;
    #2; code = REG1; unit = 8'd13; #2; send = 1; #2; send = 0;
    #2; code = 8'd123; unit = 8'd14; #2; send = 1; #2; send = 0;
    #2; code = REG3; unit = 8'd15; #2; send = 1; #2; send = 0;

    #2; code = IMM1|NOT; unit = 8'd16; #2; send = 1; #2; send = 0;
    #2; code = 8'd2; unit = 8'd17; #2; send = 1; #2; send = 0;
    #2; code = NULL; unit = 8'd18; #2; send = 1; #2; send = 0;
    #2; code = REG4; unit = 8'd19; #2; send = 1; #2; send = 0;
    
    #2; code = IMM2|XOR; unit = 8'd20; #2; send = 1; #2; send = 0;
    #2; code = REG3; unit = 8'd21; #2; send = 1; #2; send = 0;
    #2; code = 8'd123; unit = 8'd22; #2; send = 1; #2; send = 0;
    #2; code = REG5; unit = 8'd23; #2; send = 1; #2; send = 0;

    #2; code = IMM2|ADD; unit = 8'd24; #2; send = 1; #2; send = 0;
    #2; code = REG2; unit = 8'd25; #2; send = 1; #2; send = 0;
    #2; code = 8'd32; unit = 8'd26; #2; send = 1; #2; send = 0;
    #2; code = COUNTER; unit = 8'd27; #2; send = 1; #2; send = 0;

    #2; code = HALT; unit = 8'd28; #2; send = 1; #2; send = 0;
    #2; code = HALT; unit = 8'd252; #2; send = 1; #2; send = 0;
    #2; edit = 0;
    #2; RUN = 1; #2; RUN = 0; #2;
    #150; $finish;
end
endmodule
