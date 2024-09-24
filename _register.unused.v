module register (
    input wire clk,
    input wire res,
    input wire read_enable,        // 读取使能信号
    input wire write_enable,       // 写入使能信号
    input wire [7:0] d,            // 待写入的八位信号
    output reg [7:0] q             // 数据输出
);

reg [7:0] internal_register;

always @(posedge clk or posedge res) begin
    if (res) begin
        internal_register <= 8'b00000000;
    end else if (write_enable) begin
        internal_register <= d;
    end
end

always @(*) begin
    if (read_enable) begin
        q <= internal_register;
    end else begin
        q <= 8'bzzzzzzzz;
    end
end
endmodule
