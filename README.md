# Parallel Voltage Control for Metasurfaces using PYNQ-Z2 FPGA

This project implements parallel voltage distribution for controlling 100 voltages using a PYNQ-Z2 FPGA, with both 1-FPGA and 2-FPGA approaches.

## Project Overview

Two implementations are available:

1. **2-FPGA Approach** (Completed):
   - FPGA #1: Generates and sends PWM data into 1 pin
   - FPGA #2: Receives data, processes it, and distributes it  to 100 pins equally. This repository has the code for the second FPGA implementation

2. **1-FPGA Approach** (In Progress):
   - PS (Host) generates PWM matrix:<br>
   The system generates a 10, 10x1 PWM matrix in the Processing System (PS) and send this matrix into PL system of PYNQ Z2.
   - PL distributes to 10 pins. 1 matrix into 1 pin
   - Current status: PS and PL components are working, but not yet integrated

## Contributors

- Xingyu FAN (Original implementation)
- Azat (Modifications and 1-FPGA adaptation, 2-FPGA approach)
