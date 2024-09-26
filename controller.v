module controller (
    input wire [7:0] I,
    input wire [7:0] opcode2,
    input wire [7:0] opcode3,
    input wire [7:0] opcode4,
    input wire imm1,
    input wire imm2,
    input wire [7:0] cnt,
    input wire counterEnable1,
    input wire counterEnable2,
    input wire counterEnable3,
    input wire inputEnable1,
    input wire inputEnable2,
    input wire conditionEnable,
    input wire [7:0] address,
    output reg [7:0] argument1,
    output reg [7:0] argument2,
    output reg [7:0] writeVal
);

// TODO
always @(*) begin
    argument1 <= (imm1 ? opcode2 : 8'bzzzzzzzz);
    argument2 <= (imm2 ? opcode3 : 8'bzzzzzzzz);
    argument1 <= (counterEnable1 ? cnt : 8'bzzzzzzzz);
    argument2 <= (counterEnable2 ? cnt : 8'bzzzzzzzz);
    argument1 <= (inputEnable1 ? I : 8'bzzzzzzzz);
    argument2 <= (inputEnable2 ? I : 8'bzzzzzzzz);
    writeVal  <= (counterEnable3 ? address : 8'bzzzzzzzz);
    writeVal  <= (conditionEnable ? opcode4 : 8'bzzzzzzzz);
end
endmodule
