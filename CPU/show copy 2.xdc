# 50MHz main clock
create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports clk] ;# 50MHz main clock in


#Touch Button
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports rst] ;     #BTN6

#DIP_SW
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {save_byte[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {save_byte[1]}]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {save_byte[2]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {save_byte[3]}]
set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {save_byte[4]}]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {save_byte[5]}]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports {save_byte[6]}]
set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVCMOS33} [get_ports {save_byte[7]}]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {load1_enabl}]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports {load2_enable}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {save_enable}]
