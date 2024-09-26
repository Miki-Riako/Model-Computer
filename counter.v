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
reg running;

always @(posedge clk or posedge rst or posedge NEXT or posedge RUN or posedge SPEEDRUN) begin
    if (rst) begin
        count <= 8'b00000000;
        monitor_signal <= 8'b00000000;
        div_counter <= 26'd0;
        running <= 1'b0;
    end else if (NEXT) begin
        if (mode) begin
            count <= value;
            monitor_signal <= value;
        end else begin
            count <= count + STEP;
            monitor_signal <= monitor_signal + STEP;
        end
    end else if (RUN | SPEEDRUN) begin
        running <= 1'b1;
    end else begin
        if (ENABLE) begin
            running <= 1'b0;
        end
        if (mode) begin
            count <= value;
            monitor_signal <= value;
        end else if (running) begin
            // Divider to 50,000,000 times or less, 1s or 0.01s perline
            if (div_counter == (SPEEDRUN ? 26'd499999 : 26'd49999999)) begin
                div_counter <= 26'd0;
                if (~mode) begin
                    count <= count + STEP;
                    monitor_signal <= monitor_signal + STEP;
                end
            end else begin
                div_counter <= div_counter + 1;
            end
        end
    end
end
endmodule
