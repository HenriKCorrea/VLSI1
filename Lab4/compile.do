## criação da biblioteca de trabalho.
if {! [ file exists work ] } { 
	echo "Criando biblioteca Work..."
	vlib work
} 


## comando de compilação.
vcom -cover sbcexf ./cobertura.vhd
vcom -cover sbcexf ./cobertura_tb.vhd


## comando de simulação
vsim -coverage -wlfdeleteonquit work.cobertura_tb


## adição dos sinais na forma de onda.
add wave sim:/*


## execução da simulação.
run 800 ns
