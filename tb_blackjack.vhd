--------------------------------------------------
-- File:    tb_blackjack.vhd
-- Author:  Henrique Krausburg Correa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

--Comentários:
--tempo de inicialização (depois de reset, melhor caso): 150 ns
--tempo de compra de carta (melhor caso): 30 ns
--tempo de penalidade carta invalida: 10 ns

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;

library work;
	use work.pkg_tb_blackjack.all;

entity tb_blackjack is
end tb_blackjack;


architecture arch_tb_blackjack of tb_blackjack is

	--Auxiliary state to show current test when debugging waveform in ModelSim
	type t_testset is (STARTING, PREPARING_NEXT_TEST, TEST_1_PLAYER_WIN, TEST_2_PLAYER_LOSE, TEST_3_TIE, TEST_4_ACE_ONLY, TEST_5_PLAYER_PASSING_21, TEST_6_DEALER_PASSING_21, TEST_7_DECODE_ALL_CARDS, TEST_8_HIT_STAY, FINISH);

	--Auxiliary constants
	constant 	CLK_EDGE    	: std_logic := '1';
	constant 	INV_CLK_EDGE    : std_logic := not CLK_EDGE;
	constant	PERIOD			: time := 5 ns;	-- period for 200MHz .
	constant	HALF_PERIOD		: time := 2.5 ns;

	--Auxiliary signals
	signal s_finishTest: std_logic := '0';			--Flag to indicate if test finish
	signal s_currentTest: t_testset := STARTING;	--Auxiliary state to show current test when debugging waveform in ModelSim

	signal s_test_number : natural range 0 to 8 := 1;

	type t_card_mux is array (0 to 8) of std_logic_vector(3 downto 0);
	signal s_card_mux : t_card_mux;
	type t_request_mux is array (0 to 8) of std_logic;
	signal s_request_mux : t_request_mux;
	
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
	
	--Call procedures to validate CUV
	test: process
	begin
		s_currentTest <= TEST_1_PLAYER_WIN;
		test_1_success_win(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_2_PLAYER_LOSE;
		test_2_player_lose(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_3_TIE;
		test_3_tie(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_4_ACE_ONLY;
		test_4_ace_only(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_5_PLAYER_PASSING_21;
		test_5_player_passing_21(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_6_DEALER_PASSING_21;
		test_6_dealer_passing_21(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;

		s_currentTest <= TEST_7_DECODE_ALL_CARDS;
		test_7_decode_all_cards(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		s_test_number <= s_test_number + 1;
		
		s_currentTest <= TEST_8_HIT_STAY;
		test_8_hit_stay_press_test(s_clk, s_rst, s_stay, s_hit, s_debug, s_show, s_card, s_request, s_win, s_lose, s_tie, s_total);
		
		--End test
		s_currentTest <= FINISH; s_finishTest <= '1'; wait until s_clk = '0'; wait;	
	end process test;
	
	--Instantiate external card deck memory (FIFO)
	gen_deck_fifo: for i in 0 to 8 generate
		deck_fifo: entity work.card_deck_memory
		generic map
		(
			TEST_NUMBER => i
		)
		port map
		(
			request => s_request_mux(i),
			card => s_card_mux(i)
		);	
	end generate gen_deck_fifo;

	--Instantiate CUV
	cuv: entity work.blackjack
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

	s_card <= s_card_mux(s_test_number);
	s_request_mux(s_test_number) <= s_request;

end arch_tb_blackjack;
