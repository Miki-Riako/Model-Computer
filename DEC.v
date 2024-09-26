module DEC (
    input wire [7:0] OPCODE, // 机器码
    output reg IMMEDIATE1,   // Immediate1
    output reg IMMEDIATE2,   // Immediate2
    output reg CONDITION     // Condition
);

always @(*) begin
    IMMEDIATE1 = OPCODE[7];
    IMMEDIATE2 = OPCODE[6];
    CONDITION  = OPCODE[5];
end
endmodule
