## compile source code
#vcom ./txt_util.vhd
vcom ./pkg_tb_blackjack.vhd
vcom ./card_deck_memory.vhd
vcom -cover sbcexf ./deck_controller.vhd
vcom -cover sbcexf ./blackjack.vhd
vcom ./tb_blackjack.vhd

##Restart and run simulation
restart -force
run 3270 ns
wave zoom full