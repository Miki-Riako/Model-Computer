module CPU (
    input wire clk,     // 时钟信号
    input wire res,     // 复位信号
    input wire [7:0] I, // I
    output reg [7:0] O, // O
    output reg IEnable, // I使能信号
    output reg OEnable, // O使能信号
    output reg [7:0] O_monitor_signal
);
    wire [7:0] OPBUS1, OPBUS2, OPBUS3, OPBUS4;    // 机器码
    wire imm1, imm2, notImm1, notImm2, condition; // OPBUS1解码
    wire [7:0] dOPBUS2, dOPBUS3, dOPBUS4;         // OPBUS2~4解码
    assign notImm1 = ~imm1;
    assign notImm2 = ~imm2;
    wire conditionBool;                           // 条件判断信号
    
    reg [7:0] AUGBUS1, AUGBUS2, ADDRBUS; // 参数总线1，参数总线2，地址总线
    // wire [2:0] copy_dest;             // 复制目标寄存器
    // wire [2:0] copy_source;           // 被复制的寄存器
    // assign copy_dest   = opcodeBUS[2:0]; // 复制目标寄存器
    // assign copy_source = opcodeBUS[5:3]; // 被复制的寄存器
    // wire [7:0] dataBUS;    // 数据总线

    // wire [7:0] a, b;         // ALU输入
    // wire judgeVal;           // 条件判断输出
    always @(res) begin
        if (res) begin
            O <= 8'b00000000;
            IEnable <= 0;
            OEnable <= 0;
        end
    end
    always @(posedge clk or posedge res) begin
        IEnable <= dOPBUS2[7] | dOPBUS3[7];
        AUGBUS1 <= (dOPBUS2[7] ? I : 8'bzzzzzzzz);
        AUGBUS2 <= (dOPBUS3[7] ? I : 8'bzzzzzzzz);
    end
    always @(posedge clk or posedge res) begin
        OEnable <= dOPBUS4[7];
        O <= (dOPBUS4[7] ? ADDRBUS : 8'bzzzzzzzz);
    end
    always @(posedge clk or posedge res) begin
        AUGBUS1 <= (imm1 ? OPBUS2 : 8'bzzzzzzzz);
        AUGBUS2 <= (imm2 ? OPBUS3 : 8'bzzzzzzzz);
    end

    DEC dec (
        .OPCODE(OPBUS1),
        .IMMEDIATE1(imm1),
        .IMMEDIATE2(imm2),
        .CONDITION(condition)
    );
    COND cond (
        .CONDITION(OPBUS1),
        .INPUT1(AUGBUS1),
        .INPUT2(AUGBUS2),
        .OUTPUT(conditionBool)
    );
    ALU alu (
        .OPCODE(OPBUS1),
        .INPUT1(AUGBUS1),
        .INPUT2(AUGBUS2),
        .OUTPUT(ADDRBUS)
    );
    registerPlus reg0 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[0] & notImm1),
        .load2_enable(dOPBUS3[0] & notImm2),
        .save_enable(dOPBUS4[0]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    registerPlus reg1 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[1] & notImm1),
        .load2_enable(dOPBUS3[1] & notImm2),
        .save_enable(dOPBUS4[1]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    registerPlus reg2 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[2] & notImm1),
        .load2_enable(dOPBUS3[2] & notImm2),
        .save_enable(dOPBUS4[2]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    registerPlus reg3 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[3] & notImm1),
        .load2_enable(dOPBUS3[3] & notImm2),
        .save_enable(dOPBUS4[3]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    registerPlus reg4 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[4] & notImm1),
        .load2_enable(dOPBUS3[4] & notImm2),
        .save_enable(dOPBUS4[4]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    registerPlus reg5 (
        .clk(clk),
        .res(res),
        .load1_enable(dOPBUS2[5] & notImm1),
        .load2_enable(dOPBUS3[5] & notImm2),
        .save_enable(dOPBUS4[5]),
        .save_byte(ADDRBUS),
        .tri1_output(AUGBUS1),
        .tri2_output(AUGBUS2),
        .monitor_signal()
    );
    // RAM program (
    //     .clk(clk),
    //     .res(res),
    //     .current_opcode(),
    //     .monitor_inputs0(),
    //     .monitor_inputs1(),
    //     .monitor_inputs2(),
    //     .monitor_inputs3(),
    //     .monitor_inputs4(),
    //     .monitor_inputs5(),
    //     .monitor_inputs6(),
    //     .monitor_inputs7(),
    //     .monitor_outputs0(),
    //     .monitor_outputs1(),
    //     .monitor_outputs2(),
    //     .monitor_outputs3(),
    //     .monitor_outputs4(),
    //     .monitor_outputs5(),
    //     .monitor_outputs6(),
    //     .monitor_outputs7()
    // );
    decoder d2(
        .A(OPBUS2),
        .Y(dOPBUS2)
    );
    decoder d3(
        .A(OPBUS3),
        .Y(dOPBUS3)
    );
    decoder d4(
        .A(OPBUS4),
        .Y(dOPBUS4)
    );
endmodule
