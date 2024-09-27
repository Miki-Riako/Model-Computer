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
reg speed;
reg running;
reg isNext;

always @(posedge clk or posedge rst or posedge NEXT or posedge RUN or posedge SPEEDRUN) begin
    if (rst) begin
        count <= 8'b00000000;
        monitor_signal <= 8'b00000000;
        running <= 1'b0;
        speed <= 1'b0;
        div_counter <= 26'd0;
    end else if (NEXT) begin
        isNext  <= 1'b1;
    end else if (RUN) begin
        running <= 1'b1;
        speed <= 1'b0;
    end else if (SPEEDRUN) begin
        running <= 1'b1;
        speed <= 1'b1;
    end else if (ENABLE) begin
        running <= 1'b0;
    end else if (running) begin
        if (div_counter == (speed ? 26'd499999 : 26'd49999999)) begin
            count          <= mode ? value : (count + STEP);
            monitor_signal <= mode ? value : (monitor_signal + STEP);
            if (isNext) begin
                running <= 1'b0;
                isNext  <= 1'b0;
            end
            div_counter <= 26'd0;
        end else begin
            div_counter <= div_counter + 1;
        end
    end
end
endmodule
