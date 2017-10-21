// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
// Date        : Sat Oct  7 19:02:26 2017
// Host        : dsplab-OptiPlex-9020 running 64-bit Ubuntu 14.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/dsplab/ANGLE_DISPLAY/ANGLE_DISPLAY.srcs/sources_1/ip/ila_naam/ila_naam_stub.v
// Design      : ila_naam
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2015.4" *)
module ila_naam(clk, probe0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[15:0]" */;
  input clk;
  input [15:0]probe0;
endmodule
