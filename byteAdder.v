module byteAdder (
    input wire cin,            // 进位输入
    input wire  [7:0] din_a,   // 第一个8位输入
    input wire  [7:0] din_b,   // 第二个8位输入
    output wire [7:0] sum,     // 8位和输出
    output wire cout           // 溢出进位输出
);
wire [7:0] G;
wire [7:0] P;
wire [7:0] C;
assign G[0]   = din_a[0] & din_b[0]; //bit 0
assign P[0]   = din_a[0] | din_b[0];
assign C[0]   = cin;
assign sum[0] = G[0] ^ P[0] ^ C[0];
assign G[1]   = din_a[1] & din_b[1]; //bit 1
assign P[1]   = din_a[1] | din_b[1];
assign C[1]   = G[0] | (P[0] & cin);
assign sum[1] = G[1] ^ P[1] ^ C[1];
assign G[2]   = din_a[2] & din_b[2]; //bit 2
assign P[2]   = din_a[2] | din_b[2];
assign C[2]   = G[1] | (P[1] & C[1]);
assign sum[2] = G[2] ^ P[2] ^ C[2];
assign G[3]   = din_a[3] & din_b[3]; //bit 3
assign P[3]   = din_a[3] | din_b[3];
assign C[3]   = G[2] | (P[2] & C[2]);
assign sum[3] = G[3] ^ P[3] ^ C[3];
assign G[4]   = din_a[4] & din_b[4]; //bit 4
assign P[4]   = din_a[4] | din_b[4];
assign C[4]   = G[3] | (P[3] & C[3]);
assign sum[4] = G[4] ^ P[4] ^ C[4];
assign G[5]   = din_a[5] & din_b[5]; //bit 5
assign P[5]   = din_a[5] | din_b[5];
assign C[5]   = G[4] | (P[4] & C[4]);
assign sum[5] = G[5] ^ P[5] ^ C[5];
assign G[6]   = din_a[6] & din_b[6]; //bit 6
assign P[6]   = din_a[6] | din_b[6];
assign C[6]   = G[5] | (P[5] & C[5]);
assign sum[6] = G[6] ^ P[6] ^ C[6];
assign G[7]   = din_a[7] & din_b[7]; //bit 7
assign P[7]   = din_a[7] | din_b[7];
assign C[7]   = G[6] | (P[6] & C[6]);
assign sum[7] = G[7] ^ P[7] ^ C[7];
assign cout   = G[7] | (P[7] & C[7]);
endmodule
