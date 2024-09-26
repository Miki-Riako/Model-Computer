module STACK(
    input wire clk,
    input wire rst,
    input wire POP,
    input wire PUSH,
    input wire [7:0] VALUE,
    output reg [7:0] OUTPUT
);
reg  [7:0] sp;   // 堆栈指针
reg  [7:0] addr; // RAM 地址
wire [7:0] out;  // 从 RAM 读取的数据

always @(posedge rst) begin
    sp <= 8'b0;
    OUTPUT <= 8'b0;
end

always @(posedge clk or posedge rst) begin
    if (PUSH && !POP) begin
        addr <= sp;            // 将堆栈指针作为地址
        OUTPUT <= 8'bzzzzzzzz; // 三态输出
        sp   <= sp + 1;        // 增加堆栈指针
    end else if (POP && !PUSH) begin
        if (sp > 0) begin
            sp     <= sp - 1; // 减少堆栈指针
            addr   <= sp;     // 设置地址以读取堆栈顶部的值
            OUTPUT <= out;    // 输出堆栈顶部的值
        end else begin
            OUTPUT <= 8'b00000000; // 堆栈为空时输出0
        end
    end
end
RAM ram(
    .clk(clk),
    .rst(rst),
    .read(POP),
    .write(PUSH),
    .address(addr),
    .data(VALUE),
    .out(out)
);
endmodule
