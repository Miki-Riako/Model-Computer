module counter (
    input wire [7:0] STEP,
    input wire ENABLE,
    input wire clk,
    input wire rst,
    input wire NEXT,
    input wire RUN,
    input wire SPEEDRUN,
    input wire mode,
    input wire [7:0] value,
    output reg [7:0] count,
    output reg [7:0] monitor_signal
);
reg [25:0] div_counter;
reg clk_out;
reg speed;
reg running;

always @(posedge clk or posedge rst) begin
    // Divider to 50,000,000 times or less, 1s or 0.01s perline
    if (rst) begin
        div_counter <= 26'd0;
        clk_out     <= 1'b0;
    end else if (div_counter == (speed ? 26'd249999 : 26'd24999999)) begin
        div_counter <= 26'd0;
        clk_out <= ~clk_out;
    end else begin
        div_counter <= div_counter + 1;
    end
end
always @(posedge clk_out or posedge rst or posedge NEXT or posedge RUN or posedge SPEEDRUN) begin
    if (rst) begin
        count <= 8'b00000000;
        monitor_signal <= 8'b00000000;
        running <= 1'b0;
        speed <= 1'b0;
    end else if (NEXT) begin
        count          <= mode ? value : (count + STEP);
        monitor_signal <= mode ? value : (monitor_signal + STEP);
    end else if (RUN) begin
        running <= 1'b1;
        speed <= 1'b0;
    end else if (SPEEDRUN) begin
        running <= 1'b1;
        speed <= 1'b1;
    end else if (ENABLE) begin
        running <= 1'b0;
    end else if (running) begin
        count          <= mode ? value : (count + STEP);
        monitor_signal <= mode ? value : (monitor_signal + STEP);
    end
end
endmodule
