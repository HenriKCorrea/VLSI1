## compile source code
#vcom ./txt_util.vhd
vcom -cover sbcexf ./deck_controller.vhd
vcom -cover sbcexf ./blackjack.vhd
vcom ./card_deck_memory.vhd
vcom ./tb_blackjack.vhd

##Restart and run simulation
restart -force
run 1600 ns
wave zoom full