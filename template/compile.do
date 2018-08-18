## criação da biblioteca de trabalho.
vlib work

## comando de compilação.
vcom -93 -explicit ./full_adder.vhd

## comando de simulação
vsim work.full_adder

## adição dos sinais na forma de onda.
add wave sim:/full_adder/a
add wave sim:/full_adder/b
add wave sim:/full_adder/ci
add wave sim:/full_adder/sum
add wave sim:/full_adder/co

## geração dos estimulos de entrada.
force -freeze sim:/full_adder/ci 1 0, 0 {20 ns} -r 40 ns
force -freeze sim:/full_adder/b 1 0, 0 {40 ns} -r 80 ns
force -freeze sim:/full_adder/a 1 0, 0 {80 ns} -r 160 ns


## execução da simulação.
run 160 ns
