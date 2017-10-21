# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.cache/wt [current_project]
set_property parent.project_path /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
read_ip /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam.xci
set_property is_locked true [get_files /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam.xci]

synth_design -top ila_naam -part xc7a100tcsg324-1 -mode out_of_context
rename_ref -prefix_all ila_naam_
write_checkpoint -noxdef ila_naam.dcp
catch { report_utilization -file ila_naam_utilization_synth.rpt -pb ila_naam_utilization_synth.pb }
if { [catch {
  file copy -force /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.runs/ila_naam_synth_1/ila_naam.dcp /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}
if { [catch {
  write_verilog -force -mode synth_stub /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode synth_stub /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_verilog -force -mode funcsim /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode funcsim /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if {[file isdir /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.ip_user_files/ip/ila_naam]} {
  catch { 
    file copy -force /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_stub.v /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.ip_user_files/ip/ila_naam
  }
}

if {[file isdir /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.ip_user_files/ip/ila_naam]} {
  catch { 
    file copy -force /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_stub.vhdl /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.ip_user_files/ip/ila_naam
  }
}