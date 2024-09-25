module DEC (
    input wire [7:0] OPCODE, // 八位输入机器码
    output reg IMMEDIATE1,   // 输出：Immediate1
    output reg IMMEDIATE2,   // 输出：Immediate2
    output reg CONDITION     // 输出：Condition
);

always @(*) begin
    IMMEDIATE1 = OPCODE[7];
    IMMEDIATE2 = OPCODE[6];
    CONDITION  = OPCODE[5];
end
endmodule
