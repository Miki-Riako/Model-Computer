# 指令集手册

本手册描述了机器码的各个位的含义及其对应的操作。

## 哈佛架构：
**哈佛架构**是一种计算机体系结构，它的一个显著特征是将**程序指令存储器**和**数据存储器**分离。与传统的冯·诺依曼架构不同，冯·诺依曼架构使用相同的存储空间来存储数据和指令，而哈佛架构则使用两个独立的存储空间和总线：一个用于存储指令，一个用于存储数据。

### 主要特征

1. **分离的存储器**：哈佛架构中，程序指令和数据各自存储在不同的存储器中（如ROM用于指令，RAM用于数据），并且各自有独立的总线，这使得处理器可以同时从两个存储器中获取数据和指令。
2. **并行访问**：由于指令和数据存储在不同的存储器中，并且通过不同的总线访问，CPU可以同时读取指令和数据，从而提高了处理速度。在冯·诺依曼架构中，CPU需要在每个时钟周期内读取指令或者读取/写入数据，存在瓶颈（通常称为“冯·诺依曼瓶颈”）。
3. **常见应用**：哈佛架构常用于**微控制器**、**数字信号处理器（DSP）**等嵌入式系统中，这些系统通常对执行效率要求较高。

### 优点：
1. **高效并行性**：由于指令和数据是通过不同的总线访问的，因此能够并行处理，减少了瓶颈，提高了系统的执行速度。
2. **安全性与独立性**：指令和数据的分离可以增加系统的安全性和稳定性，因为数据不能被直接修改为指令，指令也不能被当作数据来处理。
3. **适合实时系统**：由于其高效的并行访问，哈佛架构在需要确定性行为和高效计算的嵌入式系统和实时系统中具有优势。

### 缺点：
1. **灵活性不足**：由于指令和数据使用不同的存储器和总线，系统设计更加复杂，不同的总线和存储器增加了硬件的复杂度。
2. **资源浪费**：如果程序对存储指令或数据的需求不对称（如指令需要大量空间而数据较少），可能导致存储器资源利用率不高。

ARM Cortex-M系列微控制器采用了一种改进的哈佛架构，它可以同时使用分离的指令和数据存储器，但也允许它们在必要时通过共享的存储器接口进行交互。这种设计在保持高效处理的同时，提供了额外的灵活性。

**哈佛架构**的关键特征是程序指令和数据的存储器分离及并行访问，特别适合那些要求高效数据处理的应用，如数字信号处理和嵌入式系统。虽然32位的哈佛架构系统中具体寄存器的数量和设计取决于处理器的架构，但它仍然有一套通用的寄存器来处理数据和控制操作。

## 指令集架构

一次处理32位指令：
OPERATION ARGUMENT1 ARGUMENT2 ADDRESS

## OPERATION - CONDITION

| 操作码     | 含义                     |
|------------|-------------------------|
| ??100000   | IF_EQUAL                |
| ??100001   | IF_NOT_EQUAL            |
| ??100010   | IF_LESS                 |
| ??100011   | IF_LESS_OR__EQUAL       |
| ??100100   | IF_GREATER              |
| ??100101   | IF_GREATER_OR__EQUAL    |

In this case, ADDRESS will be the jump address.

## ARGUMENT and ADDRESS

| 操作码     | 含义        |
|------------|------------|
| 00000000   | REG0       |
| 00000001   | REG1       |
| 00000010   | REG2       |
| 00000011   | REG3       |
| 00000100   | REG4       |
| 00000101   | REG5       |
| 00000110   | COUNTER    |
| 00000111   | I/O        |
| 00001???   | 额外寄存器  |
| 00010000   | RAM        |
| 00010001   | REG_RAM    |

额外寄存器将储存32位，目前暂未实现，先暂时给出6个八位寄存器。

RAM和REG_RAM的区别
- RAM的地址与REG_RAM相连。
- 输出时：RAM输出的是其存储值，REG_RAM输出的是地址。
- 输入时：RAM输入的是地址，REG_RAM输入的是存储值。

## OPERATION - COMPUTE

| 操作码     | 含义    |
|------------|--------|
| ??000000   | ADD    |
| ??000001   | SUB    |
| ??000010   | AND    |
| ??000011   | OR     |
| ??000100   | NOT    |
| ??000101   | XOR    |

NOT will ignore the second argument.

## OPERATION - IMMEDIATE

| 操作码     | 含义                             |
|------------|---------------------------------|
| 1???????   | IMMEDIATE as first argument     |
| ?1??????   | IMMEDIATE as second argument    |

## Assembly

| 指令                    | 操作码       |
|-------------------------|-------------|
| imm8                    | 10000000    |
| imm7                    | 01000000    |
| add                     | 00000000    |
| mov                     | 00000000    |
| jmp                     | 00000000    |
| to                      | 00000000    |
| sub                     | 00000001    |
| and                     | 00000010    |
| or                      | 00000011    |
| not                     | 00000100    |
| xor                     | 00000101    |
| reg0                    | 00000000    |
| reg1                    | 00000001    |
| reg2                    | 00000010    |
| reg3                    | 00000011    |
| reg4                    | 00000100    |
| reg5                    | 00000101    |
| counter                 | 00000110    |
| input                   | 00000111    |
| output                  | 00000111    |
| if_equal                | 00100000    |
| if_not_equal            | 00100001    |
| if_less                 | 00100010    |
| if_less_or__equal       | 00100011    |
| if_greater              | 00100100    |
| if_greater_or__equal    | 00100101    |


if_less reg0 re1 16
如果reg0 < reg1，跳转到16

imm7|if_equal reg_ram 32 | 0
如果reg_ram == 32，跳转到0

``` asm
const io_num 32
imm8|imm7|mov    0           to          reg_ram    # reg_ram置0
# 循环input:
label circle_i
imm7|if_equal    reg_ram     io_num      data_o     # 如果reg_ram=io_num，跳转到data_o
imm7|mov         input       to          ram        # ram <- input
imm7|add         reg_ram     1           reg_ram    # reg_ram++
imm8|imm7|jmp    to          circle_i    counter    # 跳转到circle_i
# 循环output:
label data_o
imm8|imm7|mov    0           to          reg_ram    # reg_ram置0
label circle_o
imm7|if_equal    reg_ram     io_num      end        # 如果reg_ram=io_num，跳转到end结束
imm7|mov         ram         to          output     # output <- ram
imm7|add         reg_ram     1           reg_ram    # reg_ram++
imm8|imm7|mov    circle_o    to          counter    # counter <- circle_o
label end

```
循环输入32个输入数并储存，然后循环顺序输出。
