--------------------------------------------------
-- File:    cobertura_tb.vhd
-- Author:  Prof. M.Sc. Marlon Moraes
-- E-mail:  marlon.moraes@pucrs.br
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all; 
    
entity cobertura_tb is
end cobertura_tb;

architecture cobertura_tb of cobertura_tb is

	signal	reset		: 	std_logic := '1';
	signal	clock		: 	std_logic := '0';
	signal	entrada	:	std_logic_vector(3 downto 0) := (others => '0');
	signal	saida		:	std_logic_vector(6 downto 0) := (others => '0');

begin

	-- DUT.
	cobertura: entity work.cobertura
	port map
	(		
		reset,
		clock,		
		entrada,
		saida
	);


	reset <= '0' after 150 ns;


end cobertura_tb;

