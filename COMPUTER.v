module COMPUTER (
    input wire clk,         // 时钟信号
    input wire rstROM,      // ROM复位信号
    input wire rst,         // 复位信号
    input wire next,        // 下一条指令
    input wire run,         // 运行
    input wire speedRun,    // 快速运行
    input wire edit,        // 编程模式信号
    input wire [7:0] line,  // 代码行数
    input wire [31:0] code, // 代码
    input wire send,        // 发送程序信号

    input wire [7:0] I, // I
    output reg [7:0] O, // O
    output reg IEnable, // I使能信号
    output reg OEnable, // O使能信号

    output reg [7:0] STEP, // 程序计数器

    output reg [7:0] monitor_outputs0,  // 监视输出0
    output reg [7:0] monitor_outputs1,  // 监视输出1
    output reg [7:0] monitor_outputs2,  // 监视输出2
    output reg [7:0] monitor_outputs3,  // 监视输出3
    output reg [7:0] monitor_outputs4,  // 监视输出4
    output reg [7:0] monitor_outputs5,  // 监视输出5
    output reg [7:0] monitor_outputs6,  // 监视输出6
    output reg [7:0] monitor_outputs7,  // 监视输出7

    output reg [7:0] monitor_outputs8,  // 监视输出8
    output reg [7:0] monitor_outputs9,  // 监视输出9
    output reg [7:0] monitor_outputs10, // 监视输出10
    output reg [7:0] monitor_outputs11, // 监视输出11
    output reg [7:0] monitor_outputs12, // 监视输出12
    output reg [7:0] monitor_outputs13, // 监视输出13
    output reg [7:0] monitor_outputs14, // 监视输出14
    output reg [7:0] monitor_outputs15  // 监视输出15
);

always @(posedge rst) begin
    STEP    <= 8'b00000000;
    O       <= 8'b0000000;
    IEnable <= 1'b0;
    OEnable <= 1'b0;
    monitor_outputs0 <= 8'b0;
    monitor_outputs1 <= 8'b0;
    monitor_outputs2 <= 8'b0;
    monitor_outputs3 <= 8'b0;
    monitor_outputs4 <= 8'b0;
    monitor_outputs5 <= 8'b0;
    monitor_outputs6 <= 8'b0;
    monitor_outputs7 <= 8'b0;
    monitor_outputs8 <= 8'b0;
    monitor_outputs9 <= 8'b0;
    monitor_outputs10 <= 8'b0;
    monitor_outputs11 <= 8'b0;
    monitor_outputs12 <= 8'b0;
    monitor_outputs13 <= 8'b0;
    monitor_outputs14 <= 8'b0;
    monitor_outputs15 <= 8'b0;
end

CPU cpu(
    .clk(clk),
    .rstRom(rstRom),
    .rst(rst),
    .NEXT(next),
    .RUN(run),
    .SPEEDRUN(speedRun),
    .edit(edit),
    .line(line),
    .code(code),
    .send(send),
    .I(I),
    .O(O),
    .IEnable(IEnable),
    .OEnable(OEnable),
    .reg0_monitor_signal(monitor_outputs0),
    .reg1_monitor_signal(monitor_outputs1),
    .reg2_monitor_signal(monitor_outputs2),
    .reg3_monitor_signal(monitor_outputs3),
    .reg4_monitor_signal(monitor_outputs4),
    .reg5_monitor_signal(monitor_outputs5),
    .counter_monitor_signal(monitor_outputs6),
    .O_monitor_signal(monitor_outputs7)
);
endmodule
