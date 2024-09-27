`timescale 1ns / 1ps
module interface (
    input wire clk,         // 时钟信号
    input wire rstROM,      // ROM复位信号
    input wire rst,         // 复位信号
    input wire next,        // 下一条指令
    input wire run,         // 运行
    input wire speedRun,    // 快速运行
    input wire edit,        // 编程模式信号
    input wire [7:0] unit,  // 代码位置
    input wire [7:0] code,  // 代码
    input wire send,        // 发送程序信号

    input wire [7:0] I,  // I
    output wire IEnable, // I使能信号
    output wire OEnable, // O使能信号

    output wire [2:0] video_red,   // 红色分量输出
    output wire [2:0] video_green, // 绿色分量输出
    output wire [1:0] video_blue,  // 蓝色分量输出
    output wire video_hsync,       // 水平同步信号
    output wire video_vsync,       // 垂直同步信号
    output wire video_clk,         // 像素时钟输出
    output wire video_de           // 数据有效信号
);

COMPUTER (
    .clk(clk),
    .rstROM(rstROM),
    .rst(rst),
    .next(next),
    .run(run),
    .speedRun(speedRun),
    .edit(edit),
    .unit(unit),
    .code(code),
    .send(send),
    .chose(chose),
    .I(I),
    .O(O),
    .IEnable(IEnable),
    .OEnable(OEnable),
    .monitor_outputs0(),
    .monitor_outputs1(),
    .monitor_outputs2(),
    .monitor_outputs3(),
    .monitor_outputs4(),
    .monitor_outputs5(),
    .monitor_outputs6(),
    .monitor_outputs7(),
    .monitor_outputs8(),
    .monitor_outputs9(),
    .monitor_outputs10(),
    .monitor_outputs11(),
    .monitor_outputs12(),
    .monitor_outputs13(),
    .monitor_outputs14(),
    .monitor_outputs15()
);
// lcd_top模块实例化，负责将输出显示在LCD上
lcd_top display (
    .clk_50M(clk),         // 50MHz时钟输入
    .reset_btn(rst),       // 重置按钮
    .O(O),
    .monitor_outputs0(monitor_outputs0),
    .monitor_outputs1(monitor_outputs1),
    .monitor_outputs2(monitor_outputs2),
    .monitor_outputs3(monitor_outputs3),
    .monitor_outputs4(monitor_outputs4),
    .monitor_outputs5(monitor_outputs5),
    .monitor_outputs6(monitor_outputs6),
    .monitor_outputs7(monitor_outputs7),
    .video_red(video_red),     // 视频信号红色分量
    .video_green(video_green), // 视频信号绿色分量
    .video_blue(video_blue),   // 视频信号蓝色分量
    .video_hsync(video_hsync), // 水平同步信号
    .video_vsync(video_vsync), // 垂直同步信号
    .video_clk(video_clk),     // 像素时钟输出
    .video_de(video_de)        // 数据有效信号
);
endmodule
