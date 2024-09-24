module ALU (
    input wire [7:0] opcode, // 操作码
    input wire [7:0] a,      // 输入
    input wire [7:0] b,      // 输入
    output reg [7:0] res     // 运算结果
);

always @(*) begin
    case (opcode[2:0])
        3'b000:  res = a | b;          // OR
        3'b001:  res = ~(a & b);       // NAND
        3'b010:  res = ~(a | b);       // NOR
        3'b011:  res = a & b;          // AND
        3'b100:  res = a + b;          // ADD
        3'b101:  res = a - b;          // SUB
        default: res = 8'b00000000;    // ???
    endcase
end
endmodule
