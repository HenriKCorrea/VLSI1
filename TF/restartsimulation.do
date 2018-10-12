## compile source code
vcom -cover sbcexf ./deck_controller.vhd
#vcom -cover sbcexf ./blackjack.vhd
#vcom -cover sbcexf ./pkg_tb_blackjack.vhd
#vcom -cover sbcexf ./tb_blackjack.vhd

##Restart and run simulation
restart -force
run 1600 ns
wave zoom full