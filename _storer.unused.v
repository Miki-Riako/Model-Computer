module storer (
    input wire clk,
    input wire res,
    input wire write_enable,   // 写入使能信号
    input wire d,              // 待写入数值
    output reg q               // 数据输出
);

always @(posedge clk or posedge res) begin
    if (res) begin
        q <= 1'b0;
    end else if (write_enable) begin
        q <= d;
    end
end
endmodule
