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
ExecStep $xv_path/bin/xelab -wto 098fd8a21d6449a58252cab9d02096f2 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot I2C_controller_behav xil_defaultlib.I2C_controller -log elaborate.log
