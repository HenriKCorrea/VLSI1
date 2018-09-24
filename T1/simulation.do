## create workspace library
vlib work

## compile source code
vcom ./txt_util.vhd
vcom -cover sbcexf ./rcv_fsm.vhd
vcom -cover sbcexf ./pkg_rcv_fsm.vhd
vcom -cover sbcexf ./tb_rcv_fsm.vhd

## start simulation command
#-novopt: compile with no optimizations
#-wlf: place to save simulation files
#-wlfdeleteonquit: Flag to delete all temporary files when simulation ends
#-coverage: Run coverage test in this simulation
vsim -novopt -wlf /tmp/T1 -wlfdeleteonquit work.tb_rcv_fsm

##set waveforms and additional display options
#Set default radix of all waveforms to be added as hexadecimal
radix -hexadecimal
#Display only the first name of the wave signal instead of full name
config wave -signalnamewidth 1
#Add all waveforms
add wave -position end sim:/tb_rcv_fsm/cuv/*

##Force waveform values
#Generate a clock signal of 100MHz (Period of 10ns)
#force -freeze sim:/rcv_fsm/clk_in 1 0, 0 {5 ns} -r 10

##run simulation
run 1600 ns
wave zoom full