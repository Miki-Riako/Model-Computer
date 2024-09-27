module CPU (
    input wire clk,           // 时钟信号
    input wire rstROM,        // ROM复位信号
    input wire rst,           // 复位信号
    input wire NEXT,          // 下一条指令
    input wire RUN,           // 运行
    input wire SPEEDRUN,      // 快速运行
    input wire edit,          // 编程模式信号
    input wire [7:0] unit,    // 代码位置
    input wire [7:0] code,    // 代码
    input wire send,          // 发送程序信号
    input wire [1:0] program, // 示例程序
    input wire [7:0] I,       // I
    output reg [7:0] O,       // O
    output reg IEnable,       // I使能信号
    output reg OEnable,       // O使能信号

    output wire [7:0] reg0_monitor_signal,    // 监视输出REG0
    output wire [7:0] reg1_monitor_signal,    // 监视输出REG1
    output wire [7:0] reg2_monitor_signal,    // 监视输出REG2
    output wire [7:0] reg3_monitor_signal,    // 监视输出REG3
    output wire [7:0] reg4_monitor_signal,    // 监视输出REG4
    output wire [7:0] reg5_monitor_signal,    // 监视输出REG5
    output wire [7:0] counter_monitor_signal, // 监视输出COUNTER
    output reg  [7:0] O_monitor_signal        // 监视输出OUTPUT
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
wire imm1, imm2, condition, isCall, isRet, isHalt; // OPBUS1解码
wire [15:0] dOPBUS2, dOPBUS3, dOPBUS4;             // OPBUS2~4解码
wire [7:0] cntInput, cntOutput;                    // 计数指令数
wire [7:0] ramAddr, ramOutput;                     // RAM读写
wire [7:0] stackInput, stackOutput;                // 栈读写
wire conditionOutput;                              // 条件判断信号

assign isCall = (OPBUS[7:0] == 8'b0011000);
assign isRet  = (OPBUS[7:0] == 8'b0011001);
assign isHalt = (OPBUS[7:0] == 8'b0011010);
assign stackInput = isCall ? cntOutput + 8'b00000100 : ADDRBUS;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        O <= 8'b00000000;
        IEnable <= 0;
        OEnable <= 0;
    end else begin
        IEnable <= dOPBUS2[7] | dOPBUS3[7];
        OEnable <= dOPBUS4[7];
        O                <= (dOPBUS4[7] ? ADDRBUS : 8'b00000000);
        O_monitor_signal <= (dOPBUS4[7] ? ADDRBUS : 8'b00000000);
    end
end
controller control(
    .I(I),
    .opcode2(OPBUS[15:8]),
    .opcode3(OPBUS[23:16]),
    .opcode4(OPBUS[31:24]),
    .imm1(imm1),
    .imm2(imm2),
    .condition(condition),
    .isRet(isRet),
    .cntOutput(cntOutput),
    .counterEnable1(dOPBUS2[6]),
    .counterEnable2(dOPBUS3[6]),
    .counterEnable3(dOPBUS4[6]),
    .inputEnable1(dOPBUS2[7]),
    .inputEnable2(dOPBUS3[7]),
    .address(ADDRBUS),
    .ramEnable1(dOPBUS2[8]),
    .ramEnable2(dOPBUS2[8]),
    .ramOutput(ramOutput),
    .stackEnable1(dOPBUS2[10]),
    .stackEnable2(dOPBUS3[10]),
    .stackOutput(stackOutput),
    .argument1(ARGBUS[7:0]),
    .argument2(ARGBUS[15:8]),
    .cntInput(cntInput)
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
    .OUTPUT(conditionOutput)
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
    .load1_enable(dOPBUS2[0]),
    .load2_enable(dOPBUS3[0]),
    .save_enable(dOPBUS4[0]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg0_monitor_signal)
);
registerPlus reg1 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[1]),
    .load2_enable(dOPBUS3[1]),
    .save_enable(dOPBUS4[1]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg1_monitor_signal)
);
registerPlus reg2 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[2]),
    .load2_enable(dOPBUS3[2]),
    .save_enable(dOPBUS4[2]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg2_monitor_signal)
);
registerPlus reg3 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[3]),
    .load2_enable(dOPBUS3[3]),
    .save_enable(dOPBUS4[3]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg3_monitor_signal)
);
registerPlus reg4 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[4]),
    .load2_enable(dOPBUS3[4]),
    .save_enable(dOPBUS4[4]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg4_monitor_signal)
);
registerPlus reg5 (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[5]),
    .load2_enable(dOPBUS3[5]),
    .save_enable(dOPBUS4[5]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(),
    .monitor_signal(reg5_monitor_signal)
);
STACK stack(
    .clk(clk),
    .rst(rst),
    .POP(dOPBUS2[10] | dOPBUS3[10] | isRet),
    .PUSH(dOPBUS4[10] | isCall),
    .VALUE(stackInput),
    .OUTPUT(stackOutput)
);
registerPlus reg_ram (
    .clk(clk),
    .rst(rst),
    .load1_enable(dOPBUS2[9]),
    .load2_enable(dOPBUS3[9]),
    .save_enable(dOPBUS4[9]),
    .save_byte(ADDRBUS),
    .tri1_output(ARGBUS[7:0]),
    .tri2_output(ARGBUS[15:8]),
    .constant_output(ramAddr),
    .monitor_signal()
);
RAM ram(
    .clk(clk),
    .rst(rst),
    .read(dOPBUS2[8] | dOPBUS3[8]),
    .write(dOPBUS4[8]),
    .address(ramAddr),
    .data(ADDRBUS),
    .out(ramOutput)
);
ROM rom (
    .edit(edit),
    .unit(unit),
    .code(code),
    .send(send),
    .program(program),
    .clk(clk),
    .rst(rstROM),
    .address(cntOutput),
    .opcode(OPBUS)
);
counter count (
    .STEP(8'b00000100),
    .ENABLE(isHalt),
    .clk(clk),
    .rst(rst),
    .NEXT(NEXT),
    .RUN(RUN),
    .SPEEDRUN(SPEEDRUN),
    .mode(conditionOutput | isCall | isRet | dOPBUS4[6]),
    .value(cntInput),
    .count(cntOutput),
    .monitor_signal(counter_monitor_signal)
    );
decoder d2_1(
    .enable(imm1 | OPBUS[12]),
    .A(OPBUS[15:8]),
    .Y(dOPBUS2[7:0])
);
decoder d2_2(
    .enable(imm1 | ~OPBUS[12]),
    .A(OPBUS[15:8]),
    .Y(dOPBUS2[15:8])
);
decoder d3_1(
    .enable(imm2 | OPBUS[20]),
    .A(OPBUS[23:16]),
    .Y(dOPBUS3[7:0])
);
decoder d3_2(
    .enable(imm2 | ~OPBUS[20]),
    .A(OPBUS[23:16]),
    .Y(dOPBUS3[15:8])
);
decoder d4_1(
    .enable(condition | OPBUS[28]),
    .A(OPBUS[31:24]),
    .Y(dOPBUS4[7:0])
);
decoder d4_2(
    .enable(condition | ~OPBUS[28]),
    .A(OPBUS[31:24]),
    .Y(dOPBUS4[15:8])
);
endmodule
