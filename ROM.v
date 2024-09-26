module ROM (
    input wire clk,                     // 时钟信号
    input wire rst,                     // 复位信号
    input wire [7:0] address,           // 地址输入
    output reg [31:0] opcode           // 当前输出的机器码
);
reg [7:0] memory [0:255];               // 16*16 = 256个8位机器码

// TODO
initial begin // 这是ROM
    // 预置一些机器码，作为初代版本
    memory[0] = 8'b00000001; // 示例机器码
    memory[1] = 8'b00000010; // 示例机器码
    memory[2] = 8'b00000011; // 示例机器码
    memory[3] = 8'b00000100; // 示例机器码
    // 可以继续填充其他机器码，直到memory[255]
end
always @(posedge clk) begin
    if (rst) begin
        opcode <= 32'b0;
    end else begin
        opcode <= {memory[(address+3)%256], memory[(address+2)%256], memory[(address+1)%256], memory[address]};
    end
end
always @(posedge clk) begin

end
endmodule