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
// reg [7:0] cntOutput_debug;
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
    // .cntOutput_debug(cntOutput_debug),
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
    $dumpfile("CPU.vcd");
    $dumpvars(0, CPU_tb);
    clk = 0;
    rst = 0;
    rstROM = 0;
    NEXT = 1;
    RUN = 0;
    SPEEDRUN = 0;
    edit = 0;
    unit = 8'b00000000;
    code = 8'b00000000;
    send = 0;
    program = 2'b00;
    I = 8'b00001111;
    // cntOutput_debug = 8'b00000000;
    #10;
    rst = 1;
    rstROM = 1;
    #10;
    rst = 0;
    rstROM = 0;
    // mov 4 to reg1
    // #4; edit = 1; #2; code = 8'b10000000; unit = 8'b00000000; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000100; unit = 8'b00000001; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00000010; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00000011; #2; send = 1; #2; send = 0;
    // #2; edit = 0;
    // // jmp to 12 counter
    // #4; edit = 1; #2; code = 8'b11000000; unit = 8'b00000100; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00000101; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00001100; unit = 8'b00000110; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000110; unit = 8'b00000111; #2; send = 1; #2; send = 0;
    // #2; edit = 0;
    // // mov 2 to reg2
    // #4; edit = 1; #2; code = 8'b11000000; unit = 8'b00001000; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000010; unit = 8'b00001001; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00001010; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000010; unit = 8'b00001011; #2; send = 1; #2; send = 0;
    // #2; edit = 0;
    // // add reg1 reg2 reg3 // sub(00000001) reg1 reg2 reg3
    // #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00001100; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00001101; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000010; unit = 8'b00001110; #2; send = 1; #2; send = 0;
    // #4; edit = 1; #2; code = 8'b00000011; unit = 8'b00001111; #2; send = 1; #2; send = 0;
    
    
    // call ret
    // call 8
    #4; edit = 1; #2; code = 8'b00110000; unit = 8'b00000000; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00000001; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00000010; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00001000; unit = 8'b00000011; #2; send = 1; #2; send = 0;
    #2; edit = 0;
    // add reg1 2 reg1
    #4; edit = 1; #2; code = 8'b01000000; unit = 8'b00000100; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00000101; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000010; unit = 8'b00000110; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00000111; #2; send = 1; #2; send = 0;
    #2; edit = 0;
    // add reg1 1 reg1
    #4; edit = 1; #2; code = 8'b01000000; unit = 8'b00001100; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00001101; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00001110; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000001; unit = 8'b00001111; #2; send = 1; #2; send = 0;
    // ret
    #4; edit = 1; #2; code = 8'b00110001; unit = 8'b00001000; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00001001; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00001010; #2; send = 1; #2; send = 0;
    #4; edit = 1; #2; code = 8'b00000000; unit = 8'b00001011; #2; send = 1; #2; send = 0;
    #2; edit = 0;
    // end
    #2; edit = 0;
    #2; RUN = 1; #2; RUN = 0; #4;
    #2; RUN = 1; #2; RUN = 0; #4;
    #2; RUN = 1; #2; RUN = 0; #4;
    #2; RUN = 1; #2; RUN = 0; #4;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    // #4; cntOutput_debug = cntOutput_debug + 4; #16;
    #100; $finish;
end
endmodule
