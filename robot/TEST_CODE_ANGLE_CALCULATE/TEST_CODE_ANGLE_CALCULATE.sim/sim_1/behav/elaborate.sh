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
ExecStep $xv_path/bin/xelab -wto 72963f14c0da4df091d00dfffc928d98 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot MAIN_behav xil_defaultlib.MAIN -log elaborate.log
