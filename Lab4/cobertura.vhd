--------------------------------------------------
-- File:    cobertura.vhd
-- Author:  Prof. M.Sc. Marlon Moraes
-- E-mail:  marlon.moraes@pucrs.br
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all; 
    
entity cobertura is
	port
	(
		reset		: in		std_logic;
		clock		: in		std_logic;
		entrada	: in		std_logic_vector(3 downto 0);
		saida		: out	std_logic_vector(6 downto 0)	
	);
end cobertura;

architecture cobertura of cobertura is

	type fsm_state is (A_ST, B_ST, C_ST, D_ST, E_ST, F_ST, G_ST);

	signal	state, next_state	:	fsm_state := A_ST;
begin


	-- Flip-Flop da FSM.
	fsm_ff: process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				state	<= A_ST;
			else
				state	<= next_state;
			end if;
		end if;
	end process fsm_ff;


	-- Decodificador da FSM.
	fsm_dec: process(entrada, state)
	begin
		case state is
			when A_ST =>
				if entrada = "0000" then
					next_state <= C_ST;
				else
					next_state <= D_ST;
				end if;

			when B_ST =>
				if entrada = "0000" then
					next_state <= D_ST;
				else
					next_state <= A_ST;
				end if;

			when C_ST =>
				if entrada = "0000" then
					next_state <= B_ST;
				else
					next_state <= A_ST;
				end if;

			when D_ST =>
				if entrada = "0000" then
					next_state <= B_ST;
				else
					next_state <= C_ST;
				end if;

			when E_ST =>
				if entrada = "0000" then
					next_state <= B_ST;
				else
					next_state <= C_ST;
				end if;

			when F_ST =>
				if entrada = "0000" then
					next_state <= B_ST;
				else
					next_state <= C_ST;
				end if;

			when G_ST =>
				if entrada = "0000" then
					next_state <= B_ST;
				else
					next_state <= C_ST;
				end if;

		end case;
	end process fsm_dec;


	-- Decodificador da Saida..
	decoder:	saida <=	"0000001"  when (state = A_ST) or (state = B_ST) else  -- 0
                					"1001111"  when (state = C_ST) or (state = D_ST) else  -- 1
                					"0010010"  when (state = E_ST) or (state = F_ST) else  -- 2
                					"0000110"  when (state = G_ST) else  -- 3
                					"0111000";

end cobertura;

