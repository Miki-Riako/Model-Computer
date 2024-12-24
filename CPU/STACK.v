module STACK(
    input wire clk,
    input wire rst,
    input wire POP,
    input wire PUSH,
    input wire [7:0] VALUE,
    output wire [7:0] OUTPUT
);
reg  [7:0] sp;   // 堆栈指针
wire [7:0] addr; // RAM 地址
wire [7:0] out;  // 从 RAM 读取的数据

assign addr = POP ? sp - 8'd1 : sp;
assign OUTPUT = (~PUSH & POP & (sp != 0)) ? out : 8'bzzzzzzzz;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sp <= 8'b00000000;
    end else begin
        if (PUSH & ~POP) begin
            sp <= sp + 1; // 增加堆栈指针
        end else if (~PUSH & POP) begin
            if (sp != 0) begin
                sp <= sp - 1; // 减少堆栈指针
            end
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
