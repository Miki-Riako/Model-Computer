module DEC (
    input wire [7:0] OPCODE, // 机器码
    output wire IMMEDIATE1,   // Immediate1
    output wire IMMEDIATE2,   // Immediate2
    output wire CONDITION     // Condition
);

assign IMMEDIATE1 = OPCODE[7];
assign IMMEDIATE2 = OPCODE[6];
assign CONDITION  = OPCODE[5];
endmodule
