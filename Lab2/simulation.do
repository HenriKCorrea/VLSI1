## criação da biblioteca de trabalho.
vlib work

## comando de compilação.
vcom ./scancode_ascii_pkg.vhd
vcom ./txt_util.vhd
vcom ./decoder_scancode_ascii.vhd
vcom ./decoder_scancode_ascii_map.vhd
vcom ./decoder_scancode_ascii_tb.vhd

## comando de simulação
vsim -novopt work.decoder_scancode_ascii_tb

## adição dos sinais na forma de onda.
add wave -position end -radix hex sim:/decoder_scancode_ascii_tb/s_scancode_in
add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_golden_ascii_out
add wave -position end -radix ascii sim:/decoder_scancode_ascii_tb/s_cuv_ascii_out


## geração dos estimulos de entrada.
#force -freeze sim:/full_adder/ci 1 0, 0 {20 ns} -r 40 ns
#force -freeze sim:/full_adder/b 1 0, 0 {40 ns} -r 80 ns
#force -freeze sim:/full_adder/a 1 0, 0 {80 ns} -r 160 ns


## execução da simulação.
run 5110 ns