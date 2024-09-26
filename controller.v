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
    argument1 = 8'bzzzzzzzz;
    argument2 = 8'bzzzzzzzz;
    cntInput  = 8'bzzzzzzzz;
    if (imm1) begin
        argument1 = opcode2;
    end else if (counterEnable1) begin
        argument1 = cntOutput;
    end else if (inputEnable1) begin
        argument1 = I;
    end else if (ramEnable1) begin
        argument1 = ramOutput;
    end else if (stackEnable1) begin
        argument1 = stackOutput;
    end
    if (imm2) begin
        argument2 = opcode3;
    end else if (counterEnable2) begin
        argument2 = cntOutput;
    end else if (inputEnable2) begin
        argument2 = I;
    end else if (ramEnable2) begin
        argument2 = ramOutput;
    end else if (stackEnable2) begin
        argument2 = stackOutput;
    end
    if (counterEnable3) begin
        cntInput = address;
    end else if (condition) begin
        cntInput = (isRet ? stackOutput : opcode4);
    end
end
endmodule
