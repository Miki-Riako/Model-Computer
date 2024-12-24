#DIP_SW
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {OPCODE[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {OPCODE[1]}]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {OPCODE[2]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {OPCODE[3]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {OPCODE[4]}]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {OPCODE[5]}]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports {OPCODE[6]}]
set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVCMOS33} [get_ports {OPCODE[7]}]

#LEDS
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS33} [get_ports {IMMEDIATE1}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {IMMEDIATE2}]
set_property -dict {PACKAGE_PIN A24 IOSTANDARD LVCMOS33} [get_ports {CONDITION}]