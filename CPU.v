module CPU (
    input wire SPEED,
    input wire clk,     // 时钟信号
    input wire rst,     // 复位信号
    input wire [7:0] I, // I
    output reg [7:0] O, // O
    output reg IEnable, // I使能信号
    output reg OEnable, // O使能信号
    output reg [7:0] O_monitor_signal
);
/** 机器码, 参数码, 地址码
OPBUS1: OPBUS[7:0]    -> 机器码操作码
OPBUS2: OPBUS[15:8]   -> 机器码参数1
OPBUS3: OPBUS[23:16]  -> 机器码参数2
OPBUS4: OPBUS[31:24]  -> 机器码结果地址
ARGBUS1: ARGBUS[7:0]  -> 参数码参数1
ARGBUS2: ARGBUS[15:8] -> 参数码参数2
ADDRBUS               -> 地址码
**/
wire [31:0] OPBUS;
wire [15:0] ARGBUS;
wire [7:0]  ADDRBUS;
wire imm1, imm2, condition;           // OPBUS1解码
wire [7:0] dOPBUS2, dOPBUS3, dOPBUS4; // OPBUS2~4解码
wire [7:0] cnt;                       // 计数指令数
wire [7:0] writeVal;                  // 待写入计数值
wire conditionBool;                   // 条件判断信号

always @(posedge rst) begin
    if (rst) begin
        O <= 8'b00000000;
        IEnable <= 0;
        OEnable <= 0;
    end
end
always @(posedge clk or posedge rst) begin
    IEnable <= dOPBUS2[7] | dOPBUS3[7];
    OEnable <= dOPBUS4[7];
    O <= (dOPBUS4[7] ? ADDRBUS : 8'bzzzzzzzz);
end
controller control(
    .I(I),
    .opcode2(OPBUS[15:8]),
    .opcode3(OPBUS[23:16]),
    .opcode4(OPBUS[31:24]),
    .imm1(imm1),
    .imm2(imm2),
    .cnt(cnt),
    .counterEnable1(dOPBUS2[6]),
    .counterEnable2(dOPBUS3[6]),
    .counterEnable3(dOPBUS4[6]),
    .inputEnable1(dOPBUS2[7]),
    .inputEnable2(dOPBUS3[7]),
    .conditionEnable(condition),
    .address(ADDRBUS),
    .argument1(ARGBUS[7:0]),
    .argument2(ARGBUS[15:8]),
    .writeVal(writeVal)
);
DEC dec (
    .OPCODE(OPBUS[7:0]),
    .IMMEDIATE1(imm1),
    .IMMEDIATE2(imm2),
    .CONDITION(condition)
);
COND cond (
    .CONDITION(OPBUS[7:0]),
    .INPUT1(ARGBUS[7:0]),
    .INPUT2(ARGBUS[15:8]),
    .OUTPUT(conditionBool)
);
ALU alu (
    .OPCODE(OPBUS[7:0]),
    .INPUT1(ARGBUS[7:0]),
    .INPUT2(ARGBUS[15:8]),
    .OUTPUT(ADDRBUS)
);
registerPlus reg0 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[0] & ~imm1),
    .load2_enable(dOPBUS3[0] & ~imm2),
    .save_enable(dOPBUS4[0]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
registerPlus reg1 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[1] & ~imm1),
    .load2_enable(dOPBUS3[1] & ~imm2),
    .save_enable(dOPBUS4[1]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
registerPlus reg2 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[2] & ~imm1),
    .load2_enable(dOPBUS3[2] & ~imm2),
    .save_enable(dOPBUS4[2]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
registerPlus reg3 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[3] & ~imm1),
    .load2_enable(dOPBUS3[3] & ~imm2),
    .save_enable(dOPBUS4[3]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
registerPlus reg4 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[4] & ~imm1),
    .load2_enable(dOPBUS3[4] & ~imm2),
    .save_enable(dOPBUS4[4]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
registerPlus reg5 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[5] & ~imm1),
    .load2_enable(dOPBUS3[5] & ~imm2),
    .save_enable(dOPBUS4[5]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .monitor_signal()
);
counter count (
    .STEP(8'b00000100),
    .SPEED(SPEED),
    .clk(clk),
    .rst(rst),
    .mode(conditionBool | dOPBUS4[6]),
    .value(O),
    .count(cnt),
    .monitor_signal()
    );
decoder d2(
    .A(OPBUS[15:8]),
    .Y(dOPBUS2)
);
decoder d3(
    .A(OPBUS[23:16]),
    .Y(dOPBUS3)
);
decoder d4(
    .A(OPBUS[31:24]),
    .Y(dOPBUS4)
);
// RAM program (
// ...
// );
endmodule
