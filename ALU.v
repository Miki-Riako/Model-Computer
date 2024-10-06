module ALU (
    input wire [7:0] OPCODE, // 8位操作码
    input wire [7:0] INPUT1, // 第一个输入
    input wire [7:0] INPUT2, // 第二个输入
    output reg [7:0] OUTPUT  // 结果输出
);

always @(*) begin
    if (OPCODE[5] == 0) begin
        case (OPCODE[3:0])
            4'b0000: OUTPUT = INPUT1 + INPUT2;                                 // 加法
            4'b0001: OUTPUT = INPUT1 - INPUT2;                                 // 减法
            4'b0010: OUTPUT = INPUT1 & INPUT2;                                 // 按位与
            4'b0011: OUTPUT = INPUT1 | INPUT2;                                 // 按位或
            4'b0100: OUTPUT = ~INPUT1;                                         // 按位非
            4'b0101: OUTPUT = INPUT1 ^ INPUT2;                                 // 按位异或
            4'b0110: OUTPUT = INPUT1 << INPUT2;                                // 左移
            4'b0111: OUTPUT = INPUT1 >> INPUT2;                                // 右移
            4'b1000: OUTPUT = (INPUT1[3:0] * INPUT2[3:0]);                     // 半字节乘法
            4'b1001: OUTPUT = (INPUT2 != 0) ? (INPUT1 / INPUT2) : 8'b00000000; // 除法商
            4'b1010: OUTPUT = (INPUT2 != 0) ? (INPUT1 % INPUT2) : 8'b00000000; // 除法余数
            default: OUTPUT = 8'b00000000;                                     // 默认情况
        endcase
    end else begin
        OUTPUT = 8'bzzzzzzzz;
    end
end
endmodule
