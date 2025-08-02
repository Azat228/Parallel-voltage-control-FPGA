Here we use the PYNQ Z2 FPGA to generate the 10x1 matrix(that describes the PWM of sending voltages) in PS and then send this matrix into the PL system, where we distribute this matrix in parallel into 10 active metasurfaces.<br>
The PS and PL communication is not finished yet<br>
The Host was written by Xingyu FAN and modified by me<br>
The main PL part was written by Xingyu FAN, modified by me<br>
##/The 2 FPGA approach<br>
The 2-FPGA approach implementation is already finished. Here is the second FPGA implementation part, where we receive data from one pin, and then  distribute it equally through 100 pins
The full project can be found at Parallel-voltage-control-FPGA/Past_2FPGA_implementation/
##/1 FPGA approach
We tried to implement all this functionality using 1 PYNQ Z2 FPGA, PS part, and PL part are already finished, but they are not connected together.<br>
PS part is Host.py, PL part is the remaining Vivado files

 
