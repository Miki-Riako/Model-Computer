module ALU (
    input wire [7:0] OPCODE, // 8位操作码
    input wire [7:0] INPUT1, // 第一个输入
    input wire [7:0] INPUT2, // 第二个输入
    output reg [7:0] OUTPUT  // 结果输出
);

always @(*) begin
    if (OPCODE[5] == 0) begin
        case (OPCODE[2:0])
            3'b000:  OUTPUT = INPUT1 + INPUT2;  // 加法
            3'b001:  OUTPUT = INPUT1 - INPUT2;  // 减法
            3'b010:  OUTPUT = INPUT1 & INPUT2;  // 按位与
            3'b011:  OUTPUT = INPUT1 | INPUT2;  // 按位或
            3'b100:  OUTPUT = ~INPUT1;          // 按位非
            3'b101:  OUTPUT = INPUT1 ^ INPUT2;  // 按位异或
            default: OUTPUT = 8'b0;             // 默认情况
        endcase
    end else begin
        OUTPUT = 8'bz;
    end
end
endmodule
