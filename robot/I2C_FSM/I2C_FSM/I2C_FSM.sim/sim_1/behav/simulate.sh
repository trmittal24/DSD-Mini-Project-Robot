#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2015.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim I2C_controller_behav -key {Behavioral:sim_1:Functional:I2C_controller} -tclbatch I2C_controller.tcl -log simulate.log
