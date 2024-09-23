# PISO-Shift-Register

PISO (Parallel-In Serial-Out) Shift Register in Verilog
Project Overview
This project implements a Parallel-In Serial-Out (PISO) shift register in Verilog, along with a testbench for simulation purposes. The PISO shift register is designed to take 32-bit parallel data and serialize it, sending out one bit at a time on each clock cycle.

Key Features:
32-bit Parallel Data Input: The input data is provided in parallel, which will be shifted out one bit at a time.

Serial Output: The shift register serializes the parallel input and outputs the bits serially on tx_serial_out.

State Machine: The design uses a state machine with four states: idle, load, slz, and slz_comp to manage the behavior of the PISO.

Testbench for Simulation: A testbench is included to simulate the design, providing a clock signal, a reset signal, and applying input data.
Modules

#1. PISO (Parallel-In Serial-Out Shift Register)
The main module that implements the PISO functionality. It operates as a state machine with four distinct states:

Idle State: In this state, the system waits for the enable signal to start the serialization process. All registers are reset in this state.

Load State: This state loads the 32-bit parallel data into a temporary register (temp_data) for serial transmission.

Shift (SLZ) State: In this state, the bits from temp_data are shifted out one by one. On each clock cycle, the most significant bit (MSB) of temp_data is sent out via tx_serial_out, and the temp_data is shifted left.

Completion (SLZ_COMP) State: Once all 32 bits have been shifted out, the PISO enters this state, and the transmission is marked as successful.

# Inputs:
clk: System clock.
g_rst: Global reset signal. When active, it resets the PISO to the idle state.
enable: Starts the PISO process when asserted.
par_ser_data: 32-bit parallel data input that needs to be serialized.
#Output:
tx_serial_out: The serialized bitstream output, where one bit is transmitted on each clock cycle.

#2. Testbench (piso_tb)
The testbench (piso_tb) is responsible for simulating the behavior of the PISO module. It generates the clock signal and applies the necessary input stimulus to verify the design.

#Key Features of the Testbench:
Clock Generation: The testbench generates a clock signal that toggles every 3 time units, creating a periodic clock for the PISO module.

Reset and Enable Signals: The reset (g_rst) and enable (enable) signals are applied at appropriate intervals to control the operation of the PISO.

Parallel Data: A 32-bit parallel data input (10100101_11001100_11100011_00001111) is applied after the reset is deasserted, which will be serialized by the PISO module.

Simulation Termination: The simulation is automatically terminated using $finish after enough time has passed for the data to be serialized.

#How It Works:

#Idle State:
The system waits for the enable signal to go high.
Upon receiving the enable signal, it transitions to the load state.

#Load State:
In this state, the 32-bit parallel data is loaded into a temporary register (temp_data).

#Serializing (SLZ) State:
The bits in temp_data are shifted out one by one.
The MSB of temp_data is assigned to the tx_serial_out output on each clock cycle, and temp_data is shifted left.
This process continues until all 32 bits are transmitted.

#SLZ Completion (SLZ_COMP) State:
Once all bits are serialized, the module transitions to the slz_comp state, marking the transmission as successful and resetting internal signals.
After this, the state machine returns to idle, ready for the next transmission.



