module ROM (
    input wire clk,           // 时钟信号
    input wire rst,           // 复位信号
    input wire [7:0] address, // 地址输入
    output reg [31:0] opcode  // 当前输出的机器码
);

localparam IMM1 = 8'b10000000;
localparam IMM2 = 8'b01000000;
localparam MOV  = 8'b01000000;
localparam JMP  = 8'b10000000;
localparam PUSH = 8'b01000000;
localparam POP  = 8'b01000000;
localparam TO   = 8'b00000000;
localparam ADD = 8'b00000000;
localparam SUB = 8'b00000001;
localparam AND = 8'b00000010;
localparam OR  = 8'b00000011;
localparam NOT = 8'b00000100;
localparam XOR = 8'b00000101;
localparam SHL = 8'b00000110;
localparam SHR = 8'b00000111;
localparam MUL = 8'b00001000;
localparam DIV = 8'b00001001;
localparam MOD = 8'b00001010;
localparam NULL    = 8'b00000000;
localparam REG0    = 8'b00000000;
localparam REG1    = 8'b00000001;
localparam REG2    = 8'b00000010;
localparam REG3    = 8'b00000011;
localparam REG4    = 8'b00000100;
localparam REG5    = 8'b00000101;
localparam RAM     = 8'b00010000;
localparam REG_RAM = 8'b00010001;
localparam STACK   = 8'b00010010;
localparam COUNTER = 8'b00000110;
localparam INPUT   = 8'b00000111;
localparam OUTPUT  = 8'b00000111;
localparam IF_EQUAL            = 8'b10000000;
localparam IF_NOT_EQUAL        = 8'b10000001;
localparam IF_LESS             = 8'b10000010;
localparam IF_LESS_OR_EQUAL    = 8'b10000011;
localparam IF_GREATER          = 8'b10010000;
localparam IF_GREATER_OR_EQUAL = 8'b10010001;
localparam CALL = 8'b00110000;
localparam RET  = 8'b00110001;
localparam HALT = 8'b00110010;


reg [7:0] memory [0:255];     // 16*16 = 256个8位机器码

// TODO
/**
CONST IO_NUM 32
IMM1|MOV         0           TO          REG_RAM    # REG_RAM置0
# 循环INPUT:
LABEL CIRCLE_I
IMM2|IF_EQUAL    REG_RAM     IO_NUM      DATA_O     # 如果REG_RAM=IO_NUM，跳转到DATA_O
MOV              INPUT       TO          RAM        # RAM <- INPUT
IMM2|ADD         REG_RAM     1           REG_RAM    # REG_RAM++
IMM2|JMP         TO          CIRCLE_I    COUNTER    # 跳转到CIRCLE_I
# 循环OUTPUT:
LABEL DATA_O
IMM1|MOV         0           TO          REG_RAM    # REG_RAM置0
LABEL CIRCLE_O
IMM2|IF_EQUAL    REG_RAM     IO_NUM      END        # 如果REG_RAM=IO_NUM，跳转到END结束
MOV              RAM         TO          OUTPUT     # OUTPUT <- RAM
IMM2|ADD         REG_RAM     1           REG_RAM    # REG_RAM++
IMM1|MOV         CIRCLE_O    TO          COUNTER    # COUNTER <- CIRCLE_O
LABEL END
**/
localparam IO_NUM = 8'b00100000; // 每次读32个
initial begin // 这是ROM
    memory[0]  = IMM1 | MOV;               // 0: IMM1 | MOV
    memory[1]  = 8'b00000000;              // 1: 0
    memory[2]  = TO;                       // 2: TO
    memory[3]  = REG_RAM;                  // 3: REG_RAM
    // 循环INPUT
    memory[4]  = IMM2 | IF_EQUAL;          // 4: IMM2 | IF_EQUAL
    memory[5]  = REG_RAM;                  // 5: REG_RAM
    memory[6]  = IO_NUM;                   // 6: IO_NUM
    memory[7]  = 8'b00010100;              // 7: DATA_O: 20
    memory[8]  = MOV;                      // 8: MOV
    memory[9]  = INPUT;                    // 9: INPUT
    memory[10] = TO;                       // 10: TO
    memory[11] = RAM;                      // 11: RAM
    memory[12] = IMM2 | ADD;               // 12: IMM2 | ADD
    memory[13] = REG_RAM;                  // 13: REG_RAM
    memory[14] = 8'b00000001;              // 14: 1
    memory[15] = REG_RAM;                  // 15: REG_RAM
    memory[16] = IMM2 | JMP;               // 16: IMM2 | JMP
    memory[17] = TO;                       // 17: TO
    memory[18] = 8'b00000100;              // 18: CIRCLE_I: 4
    memory[19] = COUNTER;                  // 19: COUNTER
    // 循环OUTPUT
    memory[20] = IMM1 | MOV;               // 20: IMM1 | MOV
    memory[21] = 8'b00000000;              // 21: 0
    memory[22] = TO;                       // 22: TO
    memory[23] = REG_RAM;                  // 23: REG_RAM
    memory[24] = IMM2 | IF_EQUAL;          // 24: IMM2 | IF_EQUAL
    memory[25] = REG_RAM;                  // 25: REG_RAM
    memory[26] = IO_NUM;                   // 26: IO_NUM
    memory[27] = 8'b00101000;              // 27: END: 40
    memory[28] = MOV;                      // 28: MOV
    memory[29] = RAM;                      // 29: RAM
    memory[30] = TO;                       // 30: TO
    memory[31] = OUTPUT;                   // 31: OUTPUT
    memory[32] = IMM2 | ADD;               // 32: IMM2 | ADD
    memory[33] = REG_RAM;                  // 33: REG_RAM
    memory[34] = 8'b00000001;              // 34: 1
    memory[35] = REG_RAM;                  // 35: REG_RAM
    memory[36] = IMM1 | MOV;               // 36: IMM1 | MOV
    memory[37] = 8'b00000100;              // 37: CIRCLE_O: 4
    memory[38] = TO;                       // 38: TO
    memory[39] = COUNTER;                  // 39: COUNTER
    memory[40] = HALT;                     // 40: HALT
end
always @(posedge rst) begin
    opcode <= 32'b0;
end

always @(posedge clk) begin
    opcode <= {memory[(address+3)%256], memory[(address+2)%256], memory[(address+1)%256], memory[address]};
end
endmodule
