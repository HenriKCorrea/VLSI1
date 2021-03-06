##############################################################################
# modelsim script - simulate entity decoder using with / select architecture #
##############################################################################

#Create a library for working in
vlib work

#Compile VHDL source code
vcom ./decoder_display_with_select.vhd

#select entity to be simulated
vsim -novopt -wlf /tmp/lab01 -wlfdeleteonquit work.decoder

#Add all block ports and signals in the main screen
add wave sim:/decoder/*

#set waveforms and periods
force -freeze sim:/decoder/abcd(0) 1 0, 0 {20 ns} -r 40
force -freeze sim:/decoder/abcd(1) 1 0, 0 {40 ns} -r 80
force -freeze sim:/decoder/abcd(2) 1 0, 0 {80 ns} -r 160
force -freeze sim:/decoder/abcd(3) 1 0, 0 {160 ns} -r 320

#run simulation
run 500 ns