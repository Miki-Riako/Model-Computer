module CPU (
    input  wire clk,     // 时钟信号
    input  wire switch,  // 控制信号
    input  wire [7:0] i, // I
    output wire [7:0] o, // O
    output wire [7:0] o_monitor_signal
);
    wire [7:0] opcodeBUS;       // 从PROGRAM获取的当前机器码

    wire [2:0] copy_dest;             // 复制目标寄存器
    wire [2:0] copy_source;           // 被复制的寄存器
    assign copy_dest   = opcodeBUS[2:0]; // 复制目标寄存器
    assign copy_source = opcodeBUS[5:3]; // 被复制的寄存器
    wire immediate, calculation, copy, condition; // 解码信号
    wire [7:0] BUS; // 总线

    wire [7:0] a, b;         // ALU输入
    wire judgeVal;           // 条件判断输出

    DEC dec (
        .opcode(opcodeBUS),
        .immediate(immediate),
        .calculation(calculation),
        .copy(copy),
        .condition(condition)
    );
    ALU alu (
        .opcode(opcodeBUS),
        .a(a),
        .b(b),
        .res(result)
    );
    COND cond (
        .cond(opcodeBUS),
        .condVal(result),
        .judgeVal(judgeVal)
    );
    registerPlus reg0 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .constant_output(),
        .monitor_signal()
    );
    registerPlus reg1 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .constant_output(),
        .monitor_signal()
    );
    registerPlus reg2 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .constant_output(),
        .monitor_signal()
    );
    registerPlus reg3 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .constant_output(),
        .monitor_signal()
    );
    registerPlus reg4 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .monitor_signal()
    );
    registerPlus reg5 (
        .clk(clk),
        .res(res),
        .load_enable(),
        .save_enable(),
        .save_byte(),
        .tri_output(),
        .monitor_signal()
    );
    RAM program (
        .clk(clk),
        .current_opcode(opcodeBUS),
        .monitor_inputs0(),
        .monitor_inputs1(),
        .monitor_inputs2(),
        .monitor_inputs3(),
        .monitor_inputs4(),
        .monitor_inputs5(),
        .monitor_inputs6(),
        .monitor_inputs7(),
        .monitor_outputs0(),
        .monitor_outputs1(),
        .monitor_outputs2(),
        .monitor_outputs3(),
        .monitor_outputs4(),
        .monitor_outputs5(),
        .monitor_outputs6(),
        .monitor_outputs7()
    );
endmodule
