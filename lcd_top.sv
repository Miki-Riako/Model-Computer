module lcd_top (
    input wire clk_50M,        // 50MHz 时钟输入
    input wire reset_btn,      // 重置按钮输入，高电平有效
    input wire [7:0] O,
    input wire [7:0] monitor_outputs0,
    input wire [7:0] monitor_outputs1,
    input wire [7:0] monitor_outputs2,
    input wire [7:0] monitor_outputs3,
    input wire [7:0] monitor_outputs4,
    input wire [7:0] monitor_outputs5,
    input wire [7:0] monitor_outputs6,
    input wire [7:0] monitor_outputs7,
    // 视频输出信号
    output wire [2:0] video_red,    // 红色分量输出，3位
    output wire [2:0] video_green,  // 绿色分量输出，3位
    output wire [1:0] video_blue,   // 蓝色分量输出，2位
    output wire video_hsync,        // 水平同步信号
    output wire video_vsync,        // 垂直同步信号
    output wire video_clk,          // 像素时钟输出
    output wire video_de            // 数据有效信号，用于标识有效显示区域
);
    // 生成像素时钟
    logic clk_pix;
    logic clk_pix_locked;

    clock_divider clock_div_inst (
        .clk(clk_50M),
        .rst(reset_btn),
        .clk_div(clk_pix)
    );
    
    wire [7:0] o0h, o0l;
    wire [7:0] o1h, o1l;
    wire [7:0] o2h, o2l;
    wire [7:0] o3h, o3l;
    wire [7:0] o4h, o4l;
    wire [7:0] o5h, o5l;
    wire [7:0] o6h, o6l;
    wire [7:0] o7h, o7l;
    wire [7:0] Oh,  Ol;
    
    bin2ascii o0_conv (.bin(monitor_outputs0),   .ascii_high(o0h), .ascii_low(o0l));
    bin2ascii o1_conv (.bin(monitor_outputs1),   .ascii_high(o1h), .ascii_low(o1l));
    bin2ascii o2_conv (.bin(monitor_outputs2),   .ascii_high(o2h), .ascii_low(o2l));
    bin2ascii o3_conv (.bin(monitor_outputs3),   .ascii_high(o3h), .ascii_low(o3l));
    bin2ascii o4_conv (.bin(monitor_outputs4),   .ascii_high(o4h), .ascii_low(o4l));
    bin2ascii o5_conv (.bin(monitor_outputs5),   .ascii_high(o5h), .ascii_low(o5l));
    bin2ascii o6_conv (.bin(monitor_outputs6),   .ascii_high(o6h), .ascii_low(o6l));
    bin2ascii o7_conv (.bin(monitor_outputs7),   .ascii_high(o7h), .ascii_low(o7l));
    bin2ascii O_conv  (.bin(O), .ascii_high(Oh), .ascii_low(Ol));
    localparam SPACE = 8'h20;
    wire [79:0] line_0;
    wire [79:0] line_1;
    wire [79:0] line_2;
    assign line_0 = {o0h, o0l, o1h, o1l, Oh, Ol, o2h, o2l, o3h, o3l};
    assign line_1 = {o4h, o4l, o5h, o5l, SPACE, SPACE, o6h, o6l, o7h, o7l};
    assign line_2 = {SPACE, SPACE, SPACE, SPACE, SPACE, SPACE, SPACE, SPACE, SPACE, SPACE};

    // DVI输出模块实例化
    dvi_module dvi_inst (
        .clk(clk_pix),
        .clk_locked(reset_btn),
        .video_red(video_red),
        .video_green(video_green),
        .video_blue(video_blue),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync),
        .video_clk(video_clk),
        .video_de(video_de),
        .line_0_ascii(line_0),
        .line_1_ascii(line_1),
        .line_2_number(line_2)
    );
endmodule

module bin2ascii(
    input wire [7:0] bin,
    output reg [7:0] ascii_high,
    output reg [7:0] ascii_low
);
always @(*) begin
    // if (bin[7:4] < 4'd10)
        ascii_high = bin[7:4] + 8'h30;
    // else
        // ascii_high = bin[7:4] + 8'h37;
    // if (bin[3:0] < 4'd10)
        ascii_low = bin[3:0] + 8'h30;
    // else
        // ascii_low = bin[3:0] + 8'h37;
end
endmodule




// 时钟分频模块
module clock_divider(
    input wire clk,    // 输入时钟
    input wire rst,    // 重置信号
    output reg clk_div // 分频后的输出时钟
);
always @(posedge clk) begin
    if (rst) begin
        clk_div <= 1'b0; // 重置分频时钟
    end else begin
        clk_div <= ~clk_div; // 时钟取反，产生分频效果
    end
end
endmodule
// DVI输出模块
module dvi_module (
    input   wire          clk,         // 像素时钟
    input   wire          clk_locked,  // 时钟锁定信号
    output wire [2:0]     video_red,   // 红色分量输出
    output wire [2:0]     video_green, // 绿色分量输出
    output wire [1:0]     video_blue,  // 蓝色分量输出
    output wire           video_hsync, // 水平同步信号
    output wire           video_vsync, // 垂直同步信号
    output wire           video_clk,   // 像素时钟输出
    output wire           video_de,    // 数据有效信号
    input wire [79:0]     line_0_ascii,// 第一行ASCII字符数据
    input wire [79:0]     line_1_ascii,// 第二行ASCII字符数据
    input wire [79:0]      line_2_number // 第三行显示的数字数据
);

