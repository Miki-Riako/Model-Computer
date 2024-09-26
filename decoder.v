module decoder (
    input wire enable,
    input wire [7:0] A,
    output reg [7:0] Y
);

always @(*) begin
    if (enable) begin
        Y = 8'b00000000;
    end else begin
        case (A[2:0])
            3'b000:  Y = 8'b00000001;
            3'b001:  Y = 8'b00000010;
            3'b010:  Y = 8'b00000100;
            3'b011:  Y = 8'b00001000;
            3'b100:  Y = 8'b00010000;
            3'b101:  Y = 8'b00100000;
            3'b110:  Y = 8'b01000000;
            3'b111:  Y = 8'b10000000;
            default: Y = 8'b00000000;
        endcase
    end
end
endmodule
