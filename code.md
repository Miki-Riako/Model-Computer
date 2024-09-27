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
| 00010010   | STACK      |

额外寄存器将储存32位，目前暂未实现，先暂时给出6个八位寄存器。

RAM和REG_RAM的区别
- RAM的地址与REG_RAM相连。
- 输出时：RAM输出的是其存储值，REG_RAM输出的是地址。
- 输入时：RAM输入的是地址，REG_RAM输入的是存储值。

STACK和RAM类似，为栈存储器。

## OPERATION - COMPUTE

| 操作码     | 含义    |
|------------|--------|
| ??000000   | ADD    |
| ??000001   | SUB    |
| ??000010   | AND    |
| ??000011   | OR     |
| ??000100   | NOT    |
| ??000101   | XOR    |
| ??000110   | SHL    |
| ??000111   | SHR    |
| ??001000   | MUL    |
| ??001001   | DIV    |
| ??001010   | MOD    |

NOT will ignore the second argument.

## OPERATION - IMMEDIATE

| 操作码     | 含义                             |
|------------|---------------------------------|
| 1???????   | IMMEDIATE as first argument     |
| ?1??????   | IMMEDIATE as second argument    |

## Assembly

| 指令                    | 操作码       |
|-------------------------|-------------|
| imm1                    | 10000000    |
| imm2                    | 01000000    |
| mov                     | 01000000    |
| jmp                     | 10000000    |
| push                    | 01000000    |
| pop                     | 01000000    |
| to                      | 00000000    |
| add                     | 00000000    |
| sub                     | 00000001    |
| and                     | 00000010    |
| or                      | 00000011    |
| not                     | 00000100    |
| xor                     | 00000101    |
| shl                     | 00000110    |
| shr                     | 00000111    |
| mul                     | 00001000    |
| div                     | 00001001    |
| mod                     | 00001010    |
| null                    | 00000000    |
| reg0                    | 00000000    |
| reg1                    | 00000001    |
| reg2                    | 00000010    |
| reg3                    | 00000011    |
| reg4                    | 00000100    |
| reg5                    | 00000101    |
| ram                     | 00010000    |
| reg_ram                 | 00010001    |
| stack                   | 00010010    |
| counter                 | 00000110    |
| input                   | 00000111    |
| output                  | 00000111    |
| if_equal                | 00100000    |
| if_not_equal            | 00100001    |
| if_less                 | 00100010    |
| if_less_or__equal       | 00100011    |
| if_greater              | 00100100    |
| if_greater_or__equal    | 00100101    |
| call                    | 00110000    |
| ret                     | 00110001    |
| halt                    | 00110010    |


| 宽指令                     | 操作码                               |
|----------------------------|-------------------------------------|
| mov  ?     to   ?          | 01000000 ???????? 00000000 ???????? |
| jmp  to    ?    counter    | 10000000 00000000 ???????? 00000110 |
| push ?     to   stack      | 01000000 ???????? 00000000 00010010 |
| pop  stack to   ?          | 01000000 00010010 00000000 ???????? |
| call null  null label      | 00110000 00000000 00000000 ???????? |
| ret  null  null null       | 00110001 00000000 00000000 00000000 |
| halt null  null null       | 00110010 00000000 00000000 00000000 |

实际上：
- 指令mov (01000000) 等价于 push (01000000) 等价于 pop (01000000) 等价于 imm2|add （01000000|00000000），jmp (10000000) 等价于 imm2|add，此处指令作为语法糖方便使用。
- 指令ret null null null（00110001 00000000 00000000 00000000）可以等价于pop stack to counter（01000000 00010010 00000000 00000110），此处计算机做了集成。
- 指令call null  null label (00110000 00000000 00000000 ????????) 可以等价于两个宽指令：imm2|add counter 8 stack(01000000 00000110 00001000 00010010)与imm2|jmp to label counter(10000000 00000000 ???????? 00000110)，此处计算机做了集成。

### Example
``` asm
if_less reg0 re1 16
```
如果reg0 < reg1，跳转到16
``` asm
imm2|if_equal reg_ram 32 | 0
```
如果reg_ram == 32，跳转到0

### 算法示例

``` asm
const io_num 32
imm1|mov         0           to          reg_ram    # reg_ram置0
# 循环input:
label circle_i
imm2|if_equal    reg_ram     io_num      data_o     # 如果reg_ram=io_num，跳转到data_o
mov              input       to          ram        # ram <- input
imm2|add         reg_ram     1           reg_ram    # reg_ram++
imm2|jmp         to          circle_i    counter    # 跳转到circle_i
# 循环output:
label data_o
imm1|mov         0           to          reg_ram    # reg_ram置0
label circle_o
imm2|if_equal    reg_ram     io_num      end        # 如果reg_ram=io_num，跳转到end结束
mov              ram         to          output     # output <- ram
imm2|add         reg_ram     1           reg_ram    # reg_ram++
imm1|mov         circle_o    to          counter    # counter <- circle_o
label end

```
循环输入32个输入数并储存，然后循环顺序输出。

``` asm
# 读取输入:
label read_in
mov                  input    to        reg3         # reg3 <- input
imm2|if_equal        reg3     0         pop_data     # 如果reg3=0，跳转到pop_data
imm2|if_not_equal    reg3     0         push_data    # 否则跳转到push_data
# 压栈
label push_data
push                 reg3     to         stack       # push reg3
imm2|jmp             to       read_in    counter     # 跳转到read_in
# 弹栈
label pop_data
pop                  stack    to         output      # pop to output
imm2|jmp             to       read_in    counter     # 跳转到read_in

```
对输入值进行判断，如果为0则弹栈，否则压栈。

``` asm
# f = 2(x+y)
const x 35
const y 55
imm1|mov    x       to      reg0       # reg0 <- x
imm1|mov    y       to      reg1       # reg1 <- y
call        null    null    funA       # 调用funA
imm2|jmp    to      end     counter    # 跳转到end
label funA
add         reg0    reg1    reg2       # reg2 <- reg0 + reg1
call        null    null    funB       # 调用funB
ret         null    null    null       # 返回
label funB
add         reg2    reg2    reg2       # reg2 <- reg2 + reg2
ret         null    null    null       # 返回
label end
mov         reg2    to      output     # output <- reg2
halt        null    null    null       # 停机
```
函数使用案例，def f(x, y): return 2*(x+y)

## 我的创新

除了一般的基本任务与扩展任务全部完成以外，还完成了：
- 计算机修改为32位，理论上能够运行所有32位指令。
- 增加栈存储器，成为独立于ROM与RAM的第三个存储单元。
- 修改了寄存器组，增加call与ret指令，使得支持函数调用。
