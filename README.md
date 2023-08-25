# data_stream_mux
in the data mux module: after the declaration of input and output ports
a reg to store mode is initialised
two 32 bit counters are declared and initialised to 0. They keep track of the clock cycles for switching data streams.
a 32 bit register initialised to hold current output data
data1_flag is initialised to 1 and represents the selection of data stream 1. data2_flag and data3_flag are declared but not initialised and the start represents the start signal
2 bit temp_reg are declared and initialised to 0. Its used temporary register for state transition logic.
paramters define symbolic values for different states in the FSM
the following always block generates a start signal by setting start to 1 on every rising edge of symbol_clock
a 2 bit state register is declared and initialised to IDLE. The following always block updates the states based on mode inputs and handles state transitions using a FSM
the following always block operates on internal clk. It handles data switching logic based on the state machine and the define behavior for different modes and switch cycles
always(*) block uses combinational logic to determine the appropriate data stream to be selected based on the current state and flag values
the output dataport is assigned the value of current_data to output the selected data stream
In summary, the verilog module implements a data mux with a FSM thts selects and switches between different data streams based on the mode input and clock cycles,
the module defines registers, counters and logic to achieve the functionality