wire [15:0] line_2_ascii;
wire [7:0] line_2_bcd;
bin2bcd bcd_inst (
    .bin(line_2_number),
    .bcd(line_2_bcd)
);

assign line_2_ascii[7:0]  = line_2_bcd[3:0] + 8'h30; // 转换为ASCII码
assign line_2_ascii[15:8]  = line_2_bcd[7:4] + 8'h30; // 转换为ASCII码

// 显示同步信号和坐标
localparam CORDW = 10;  // 屏幕坐标宽度，10位
logic [CORDW-1:0] sx, sy; // 屏幕坐标
logic hsync, vsync, de; // 同步信号和数据有效信号
simple_480p display_inst (
    .clk_pix(clk),
    .rst_pix(clk_locked),  // 等待时钟锁定
    .sx,
    .sy,
    .hsync,
    .vsync,
    .de
);

  wire [3:0] column_from_left; // 当前列
  wire [3:0] line_from_top;    // 当前行
  localparam MAX_COLUMN = 10;  // 最大列数
  localparam MAX_LINE = 3;     // 最大行数
  assign column_from_left = sx[9:6]; // 每列64像素，屏幕宽640像素
  assign line_from_top = sy[9:7];  // 屏幕高度480像素，按128像素一行

wire [7:0] ascii; // 当前显示的ASCII字符
wire [6:0] column_location; // 当前列的位置
assign column_location = column_from_left << 3;
assign ascii = (line_from_top == 0) ? line_0_ascii[79 - column_location -: 8] :
            (line_from_top == 1) ? line_1_ascii[79 - column_location -: 8] :
            (line_from_top == 2) ? line_2_ascii[79 - column_location -: 8] :
            8'b0;

wire [7:0] ascii_rom_line; // ASCII ROM输出

wire [2:0] ascii_column; // ASCII字符的列
wire [3:0] ascii_line; // ASCII字符的行
assign ascii_column = sx[5:3]; 
assign ascii_line = sy[6:3]; 

ascii_rom_async ascii_rom_inst (
    .addr({ascii[6:0], ascii_line}),
    .data(ascii_rom_line)
);

wire draw_ascii; // 是否绘制ASCII字符
assign draw_ascii = ascii_rom_line[7 - ascii_column];

  // 颜色绘制
logic [3:0] paint_r, paint_g, paint_b;
always_comb begin
    if (draw_ascii) begin
        paint_r = 4'h0; // 绿色时红色分量为0
        paint_g = 4'hF; // 绿色分量为最大值
        paint_b = 4'h0; // 绿色时蓝色分量为0
    end else begin
        paint_r = 4'h1;
        paint_g = 4'h3;
        paint_b = 4'h7;
    end
end

// 显示颜色：在空白区间为黑色
logic [3:0] display_r, display_g, display_b;
always_comb begin
  display_r = (de) ? paint_r : 4'h0;
  display_g = (de) ? paint_g : 4'h0;
  display_b = (de) ? paint_b : 4'h0;
end

reg vga_hsync, vga_vsync;
reg [3:0] vga_r, vga_g, vga_b;
// VGA输出
always_ff @(posedge clk) begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    vga_r <= display_r;
    vga_g <= display_g;
    vga_b <= display_b;
end

assign video_clk   = clk;
assign video_hsync = hsync;
assign video_vsync = vsync;
assign video_red   = display_r[3:1];
assign video_green = display_g[3:1];
assign video_blue  = display_b[3:2];
assign video_de    = de;

endmodule
// 二进制转BCD编码
module bin2bcd(
    input wire [7:0] bin,  // 输入8位二进制
    output wire [7:0] bcd  // 输出8位BCD码，最高支持255（两个十进制位）
);

integer i;
reg [3:0] ones;
reg [3:0] tens;

always @(bin) begin
    ones = 4'b0;
    tens = 4'b0;

    for (i = 7; i >= 0; i = i - 1) begin
        if (ones >= 5) begin
            ones = ones + 3;
        end
        if (tens >= 5) begin
            tens = tens + 3;
        end
        tens = {tens[2:0], ones[3]};
        ones = {ones[2:0], bin[i]};
    end
end
assign bcd = {tens, ones};
endmodule
// 简单480p显示模块
module simple_480p (
    input  wire logic clk_pix,  // 像素时钟
    input  wire logic rst_pix,  // 像素时钟域的重置信号
    output logic [9:0] sx,      // 水平屏幕位置
    output logic [9:0] sy,      // 垂直屏幕位置
    output logic hsync,         // 水平同步信号
    output logic vsync,         // 垂直同步信号
    output logic de             // 数据有效信号（空白区为低电平）
);
    // 水平时序
    parameter HA_END = 639;          // 有效像素的结束位置
    parameter HS_STA = HA_END + 16;  // 同步信号开始位置（前沿消隐后）
    parameter HS_END = HS_STA + 96;  // 同步信号结束位置
    parameter LINE   = 799;          // 行的最后一个像素（后沿消隐后）

    // 垂直时序
    parameter VA_END = 479;          // 有效像素的结束位置
    parameter VS_STA = VA_END + 10;  // 同步信号开始位置（前沿消隐后）
    parameter VS_END = VS_STA + 2;   // 同步信号结束位置
    parameter SCREEN = 524;          // 屏幕的最后一行（后沿消隐后）

    always_comb begin
        hsync = ~(sx >= HS_STA && sx < HS_END); // 负极性水平同步信号
        vsync = ~(sy >= VS_STA && sy < VS_END); // 负极性垂直同步信号
        de = (sx <= HA_END && sy <= VA_END);    // 数据有效信号
    end

    // 计算水平和垂直屏幕位置
    always_ff @(posedge clk_pix) begin
        if (sx == LINE) begin // 是否到达行尾？
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1; // 是否到达屏幕末尾？
        end else begin
            sx <= sx + 1;
        end

        if (rst_pix) begin
            sx <= 0;
            sy <= 0;
        end
    end
