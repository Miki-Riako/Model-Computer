module counter_tb;
reg [7:0] STEP;
reg ENABLE;
reg clk;
reg rst;
reg NEXT;
reg RUN;
reg SPEEDRUN;
reg mode;
reg [7:0] value;
wire [7:0] count;
wire [7:0] monitor_signal;
counter uut (
    .STEP(STEP),
    .ENABLE(ENABLE),
    .clk(clk),
    .rst(rst),
    .NEXT(NEXT),
    .RUN(RUN),
    .SPEEDRUN(SPEEDRUN),
    .mode(mode),
    .value(value),
    .count(count),
    .monitor_signal(monitor_signal)
);
initial begin
    clk = 0;
    forever #1 clk = ~clk;
end
initial begin
    $dumpfile("a.vcd");
    $dumpvars(0, counter_tb);
    STEP = 8'b00000001;
    ENABLE = 0;
    rst = 0;
    NEXT = 0;
    RUN = 0;
    SPEEDRUN = 0;
    mode = 0;
    value = 8'b00000000;
    #5; rst = 0; #5; rst = 1; #5; rst = 0;
    #3; NEXT = 1; #3; NEXT = 0; #3;
    RUN = 1; #5 RUN = 0; 
    #20; ENABLE = 1; #10 ENABLE = 0;
    #5; rst = 0; #5; rst = 1; #5; rst = 0;
    mode = 1; #5; value = 8'b00001010;
    #10; NEXT = 1;
    #10; NEXT = 0;
    #3; mode = 0;
    #5; SPEEDRUN = 1; 
    #10 SPEEDRUN = 0;
    #5; rst = 0; #5; rst = 1; #5; rst = 0;
    #10 NEXT = 1;
    #10 NEXT = 0;
    #100 $finish;
end
endmodule
