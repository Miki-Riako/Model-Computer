module COND (
    input  wire [7:0] cond,    // 条件
    input  wire [7:0] condVal, // 输入
    output reg  judgeVal       // 条件输出
);

wire zeroflag;
wire negativeflag;
assign zeroflag = cond[0] & ~(|condVal);
assign negativeflag = cond[1] & condVal[7];

always @(*) begin
    judgeVal = cond[2] ^ (zeroflag | negativeflag);
end
endmodule
