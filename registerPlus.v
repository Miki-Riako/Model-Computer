module registerPlus (
    input wire clk,
    input wire rst,
    input wire load1_enable,           // 1口加载输入使能
    input wire load2_enable,           // 2口加载输入使能
    input wire save_enable,            // 保存输入使能
    input wire [7:0] save_byte,        // 待保存的八位
    output wire [7:0] tri1_output,     // 1口三态输出
    output wire [7:0] tri2_output,     // 2口三态输出
    output wire [7:0] constant_output, // 始终输出
    output wire [7:0] monitor_signal   // 用于监视寄存器值
);

reg [7:0] internal_register; // 内部寄存器

assign tri1_output = load1_enable ? internal_register : 8'bzzzzzzzz;
assign tri2_output = load2_enable ? internal_register : 8'bzzzzzzzz;
assign constant_output = internal_register;
assign monitor_signal = internal_register;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        internal_register <= 8'b00000000;
    end else if (save_enable) begin
        internal_register <= save_byte;
    end
end
endmodule
