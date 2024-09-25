module Switch (
    input  wire enable,
    input  wire input_signal,
    output wire output_signal
);

assign output_signal = enable ? input_signal : 1'bz;
endmodule
