module COND (
    input wire [7:0] CONDITION, // 条件
    input wire [7:0] INPUT1,    // 第一个输入
    input wire [7:0] INPUT2,    // 第二个输入
    output reg OUTPUT           // 输出比较结果
);

always @(*) begin
    if (CONDITION[5]) begin
        case (CONDITION[4:0])
            5'b00000: OUTPUT = (INPUT1 == INPUT2);                 // 等于
            5'b00001: OUTPUT = (INPUT1 != INPUT2);                 // 不等于
            5'b00010: OUTPUT = ({1'b0, INPUT1} <  {1'b0, INPUT2}); // （无符号）小于
            5'b00011: OUTPUT = ({1'b0, INPUT1} <= {1'b0, INPUT2}); // （无符号）小于等于
            5'b00100: OUTPUT = ({1'b0, INPUT1} >  {1'b0, INPUT2}); // （无符号）大于
            5'b00101: OUTPUT = ({1'b0, INPUT1} >= {1'b0, INPUT2}); // （无符号）大于等于
            default:  OUTPUT = 1'b0;                               // 默认情况
        endcase
    end else begin
        OUTPUT = 1'bz;
    end
end
endmodule
