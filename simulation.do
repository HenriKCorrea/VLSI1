## create workspace library
vlib work

## compile source code
vcom ./pkg_tb_blackjack.vhd
vcom ./card_deck_memory.vhd
vcom -cover sbcexf ./card_controller.vhd
vcom -cover sbcexf ./blackjack.vhd
vcom ./tb_blackjack.vhd

## start simulation command
#-novopt: compile with no optimizations
#-wlf: place to save simulation files
#-wlfdeleteonquit: Flag to delete all temporary files when simulation ends
#-coverage: Run coverage test in this simulation
vsim -novopt -wlf /tmp/TF -wlfdeleteonquit work.tb_blackjack

###set waveforms and additional display options
##Set default radix of all waveforms to be added as hexadecimal
radix -hexadecimal
##Display only the first name of the wave signal instead of full name
config wave -signalnamewidth 1
##Add all waveforms
add wave -divider "Testbench (CUV Interface)"
add wave sim:/tb_blackjack/s_clk
add wave sim:/tb_blackjack/s_rst
add wave sim:/tb_blackjack/s_stay
add wave sim:/tb_blackjack/s_hit
add wave sim:/tb_blackjack/s_debug
add wave sim:/tb_blackjack/s_show
add wave sim:/tb_blackjack/s_card
add wave sim:/tb_blackjack/s_request
add wave sim:/tb_blackjack/s_win
add wave sim:/tb_blackjack/s_lose
add wave sim:/tb_blackjack/s_tie
add wave sim:/tb_blackjack/s_total
add wave sim:/tb_blackjack/s_currentTest
radix signal sim:/tb_blackjack/s_total unsigned

add wave -divider "Deck FIFO"
add wave -hex {sim:/tb_blackjack/deck_fifo/queue[39:0]}
add wave -hex sim:/tb_blackjack/deck_fifo/card
add wave sim:/tb_blackjack/deck_fifo/request

###Force waveform values
##Generate a clock signal of 100MHz (Period of 10ns)
#force -freeze sim:/blackjack/clk_in 1 0, 0 {5 ns} -r 10

###run simulation
run 4500 ns
wave zoom full