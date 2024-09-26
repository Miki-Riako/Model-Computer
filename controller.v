module controller (
    input wire [7:0] I,
    input wire [7:0] opcode2,
    input wire [7:0] opcode3,
    input wire [7:0] opcode4,
    input wire imm1,
    input wire imm2,
    input wire condition,
    input wire isRet,
    input wire [7:0] cntOutput,
    input wire counterEnable1,
    input wire counterEnable2,
    input wire counterEnable3,
    input wire inputEnable1,
    input wire inputEnable2,
    input wire [7:0] address,
    input wire ramEnable1,
    input wire ramEnable2,
    input wire [7:0] ramOutput,
    input wire stackEnable1,
    input wire stackEnable2,
    input wire [7:0] stackOutput,
    output reg [7:0] argument1,
    output reg [7:0] argument2,
    output reg [7:0] cntInput
);

always @(*) begin
    // 立即数
    argument1 <= (imm1 ? opcode2 : 8'bzzzzzzzz);
    argument2 <= (imm2 ? opcode3 : 8'bzzzzzzzz);
    // 计时器地址
    argument1 <= (counterEnable1 ? cntOutput : 8'bzzzzzzzz);
    argument2 <= (counterEnable2 ? cntOutput : 8'bzzzzzzzz);
    // 输出地址
    argument1 <= (inputEnable1 ? I : 8'bzzzzzzzz);
    argument2 <= (inputEnable2 ? I : 8'bzzzzzzzz);
    // Ram输出
    argument1 <= (ramEnable1 ? ramOutput : 8'bzzzzzzzz);
    argument2 <= (ramEnable2 ? ramOutput : 8'bzzzzzzzz);
    // 栈输出
    argument1 <= (stackEnable1 ? stackOutput : 8'bzzzzzzzz);
    argument2 <= (stackEnable2 ? stackOutput : 8'bzzzzzzzz);
    // 程序计数输出
    cntInput  <= (counterEnable3 ? address : 8'bzzzzzzzz);
    cntInput  <= (condition ? (isRet ? stackOutput : opcode4) : 8'bzzzzzzzz);
end
endmodule
