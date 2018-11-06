## compile source code
vcom ./pkg_tb_blackjack.vhd
vcom ./card_deck_memory.vhd
vcom -cover sbcexf ./card_controller.vhd
vcom -cover sbcexf ./blackjack.vhd
vcom ./tb_blackjack.vhd

##Restart and run simulation
restart -force
run 4500 ns
wave zoom full