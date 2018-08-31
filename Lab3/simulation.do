## create workspace library
vlib work

## compile source code
vcom ./txt_util.vhd
vcom ./pkg_reg_bank.vhd
vcom ./reg_bank.vhd
vcom ./tb_reg_bank.vhd

## start simulation command
#-novopt: compile with no optimizations
#-wlf: place to save simulation files
#-wlfdeleteonquit: Flag to delete all temporary files when simulation ends
vsim -novopt -wlf /tmp/lab01 -wlfdeleteonquit work.tb_reg_bank

##set waveforms and additional display options
add wave -position insertpoint  \
-radix hex sim:/tb_reg_bank/s_clk \
-radix hex sim:/tb_reg_bank/s_finishTest \
-radix hex sim:/tb_reg_bank/s_rd_en_in \
-radix hex sim:/tb_reg_bank/s_rst_in \
-radix hex sim:/tb_reg_bank/s_wr_en_in \
-radix hex sim:/tb_reg_bank/s_rd_data_out \
-radix hex sim:/tb_reg_bank/s_wr_data_in \
-radix hex sim:/tb_reg_bank/s_rd_address_in \
-radix hex sim:/tb_reg_bank/s_wr_address_in
#add wave -position end -radix hex sim:/decoder_scancode_ascii_tb/s_scancode_in
#add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_golden_ascii_out
#add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_cuv_ascii_out

##run simulation
run 2550 ns

