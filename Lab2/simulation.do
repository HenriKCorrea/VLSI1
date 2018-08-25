## create workspace library
vlib work

## compile source code
vcom ./scancode_ascii_pkg.vhd
vcom ./txt_util.vhd
vcom ./decoder_scancode_ascii.vhd
vcom ./decoder_scancode_ascii_map.vhd
vcom ./decoder_scancode_ascii_tb.vhd

## start simulation command
#-novopt: compile with no optimizations
#-wlf: place to save simulation files
#-wlfdeleteonquit: Flag to delete all temporary files when simulation ends
vsim -novopt -wlf /tmp/lab01 -wlfdeleteonquit work.decoder_scancode_ascii_tb

##set waveforms and additional display options
add wave -position end -radix hex sim:/decoder_scancode_ascii_tb/s_scancode_in
add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_golden_ascii_out
add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_cuv_ascii_out

## force input signals
#force -freeze sim:/full_adder/ci 1 0, 0 {20 ns} -r 40 ns
#force -freeze sim:/full_adder/b 1 0, 0 {40 ns} -r 80 ns
#force -freeze sim:/full_adder/a 1 0, 0 {80 ns} -r 160 ns

##run simulation
run 5210 ns