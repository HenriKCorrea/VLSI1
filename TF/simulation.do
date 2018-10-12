## create workspace library
vlib work

## compile source code
#vcom ./txt_util.vhd
vcom -cover sbcexf ./deck_controller.vhd
#vcom -cover sbcexf ./blackjack.vhd
#vcom -cover sbcexf ./pkg_tb_blackjack.vhd
#vcom -cover sbcexf ./tb_blackjack.vhd

## start simulation command
#-novopt: compile with no optimizations
#-wlf: place to save simulation files
#-wlfdeleteonquit: Flag to delete all temporary files when simulation ends
#-coverage: Run coverage test in this simulation
#vsim -novopt -wlf /tmp/T1 -wlfdeleteonquit work.tb_blackjack

##set waveforms and additional display options
##Set default radix of all waveforms to be added as hexadecimal
#radix -hexadecimal
##Display only the first name of the wave signal instead of full name
#config wave -signalnamewidth 1
##Add all waveforms
#add wave -position end sim:/tb_blackjack/cuv/*

##Force waveform values
##Generate a clock signal of 100MHz (Period of 10ns)
#force -freeze sim:/blackjack/clk_in 1 0, 0 {5 ns} -r 10

##run simulation
#run 1600 ns
#wave zoom full