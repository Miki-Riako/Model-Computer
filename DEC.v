module DEC (
    input wire [7:0] opcode, // 八位输入机器码
    output reg immediate,    // 输出：Immediate
    output reg calculation,  // 输出：Calculation
    output reg copy,         // 输出：Copy
    output reg condition     // 输出：Condition
);

always @(*) begin
    immediate   = 1'b0;
    calculation = 1'b0;
    copy        = 1'b0;
    condition   = 1'b0;
    case (opcode[7:6])
        2'b00: immediate   = 1'b1;
        2'b01: calculation = 1'b1;
        2'b10: copy        = 1'b1;
        2'b11: condition   = 1'b1;
        default: ;
    endcase
end
endmodule