endmodule


module ascii_rom_async (
    input  wire  [10:0] addr, // ��ַ����
    output reg   [7:0] data   // �������
);
always @(*) begin
    case (addr)
        // ASCII�� '0'
            11'h300: data = 8'b00000000;	//
            11'h301: data = 8'b00000000;	//
            11'h302: data = 8'b00111000;	//  ***  
            11'h303: data = 8'b01101100;	// ** **
            11'h304: data = 8'b11000110;	//**   **
            11'h305: data = 8'b11000110;	//**   **
            11'h306: data = 8'b11000110;	//**   **
            11'h307: data = 8'b11000110;	//**   **
            11'h308: data = 8'b11000110;	//**   **
            11'h309: data = 8'b11000110;	//**   **
            11'h30a: data = 8'b01101100;	// ** **
            11'h30b: data = 8'b00111000;	//  ***
            11'h30c: data = 8'b00000000;	//
            11'h30d: data = 8'b00000000;	//
            11'h30e: data = 8'b00000000;	//
            11'h30f: data = 8'b00000000;	//
            // ASCII�� '1'
            11'h310: data = 8'b00000000;	//
            11'h311: data = 8'b00000000;	//
            11'h312: data = 8'b00011000;	//   **  
            11'h313: data = 8'b00111000;	//  ***
            11'h314: data = 8'b01111000;	// ****
            11'h315: data = 8'b00011000;	//   **
            11'h316: data = 8'b00011000;	//   **
            11'h317: data = 8'b00011000;	//   **
            11'h318: data = 8'b00011000;	//   **
            11'h319: data = 8'b00011000;	//   **
            11'h31a: data = 8'b01111110;	// ******
            11'h31b: data = 8'b01111110;	// ******
            11'h31c: data = 8'b00000000;	//
            11'h31d: data = 8'b00000000;	//
            11'h31e: data = 8'b00000000;	//
            11'h31f: data = 8'b00000000;	//
            // ASCII�� '2'
            11'h320: data = 8'b00000000;	//
            11'h321: data = 8'b00000000;	//
            11'h322: data = 8'b11111110;	//*******  
            11'h323: data = 8'b11111110;	//*******
            11'h324: data = 8'b00000110;	//     **
            11'h325: data = 8'b00000110;	//     **
            11'h326: data = 8'b11111110;	//*******
            11'h327: data = 8'b11111110;	//*******
            11'h328: data = 8'b11000000;	//**
            11'h329: data = 8'b11000000;	//**
            11'h32a: data = 8'b11111110;	//*******
            11'h32b: data = 8'b11111110;	//*******
            11'h32c: data = 8'b00000000;	//
            11'h32d: data = 8'b00000000;	//
            11'h32e: data = 8'b00000000;	//
            11'h32f: data = 8'b00000000;	//
        // code x33 (3)
			11'h330: data = 8'b00000000;	//
			11'h331: data = 8'b00000000;	//
			11'h332: data = 8'b11111110;	//*******  
			11'h333: data = 8'b11111110;	//*******
			11'h334: data = 8'b00000110;	//     **
			11'h335: data = 8'b00000110;	//     **
			11'h336: data = 8'b00111110;	//  *****
			11'h337: data = 8'b00111110;	//  *****
			11'h338: data = 8'b00000110;	//     **
			11'h339: data = 8'b00000110;	//     **
			11'h33a: data = 8'b11111110;	//*******
			11'h33b: data = 8'b11111110;	//*******
			11'h33c: data = 8'b00000000;	//
			11'h33d: data = 8'b00000000;	//
			11'h33e: data = 8'b00000000;	//
			11'h33f: data = 8'b00000000;	//
			// code x34 (4)
			11'h340: data = 8'b00000000;	//
			11'h341: data = 8'b00000000;	//
			11'h342: data = 8'b11000110;	//**   **  
			11'h343: data = 8'b11000110;	//**   **
			11'h344: data = 8'b11000110;	//**   **
			11'h345: data = 8'b11000110;	//**   **
			11'h346: data = 8'b11111110;	//*******
			11'h347: data = 8'b11111110;	//*******
			11'h348: data = 8'b00000110;	//     **
			11'h349: data = 8'b00000110;	//     **
			11'h34a: data = 8'b00000110;	//     **
			11'h34b: data = 8'b00000110;	//     **
			11'h34c: data = 8'b00000000;	//
			11'h34d: data = 8'b00000000;	//
			11'h34e: data = 8'b00000000;	//
			11'h34f: data = 8'b00000000;	//
			// code x35 (5)
			11'h350: data = 8'b00000000;	//
			11'h351: data = 8'b00000000;	//
			11'h352: data = 8'b11111110;	//*******  
			11'h353: data = 8'b11111110;	//*******
			11'h354: data = 8'b11000000;	//**
			11'h355: data = 8'b11000000;	//**
			11'h356: data = 8'b11111110;	//*******
			11'h357: data = 8'b11111110;	//*******
			11'h358: data = 8'b00000110;	//     **
			11'h359: data = 8'b00000110;	//     **
			11'h35a: data = 8'b11111110;	//*******
			11'h35b: data = 8'b11111110;	//*******
			11'h35c: data = 8'b00000000;	//
			11'h35d: data = 8'b00000000;	//
			11'h35e: data = 8'b00000000;	//
			11'h35f: data = 8'b00000000;	//
			// code x36 (6)
			11'h360: data = 8'b00000000;	//
			11'h361: data = 8'b00000000;	//
			11'h362: data = 8'b11111110;	//*******  
			11'h363: data = 8'b11111110;	//*******
			11'h364: data = 8'b11000000;	//**
			11'h365: data = 8'b11000000;	//**
			11'h366: data = 8'b11111110;	//*******
			11'h367: data = 8'b11111110;	//*******
			11'h368: data = 8'b11000110;	//**   **
			11'h369: data = 8'b11000110;	//**   **
			11'h36a: data = 8'b11111110;	//*******
			11'h36b: data = 8'b11111110;	//*******
			11'h36c: data = 8'b00000000;	//
			11'h36d: data = 8'b00000000;	//
			11'h36e: data = 8'b00000000;	//
			11'h36f: data = 8'b00000000;	//
			// code x37 (7)
			11'h370: data = 8'b00000000;	//
			11'h371: data = 8'b00000000;	//
			11'h372: data = 8'b11111110;	//*******  
			11'h373: data = 8'b11111110;	//*******
			11'h374: data = 8'b00000110;	//     **
			11'h375: data = 8'b00000110;	//     **
			11'h376: data = 8'b00000110;	//     **
			11'h377: data = 8'b00000110;	//     **
			11'h378: data = 8'b00000110;	//     **
			11'h379: data = 8'b00000110;	//     **
			11'h37a: data = 8'b00000110;	//     **
			11'h37b: data = 8'b00000110;	//     **
			11'h37c: data = 8'b00000000;	//
			11'h37d: data = 8'b00000000;	//
			11'h37e: data = 8'b00000000;	//
			11'h37f: data = 8'b00000000;	//
			// code x38 (8)
			11'h380: data = 8'b00000000;	//
			11'h381: data = 8'b00000000;	//
			11'h382: data = 8'b11111110;	//*******  
			11'h383: data = 8'b11111110;	//*******
			11'h384: data = 8'b11000110;	//**   **
			11'h385: data = 8'b11000110;	//**   **
			11'h386: data = 8'b11111110;	//*******
			11'h387: data = 8'b11111110;	//*******
			11'h388: data = 8'b11000110;	//**   **
			11'h389: data = 8'b11000110;	//**   **
			11'h38a: data = 8'b11111110;	//*******
			11'h38b: data = 8'b11111110;	//*******
			11'h38c: data = 8'b00000000;	//
			11'h38d: data = 8'b00000000;	//
			11'h38e: data = 8'b00000000;	//
			11'h38f: data = 8'b00000000;	//
			// code x39 (9)
			11'h390: data = 8'b00000000;	//
			11'h391: data = 8'b00000000;	//
			11'h392: data = 8'b11111110;	//*******  
			11'h393: data = 8'b11111110;	//*******
			11'h394: data = 8'b11000110;	//**   **
			11'h395: data = 8'b11000110;	//**   **
			11'h396: data = 8'b11111110;	//*******
			11'h397: data = 8'b11111110;	//*******
			11'h398: data = 8'b00000110;	//     **
			11'h399: data = 8'b00000110;	//     **
			11'h39a: data = 8'b11111110;	//*******
			11'h39b: data = 8'b11111110;	//*******
			11'h39c: data = 8'b00000000;	//
			11'h39d: data = 8'b00000000;	//
			11'h39e: data = 8'b00000000;	//
			11'h39f: data = 8'b00000000;	//
			// code x3a (a)
			11'h3a0: data = 8'b00000000;    //
			11'h3a1: data = 8'b00000000;    //
			11'h3a2: data = 8'b00000000;    //
			11'h3a3: data = 8'b00000000;    //
			11'h3a4: data = 8'b00111100;    //  ****
			11'h3a5: data = 8'b00000110;    //     **
			11'h3a6: data = 8'b00111110;    //  *****
			11'h3a7: data = 8'b01100110;    // **  **
			11'h3a8: data = 8'b01111110;    // ******
			11'h3a9: data = 8'b01111110;    // ******
			11'h3aa: data = 8'b00000000;    //
			11'h3ab: data = 8'b00000000;    //
			11'h3ac: data = 8'b00000000;    //
			11'h3ad: data = 8'b00000000;    //
			11'h3ae: data = 8'b00000000;    //
			11'h3af: data = 8'b00000000;    // 		
        	// code x3b (b)
			11'h3b0: data = 8'b00000000;	//
			11'h3b1: data = 8'b00000000;	//
			11'h3b2: data = 8'b11000000;	//**      
			11'h3b3: data = 8'b11000000;	//**      
			11'h3b4: data = 8'b11111000;	//*****   
			11'h3b5: data = 8'b11001100;	//**  **  
			11'h3b6: data = 8'b11000110;	//**   ** 
			11'h3b7: data = 8'b11000110;	//**   ** 
			11'h3b8: data = 8'b11000110;	//**   ** 
			11'h3b9: data = 8'b11001100;	//**  **  
			11'h3ba: data = 8'b11111000;	//*****   
			11'h3bb: data = 8'b00000000;	//
			11'h3bc: data = 8'b00000000;	//
			11'h3bd: data = 8'b00000000;	//
			11'h3be: data = 8'b00000000;	//
			11'h3bf: data = 8'b00000000;	//
			// code x3c (c)
			11'h3c0: data = 8'b00000000;	//
			11'h3c1: data = 8'b00000000;	//
			11'h3c2: data = 8'b00000000;	//
			11'h3c3: data = 8'b00000000;	//
			11'h3c4: data = 8'b01111100;	// *****
			11'h3c5: data = 8'b11000110;	//**   **
			11'h3c6: data = 8'b11000000;	//**    
			11'h3c7: data = 8'b11000000;	//**    
			11'h3c8: data = 8'b11000000;	//**    
			11'h3c9: data = 8'b11000110;	//**   **
			11'h3ca: data = 8'b01111100;	// *****
			11'h3cb: data = 8'b00000000;	//
			11'h3cc: data = 8'b00000000;	//
			11'h3cd: data = 8'b00000000;	//
			11'h3ce: data = 8'b00000000;	//
			11'h3cf: data = 8'b00000000;	//
			// code x3d (d)
			11'h3d0: data = 8'b00000000;	//
			11'h3d1: data = 8'b00000000;	//
			11'h3d2: data = 8'b00000110;	//     ** 
			11'h3d3: data = 8'b00000110;	//     ** 
			11'h3d4: data = 8'b00111110;	//  *****
			11'h3d5: data = 8'b01100110;	// **  **
			11'h3d6: data = 8'b11000110;	//**   **
			11'h3d7: data = 8'b11000110;	//**   **
			11'h3d8: data = 8'b11000110;	//**   **
			11'h3d9: data = 8'b01100110;	// **  **
			11'h3da: data = 8'b00111110;	//  *****
			11'h3db: data = 8'b00000000;	//
			11'h3dc: data = 8'b00000000;	//
			11'h3dd: data = 8'b00000000;	//
			11'h3de: data = 8'b00000000;	//
			11'h3df: data = 8'b00000000;	//
			// code x3e (e)
			11'h3e0: data = 8'b00000000;	//
			11'h3e1: data = 8'b00000000;	//
			11'h3e2: data = 8'b00000000;	//
			11'h3e3: data = 8'b00000000;	//
			11'h3e4: data = 8'b01111100;	// *****
			11'h3e5: data = 8'b11000110;	//**   **
			11'h3e6: data = 8'b11111110;	//*******
			11'h3e7: data = 8'b11111110;	//*******
			11'h3e8: data = 8'b11000000;	//**    
			11'h3e9: data = 8'b11000110;	//**   **
			11'h3ea: data = 8'b01111100;	// *****
			11'h3eb: data = 8'b00000000;	//
			11'h3ec: data = 8'b00000000;	//
			11'h3ed: data = 8'b00000000;	//
			11'h3ee: data = 8'b00000000;	//
			11'h3ef: data = 8'b00000000;	//
			// code x3f (f) - �����￪ʼ
            11'h3f0: data = 8'b00000000;    //
            11'h3f1: data = 8'b00000000;    //
            11'h3f2: data = 8'b00011110;    //   ****
            11'h3f3: data = 8'b00110000;    //  **   
            11'h3f4: data = 8'b00110000;    //  **   
            11'h3f5: data = 8'b00110000;    //  **   
            11'h3f6: data = 8'b11111100;    // ******
            11'h3f7: data = 8'b11111100;    // ******
            11'h3f8: data = 8'b00110000;    //  **   
            11'h3f9: data = 8'b00110000;    //  **   
            11'h3fa: data = 8'b00110000;    //  **   
            11'h3fb: data = 8'b00000000;    //
            11'h3fc: data = 8'b00000000;    //
            11'h3fd: data = 8'b00000000;    //
            11'h3fe: data = 8'b00000000;    //
            11'h3ff: data = 8'b00000000;    //
            
            // code x40 (g)
            11'h400: data = 8'b00000000;    //
            11'h401: data = 8'b00000000;    //
            11'h402: data = 8'b00000000;    //
            11'h403: data = 8'b00000000;    //
            11'h404: data = 8'b00000000;    //
            11'h405: data = 8'b01111110;    // ******
            11'h406: data = 8'b11000110;    //**   **
            11'h407: data = 8'b11000110;    //**   **
            11'h408: data = 8'b01111110;    // ******
            11'h409: data = 8'b00000110;    //     **
            11'h40a: data = 8'b00000110;    //     **
            11'h40b: data = 8'b01111100;    // *****
            11'h40c: data = 8'b00000000;    //
            11'h40d: data = 8'b00000000;    //
            11'h40e: data = 8'b00000000;    //
            11'h40f: data = 8'b00000000;    //
            
            // code x41 (h)
            11'h410: data = 8'b00000000;    //
            11'h411: data = 8'b00000000;    //
            11'h412: data = 8'b11000000;    //**
            11'h413: data = 8'b11000000;    //**
            11'h414: data = 8'b11000000;    //**
            11'h415: data = 8'b11011100;    //** ***
            11'h416: data = 8'b11100110;    //***  **
            11'h417: data = 8'b11000110;    //**   **
            11'h418: data = 8'b11000110;    //**   **
            11'h419: data = 8'b11000110;    //**   **
            11'h41a: data = 8'b11000110;    //**   **
            11'h41b: data = 8'b00000000;    //
            11'h41c: data = 8'b00000000;    //
            11'h41d: data = 8'b00000000;    //
            11'h41e: data = 8'b00000000;    //
            11'h41f: data = 8'b00000000;    //
            
            // code x42 (i)
            11'h420: data = 8'b00000000;    //
            11'h421: data = 8'b00000000;    //
            11'h422: data = 8'b00110000;    //  **
            11'h423: data = 8'b00110000;    //  **
            11'h424: data = 8'b00000000;    //
            11'h425: data = 8'b11110000;    //****
            11'h426: data = 8'b00110000;    //  **
            11'h427: data = 8'b00110000;    //  **
            11'h428: data = 8'b00110000;    //  **
            11'h429: data = 8'b00110000;    //  **
            11'h42a: data = 8'b11111100;    //******
            11'h42b: data = 8'b00000000;    //
            11'h42c: data = 8'b00000000;    //
            11'h42d: data = 8'b00000000;    //
            11'h42e: data = 8'b00000000;    //
            11'h42f: data = 8'b00000000;    //
            
            // code x43 (j)
            11'h430: data = 8'b00000000;    //
            11'h431: data = 8'b00000000;    //
            11'h432: data = 8'b00011000;    //   **
            11'h433: data = 8'b00011000;    //   **
            11'h434: data = 8'b00000000;    //
            11'h435: data = 8'b01111000;    // ****
            11'h436: data = 8'b00011000;    //   **
            11'h437: data = 8'b00011000;    //   **
            11'h438: data = 8'b00011000;    //   **
            11'h439: data = 8'b11011000;    //** **
            11'h43a: data = 8'b01110000;    // ***
            11'h43b: data = 8'b00000000;    //
            11'h43c: data = 8'b00000000;    //
            11'h43d: data = 8'b00000000;    //
            11'h43e: data = 8'b00000000;    //
            11'h43f: data = 8'b00000000;    //
            
            // code x44 (k)
            11'h440: data = 8'b00000000;    //
            11'h441: data = 8'b00000000;    //
            11'h442: data = 8'b11000000;    //**
            11'h443: data = 8'b11000000;    //**
            11'h444: data = 8'b11000110;    //**   **
            11'h445: data = 8'b11001100;    //**  **
            11'h446: data = 8'b11011000;    //** **
            11'h447: data = 8'b11110000;    //****
            11'h448: data = 8'b11011000;    //** **
            11'h449: data = 8'b11001100;    //**  **
            11'h44a: data = 8'b11000110;    //**   **
            11'h44b: data = 8'b00000000;    //
            11'h44c: data = 8'b00000000;    //
            11'h44d: data = 8'b00000000;    //
            11'h44e: data = 8'b00000000;    //
            11'h44f: data = 8'b00000000;    //
            
            // code x45 (l)
            11'h450: data = 8'b00000000;    //
            11'h451: data = 8'b00000000;    //
            11'h452: data = 8'b11110000;    //****
            11'h453: data = 8'b00110000;    //  **
            11'h454: data = 8'b00110000;    //  **
            11'h455: data = 8'b00110000;    //  **
            11'h456: data = 8'b00110000;    //  **
            11'h457: data = 8'b00110000;    //  **
            11'h458: data = 8'b00110000;    //  **
            11'h459: data = 8'b00110000;    //  **
            11'h45a: data = 8'b11111100;    //******
            11'h45b: data = 8'b00000000;    //
            11'h45c: data = 8'b00000000;    //
            11'h45d: data = 8'b00000000;    //
            11'h45e: data = 8'b00000000;    //
            11'h45f: data = 8'b00000000;    //
            
            // code x46 (m)
            11'h460: data = 8'b00000000;    //
            11'h461: data = 8'b00000000;    //
            11'h462: data = 8'b00000000;    //
            11'h463: data = 8'b00000000;    //
            11'h464: data = 8'b00000000;    //
            11'h465: data = 8'b11001100;    //**  **
            11'h466: data = 8'b11010110;    //** * **
            11'h467: data = 8'b11010110;    //** * **
            11'h468: data = 8'b11010110;    //** * **
            11'h469: data = 8'b11010110;    //** * **
            11'h46a: data = 8'b11010110;    //** * **
            11'h46b: data = 8'b11010110;    //** * **
            11'h46c: data = 8'b00000000;    //
            11'h46d: data = 8'b00000000;    //
            11'h46e: data = 8'b00000000;    //
            11'h46f: data = 8'b00000000;    //
            
            // code x47 (n)
            11'h470: data = 8'b00000000;    //
            11'h471: data = 8'b00000000;    //
            11'h472: data = 8'b00000000;    //
            11'h473: data = 8'b00000000;    //
            11'h474: data = 8'b00000000;    //
            11'h475: data = 8'b11011100;    //** ***
            11'h476: data = 8'b11100110;    //***  **
            11'h477: data = 8'b11000110;    //**   **
            11'h478: data = 8'b11000110;    //**   **
            11'h479: data = 8'b11000110;    //**   **
            11'h47a: data = 8'b11000110;    //**   **
            11'h47b: data = 8'b00000000;    //
            11'h47c: data = 8'b00000000;    //
            11'h47d: data = 8'b00000000;    //
            11'h47e: data = 8'b00000000;    //
            11'h47f: data = 8'b00000000;    //
            
            // code x48 (o)
            11'h480: data = 8'b00000000;    //
            11'h481: data = 8'b00000000;    //
            11'h482: data = 8'b00000000;    //
            11'h483: data = 8'b00000000;    //
            11'h484: data = 8'b00000000;    //
            11'h485: data = 8'b01111100;    // *****
            11'h486: data = 8'b11000110;    //**   **
            11'h487: data = 8'b11000110;    //**   **
            11'h488: data = 8'b11000110;    //**   **
            11'h489: data = 8'b11000110;    //**   **
            11'h48a: data = 8'b01111100;    // *****
            11'h48b: data = 8'b00000000;    //
            11'h48c: data = 8'b00000000;    //
            11'h48d: data = 8'b00000000;    //
            11'h48e: data = 8'b00000000;    //
            11'h48f: data = 8'b00000000;    //
            
            // code x49 (p)
            11'h490: data = 8'b00000000;    //
            11'h491: data = 8'b00000000;    //
            11'h492: data = 8'b00000000;    //
            11'h493: data = 8'b00000000;    //
            11'h494: data = 8'b00000000;    //
            11'h495: data = 8'b11111100;    //******
            11'h496: data = 8'b11000110;    //**   **
            11'h497: data = 8'b11000110;    //**   **
            11'h498: data = 8'b11111100;    //******
            11'h499: data = 8'b11000000;    //**
            11'h49a: data = 8'b11000000;    //**
            11'h49b: data = 8'b11000000;    //**
            11'h49c: data = 8'b00000000;    //
            11'h49d: data = 8'b00000000;    //
            11'h49e: data = 8'b00000000;    //
            11'h49f: data = 8'b00000000;    //
            
            // code x4a (q)
            11'h4a0: data = 8'b00000000;    //
            11'h4a1: data = 8'b00000000;    //
            11'h4a2: data = 8'b00000000;    //
            11'h4a3: data = 8'b00000000;    //
            11'h4a4: data = 8'b00000000;    //
            11'h4a5: data = 8'b01111110;    // ******
            11'h4a6: data = 8'b11000110;    //**   **
            11'h4a7: data = 8'b11000110;    //**   **
            11'h4a8: data = 8'b01111110;    // ******
            11'h4a9: data = 8'b00000110;    //     **
            11'h4aa: data = 8'b00000110;    //     **
            11'h4ab: data = 8'b00000110;    //     **
            11'h4ac: data = 8'b00000000;    //
            11'h4ad: data = 8'b00000000;    //
            11'h4ae: data = 8'b00000000;    //
            11'h4af: data = 8'b00000000;    //
            
            // code x4b (r) - ����������
            11'h4b0: data = 8'b00000000;    //
            11'h4b1: data = 8'b00000000;    //
            11'h4b2: data = 8'b00000000;    //
            11'h4b3: data = 8'b00000000;    //
            11'h4b4: data = 8'b00000000;    //
            11'h4b5: data = 8'b11011100;    //** ***
            11'h4b6: data = 8'b11100110;    //***  **
            11'h4b7: data = 8'b11000000;    //**
            11'h4b8: data = 8'b11000000;    //**
            11'h4b9: data = 8'b11000000;    //**
            11'h4ba: data = 8'b11000000;    //**
            11'h4bb: data = 8'b00000000;    //
            11'h4bc: data = 8'b00000000;    //
            11'h4bd: data = 8'b00000000;    //
            11'h4be: data = 8'b00000000;    //
            11'h4bf: data = 8'b00000000;    //
            
            // code x4c (s)
            11'h4c0: data = 8'b00000000;    //
            11'h4c1: data = 8'b00000000;    //
            11'h4c2: data = 8'b00000000;    //
            11'h4c3: data = 8'b00000000;    //
            11'h4c4: data = 8'b00000000;    //
            11'h4c5: data = 8'b01111110;    // ******
            11'h4c6: data = 8'b11000000;    //**
            11'h4c7: data = 8'b01111100;    // *****
            11'h4c8: data = 8'b00000110;    //     **
            11'h4c9: data = 8'b11000110;    //**   **
            11'h4ca: data = 8'b01111100;    // *****
            11'h4cb: data = 8'b00000000;    //
            11'h4cc: data = 8'b00000000;    //
            11'h4cd: data = 8'b00000000;    //
            11'h4ce: data = 8'b00000000;    //
            11'h4cf: data = 8'b00000000;    //
            
            // code x4d (t)
            11'h4d0: data = 8'b00000000;    //
            11'h4d1: data = 8'b00000000;    //
            11'h4d2: data = 8'b00110000;    //  **
            11'h4d3: data = 8'b00110000;    //  **
            11'h4d4: data = 8'b11111100;    //******
            11'h4d5: data = 8'b00110000;    //  **
            11'h4d6: data = 8'b00110000;    //  **
            11'h4d7: data = 8'b00110000;    //  **
            11'h4d8: data = 8'b00110000;    //  **
            11'h4d9: data = 8'b00110110;    //  ** **
            11'h4da: data = 8'b00011100;    //   ***
            11'h4db: data = 8'b00000000;    //
            11'h4dc: data = 8'b00000000;    //
            11'h4dd: data = 8'b00000000;    //
            11'h4de: data = 8'b00000000;    //
            11'h4df: data = 8'b00000000;    //
            
            // code x4e (u)
            11'h4e0: data = 8'b00000000;    //
            11'h4e1: data = 8'b00000000;    //
            11'h4e2: data = 8'b00000000;    //
            11'h4e3: data = 8'b00000000;    //
            11'h4e4: data = 8'b00000000;    //
            11'h4e5: data = 8'b11000110;    //**   **
            11'h4e6: data = 8'b11000110;    //**   **
            11'h4e7: data = 8'b11000110;    //**   **
            11'h4e8: data = 8'b11000110;    //**   **
            11'h4e9: data = 8'b11000110;    //**   **
            11'h4ea: data = 8'b01111110;    // ******
            11'h4eb: data = 8'b00000000;    //
            11'h4ec: data = 8'b00000000;    //
            11'h4ed: data = 8'b00000000;    //
            11'h4ee: data = 8'b00000000;    //
            11'h4ef: data = 8'b00000000;    //
            
            // code x4f (v)
            11'h4f0: data = 8'b00000000;    //
            11'h4f1: data = 8'b00000000;    //
            11'h4f2: data = 8'b00000000;    //
            11'h4f3: data = 8'b00000000;    //
            11'h4f4: data = 8'b00000000;    //
            11'h4f5: data = 8'b11000110;    //**   **
            11'h4f6: data = 8'b11000110;    //**   **
            11'h4f7: data = 8'b11000110;    //**   **
            11'h4f8: data = 8'b11000110;    //**   **
            11'h4f9: data = 8'b01101100;    // ** **
            11'h4fa: data = 8'b00111000;    //  ***
            11'h4fb: data = 8'b00000000;    //
            11'h4fc: data = 8'b00000000;    //
            11'h4fd: data = 8'b00000000;    //
            11'h4fe: data = 8'b00000000;    //
            11'h4ff: data = 8'b00000000;    //
            
            // code x50 (w)
            11'h500: data = 8'b00000000;    //
            11'h501: data = 8'b00000000;    //
            11'h502: data = 8'b00000000;    //
            11'h503: data = 8'b00000000;    //
            11'h504: data = 8'b00000000;    //
            11'h505: data = 8'b11000011;    //**    **
            11'h506: data = 8'b11000011;    //**    **
            11'h507: data = 8'b11000011;    //**    **
            11'h508: data = 8'b11011011;    //** ** **
            11'h509: data = 8'b11111111;    //********
            11'h50a: data = 8'b01100110;    // **  **
            11'h50b: data = 8'b00000000;    //
            11'h50c: data = 8'b00000000;    //
            11'h50d: data = 8'b00000000;    //
            11'h50e: data = 8'b00000000;    //
            11'h50f: data = 8'b00000000;    //
            
            // code x51 (x)
            11'h510: data = 8'b00000000;    //
            11'h511: data = 8'b00000000;    //
            11'h512: data = 8'b00000000;    //
            11'h513: data = 8'b00000000;    //
            11'h514: data = 8'b00000000;    //
            11'h515: data = 8'b11000110;    //**   **
            11'h516: data = 8'b01101100;    // ** **
            11'h517: data = 8'b00111000;    //  ***
            11'h518: data = 8'b00111000;    //  ***
            11'h519: data = 8'b01101100;    // ** **
            11'h51a: data = 8'b11000110;    //**   **
            11'h51b: data = 8'b00000000;    //
            11'h51c: data = 8'b00000000;    //
            11'h51d: data = 8'b00000000;    //
            11'h51e: data = 8'b00000000;    //
            11'h51f: data = 8'b00000000;    //
            
            // code x52 (y)
            11'h520: data = 8'b00000000;    //
            11'h521: data = 8'b00000000;    //
            11'h522: data = 8'b00000000;    //
            11'h523: data = 8'b00000000;    //
            11'h524: data = 8'b00000000;    //
            11'h525: data = 8'b11000110;    //**   **
            11'h526: data = 8'b11000110;    //**   **
            11'h527: data = 8'b11000110;    //**   **
            11'h528: data = 8'b01111110;    // ******
            11'h529: data = 8'b00000110;    //     **
            11'h52a: data = 8'b00000110;    //     **
            11'h52b: data = 8'b11111100;    //******
            11'h52c: data = 8'b00000000;    //
            11'h52d: data = 8'b00000000;    //
            11'h52e: data = 8'b00000000;    //
            11'h52f: data = 8'b00000000;    //
            
            // code x53 (z)
            11'h530: data = 8'b00000000;    //
            11'h531: data = 8'b00000000;    //
            11'h532: data = 8'b00000000;    //
            11'h533: data = 8'b00000000;    //
            11'h534: data = 8'b00000000;    //
            11'h535: data = 8'b11111110;    //*******
            11'h536: data = 8'b00001100;    //    **
            11'h537: data = 8'b00011000;    //   **
            11'h538: data = 8'b00110000;    //  **
            11'h539: data = 8'b01100000;    // **
            11'h53a: data = 8'b11111110;    //*******
            11'h53b: data = 8'b00000000;    //
            11'h53c: data = 8'b00000000;    //
            11'h53d: data = 8'b00000000;    //
            11'h53e: data = 8'b00000000;    //
            11'h53f: data = 8'b00000000;    //
			       
        default: data = 8'b00000000; // Ĭ��ֵ
    endcase
end
endmodule

