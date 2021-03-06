# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.cache/wt [current_project]
set_property parent.project_path /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
add_files -quiet /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.runs/ila_naam_synth_1/ila_naam.dcp
set_property used_in_implementation false [get_files /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.runs/ila_naam_synth_1/ila_naam.dcp]
read_vhdl -library xil_defaultlib {
  /home/dsplab/Angle_calculate/Angle_calculate.srcs/sources_1/new/Angle_calculate.vhd
  /home/dsplab/Angle_calculate/Angle_calculate.srcs/sources_1/new/division.vhd
  /home/dsplab/Angle_calculate/Angle_calculate.srcs/sources_1/new/Main.vhd
}
synth_design -top MAIN -part xc7a100tcsg324-1
write_checkpoint -noxdef MAIN.dcp
catch { report_utilization -file MAIN_utilization_synth.rpt -pb MAIN_utilization_synth.pb }
