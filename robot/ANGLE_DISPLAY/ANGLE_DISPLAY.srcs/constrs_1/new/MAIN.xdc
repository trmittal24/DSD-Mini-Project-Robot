set_property IOSTANDARD LVCMOS33 [get_ports Check_counter_mod]
set_property IOSTANDARD LVCMOS33 [get_ports Check_counter_mod_diff]
set_property IOSTANDARD LVCMOS33 [get_ports ResetN]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_50_MHz]
set_property IOSTANDARD LVCMOS33 [get_ports SCL]
set_property IOSTANDARD LVCMOS33 [get_ports SDA]
set_property IOSTANDARD LVCMOS33 [get_ports WokeUp]
set_property PACKAGE_PIN F6 [get_ports Check_counter_mod]
set_property PACKAGE_PIN K5 [get_ports Check_counter_mod_diff]
set_property PACKAGE_PIN E3 [get_ports CLK_50_MHz]
set_property PACKAGE_PIN P4 [get_ports ResetN]
set_property PACKAGE_PIN H4 [get_ports SCL]
set_property PACKAGE_PIN G1 [get_ports SDA]
set_property PACKAGE_PIN L16 [get_ports WokeUp]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CLK_50_MHz_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {DATA_FOR_ANALYSIS[0]} {DATA_FOR_ANALYSIS[1]} {DATA_FOR_ANALYSIS[2]} {DATA_FOR_ANALYSIS[3]} {DATA_FOR_ANALYSIS[4]} {DATA_FOR_ANALYSIS[5]} {DATA_FOR_ANALYSIS[6]} {DATA_FOR_ANALYSIS[7]} {DATA_FOR_ANALYSIS[8]} {DATA_FOR_ANALYSIS[9]} {DATA_FOR_ANALYSIS[10]} {DATA_FOR_ANALYSIS[11]} {DATA_FOR_ANALYSIS[12]} {DATA_FOR_ANALYSIS[13]} {DATA_FOR_ANALYSIS[14]} {DATA_FOR_ANALYSIS[15]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets CLK_50_MHz_IBUF_BUFG]
