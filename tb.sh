#!/bin/bash

module="ROM.v RAM.v STACK.v DEC.v ALU.v COND.v decoder.v registerPlus.v counter.v controller.v CPU.v COMPUTER.v"
testbench="COMPUTER.tb.v"
compf() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog $module $testbench
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}

CPU="ROM.v RAM.v STACK.v DEC.v ALU.v COND.v decoder.v registerPlus.v counter.v controller.v CPU.v"
compCPU() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog $CPU "CPU.tb.v"
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}

compd() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog "decoder.v" "decoder.tb.v"
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}

compc() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog "counter.v" "counter.tb.v"
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}

comprom() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog "ROM.v" "ROM.tb.v"
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}

compram() {
    # 编译verilog代码
    echo "compiling verilog design and testbench..."
    iverilog "RAM.v" "RAM.tb.v"
    if [ $? -ne 0 ]; then
        echo "compilation failed."
    else
        echo "running simulation..."
        ./a.out
    fi
}
