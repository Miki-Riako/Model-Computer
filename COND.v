module COND (
    input wire [7:0] CONDITION, // 条件
    input wire [7:0] INPUT1,    // 第一个输入
    input wire [7:0] INPUT2,    // 第二个输入
    output reg OUTPUT           // 输出比较结果
);

always @(*) begin
    if (CONDITION[5]) begin
        case (CONDITION[2:0])
            3'b000:  OUTPUT = (INPUT1 == INPUT2); // 等于
            3'b001:  OUTPUT = (INPUT1 != INPUT2); // 不等于
            3'b010:  OUTPUT = (INPUT1 <  INPUT2); // 小于
            3'b011:  OUTPUT = (INPUT1 <= INPUT2); // 小于等于
            3'b100:  OUTPUT = (INPUT1 >  INPUT2); // 大于
            3'b101:  OUTPUT = (INPUT1 >= INPUT2); // 大于等于
            default: OUTPUT = 1'b0;               // 默认情况
        endcase
    end else begin
        OUTPUT = 1'bz;
    end
end
endmodule
