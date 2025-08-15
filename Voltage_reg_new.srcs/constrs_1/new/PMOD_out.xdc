# Clock Signal
create_clock -period 8.000 -name clk [get_ports clk]
set_property PACKAGE_PIN H16 [get_ports clk]  # PYNQ-Z2 pin
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Address Signals (PMODA)
set_property PACKAGE_PIN Y18 [get_ports {pmod_out_0}]  # PMODA Pin 1
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_0}]
set_property PACKAGE_PIN Y19 [get_ports {pmod_out_1}]  # PMODA Pin 2
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_1}]
set_property PACKAGE_PIN Y16 [get_ports {pmod_out_2}]  # PMODA Pin 3
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_2}]
set_property PACKAGE_PIN Y17 [get_ports {pmod_out_3}]  # PMODA Pin 4
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_3}]
set_property PACKAGE_PIN U18 [get_ports {pmod_out_4}]  # PMODA Pin 7
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_4}]
set_property PACKAGE_PIN U19 [get_ports {pmod_out_5}]  # PMODA Pin 8
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_5}]
set_property PACKAGE_PIN W18 [get_ports {pmod_out_6}]  # PMODA Pin 9
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_6}]
set_property PACKAGE_PIN W19 [get_ports {pmod_out_7}]  # PMODA Pin 10
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_7}]

# Code Signals (PMODB)
set_property PACKAGE_PIN W14 [get_ports {pmod_out_8}]  # PMODB Pin 1
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_8}]
set_property PACKAGE_PIN Y14 [get_ports {pmod_out_9}]  # PMODB Pin 2
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_out_9}]
