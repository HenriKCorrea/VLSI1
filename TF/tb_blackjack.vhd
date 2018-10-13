--------------------------------------------------
-- File:    tb_blackjack.vhd
-- Author:  Henrique Krausburg Correa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;

library work;
	--use work.pkg_tb_blackjack.all;
	use work.txt_util.all;

entity tb_blackjack is
end tb_blackjack;


architecture arch_tb_blackjack of tb_blackjack is
	--Auxiliary constants
	constant 	CLK_EDGE    	: std_logic := '1';
	constant 	INV_CLK_EDGE    : std_logic := not CLK_EDGE;
	constant	PERIOD			: time := 5 ns;	-- period for 200MHz .
	constant	HALF_PERIOD		: time := 2.5 ns;

	--Auxiliary signals
	signal s_finishTest: std_logic := '0';		--Flag to indicate if test finish
	
	--signals used to map  (CUV)
	signal s_clk 		: std_logic := '0'; 
	signal s_rst 		: std_logic := '1'; 
	signal s_stay 		: std_logic := '0'; 
	signal s_hit	 	: std_logic := '0'; 
	signal s_debug 		: std_logic := '0'; 
	signal s_show 		: std_logic := '0'; 
	signal s_card		: std_logic_vector(3 downto 0) := (others => '0');
	signal s_request	: std_logic := '0';
	signal s_win		: std_logic := '0'; 
	signal s_lose		: std_logic := '0'; 
	signal s_tie		: std_logic := '0'; 
	signal s_total		: std_logic_vector(4 downto 0) := (others => '0');

begin

	--Clock generation
	--Works untill test is not finished
	s_clk <= not s_clk after HALF_PERIOD when s_finishTest /= '1' else '0';

	--Control initial reset
	reset:process
	begin
		wait until s_clk = '1'; wait until s_clk = '0';
		s_rst <= '0';
		wait;
	end process reset;
	
	--Call procedures to validate CUV
	test: process
	begin
		wait until s_rst = '0';
		wait;
		--s_finishTest <= '1';
	end process test;
	
	--Instantiate external card deck memory (FIFO)
	deck_fifo: entity work.card_deck_memory
	port map
	(
		request => s_request,
		card => s_card
	);

	--Instantiate CUV
	cuv: entity work.blackjack
	generic map (CLK_EDGE => CLK_EDGE)
	port map
	(
		clk 	=> s_clk, 		
		reset 	=> s_rst, 		
		stay 	=> s_stay, 		
		hit	 	=> s_hit,	 	
		debug 	=> s_debug, 	
		show 	=> s_show, 		
		card	=> s_card,		
		request	=> s_request,	
		win		=> s_win,		
		lose	=> s_lose,		
		tie		=> s_tie,		
		total	=> s_total			
	);

end arch_tb_blackjack;
