module registerPlus (
    input wire clk,
    input wire res,
    input wire load_enable,           // 加载输入使能信号
    input wire save_enable,           // 保存输入使能信号
    input wire [7:0] save_byte,       // 待保存的八位信号
    output reg [7:0] tri_output,      // 三态输出
    output reg [7:0] constant_output, // 始终输出
    output reg [7:0] monitor_signal   // 用于监视寄存器值
);

reg [7:0] internal_register; // 内部寄存器

always @(posedge clk or posedge res) begin
    if (res) begin
        internal_register <= 8'b00000000;
    end else if (save_enable) begin
        internal_register <= save_byte;
    end
end

always @(*) begin
    if (load_enable) begin
        tri_output = internal_register;
    end else begin
        tri_output = 8'bzzzzzzzz;
    end
end

always @(*) begin
    constant_output = internal_register;
    monitor_signal = internal_register;
end
endmodule
