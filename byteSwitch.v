module ByteSwitch (
    input  wire enable,
    input  wire [7:0] input_signal,
    output wire [7:0] output_signal
);

assign output_signal = enable ? input_signal : 8'bzzzzzzzz;
endmodule
