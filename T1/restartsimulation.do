## compile source code
vcom -cover sbcexf ./rcv_fsm.vhd
vcom -cover sbcexf ./pkg_rcv_fsm.vhd
vcom -cover sbcexf ./tb_rcv_fsm.vhd

##Restart and run simulation
restart -force
run 1600 ns
wave zoom full