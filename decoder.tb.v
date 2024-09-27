module decoder_tb;
reg enable;
reg [7:0] A;
wire [7:0] Y;
decoder uut (
    .enable(enable),
    .A(A),
    .Y(Y)
);
initial begin
    $dumpfile("a.vcd");
    $dumpvars(0, decoder_tb);
    enable = 0;
    A = 8'b00000000;
    #10; A = 8'b00000001;
    #10; A = 8'b00000010;
    #10; A = 8'b00000011;
    #10; A = 8'b00000100;
    #10; A = 8'b00001000;
    #10; A = 8'b00001101;
    #10; A = 8'b00010010;
    enable = 1;
    #10; $finish;
end
endmodule
