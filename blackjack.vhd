--------------------------------------------------
-- File:    blackjack.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

entity blackjack is
	generic(
	CLK_EDGE    : std_logic := '1');

	port(
	clk 		: in std_logic; 
	reset 		: in std_logic; 
	stay 		: in std_logic; 
	hit	 		: in std_logic; 
	debug 		: in std_logic; 
	show 		: in std_logic; 
	card		: in std_logic_vector(3 downto 0);
	request		: out std_logic;
	win			: out std_logic; 
	lose		: out std_logic; 
	tie			: out std_logic; 
	total		: out std_logic_vector(4 downto 0));
end blackjack;


architecture arch_blackjack of blackjack is
	
	--Blackjact Finite State Machine type definition
	type fsm_state_type is (PLAYER_BEGIN_1, PLAYER_WAIT_1, DEALER_BEGIN_1, DEALER_WAIT_1, 
		PLAYER_BEGIN_2, PLAYER_WAIT_2, DEALER_BEGIN_2, DEALER_WAIT_2, 
		PLAYER_WAIT, PLAYER_HIT, DEALER_WAIT, DEALER_HIT, GAME_OVER, RESET_BLACKJACK );
	signal state		: fsm_state_type := RESET_BLACKJACK;
	signal next_state	: fsm_state_type := PLAYER_BEGIN_1;
	
	--shift registers used to board detector flag
	signal s_hit_reg_a, s_hit_reg_b, s_hit_rise, s_stay_reg_a, s_stay_reg_b, s_stay_rise : std_logic := '0';
	
	--Player deck controller signals
	signal s_player_start_in : std_logic := '0';
	signal s_player_buy_card_out : std_logic := '0';
	signal s_player_is_available_out : std_logic := '1';
	signal s_player_score_out : std_logic_vector(4 downto 0) := (others => '0');
	
	--Dealer deck controller signals
	signal s_dealer_start_in : std_logic := '0';
	signal s_dealer_buy_card_out : std_logic := '0';
	signal s_dealer_is_available_out : std_logic := '1';
	signal s_dealer_score_out : std_logic_vector(4 downto 0) := (others => '0');

	--Deck FIFO external module
	signal s_request_in : std_logic := '0';
	signal s_card_out : std_logic := '0';
	
begin

	--board detector process
	shift_reg: process(clk)
	begin
		if clk'event and clk = CLK_EDGE then
			if(reset = '1') then
				s_hit_reg_a <= '0';
				s_hit_reg_b <= '0';
				
				s_stay_reg_a <= '0';
				s_stay_reg_b <= '0';				
			else
				s_hit_reg_b <= s_hit_reg_a;
				s_hit_reg_a <= hit;
				
				s_stay_reg_b <= s_stay_reg_a;
				s_stay_reg_a <= stay;
			end if;
		end if;
	end process shift_reg;
	
	--Board detector signal
	s_hit_rise <= 	'1' when (s_hit_reg_a = '1') and (s_hit_reg_b = '0') else
					'0';
					
	s_stay_rise <= 	'1' when (s_stay_reg_a = '1') and (s_stay_reg_b = '0') else
					'0';					

	--Finite State Machine actual state
	fsm_transition: process(clk)
	begin
		if clk'event and clk = CLK_EDGE then
			if reset = '1' then
				state <= RESET_BLACKJACK;
			else
				state <= next_state;
			end if;
		end if;
	end process fsm_transition;

	--Finite State Machine future state
	fsm_next_state: process(state, s_player_is_available_out, s_dealer_is_available_out,
		s_hit_rise, s_stay_rise, s_player_score_out, s_dealer_score_out)
	begin
		case state is
			---------------------------------------------------------
			when PLAYER_BEGIN_1 =>
				--Send signal to player deck controller buy the first card and jump to next state
				next_state <= PLAYER_WAIT_1;
			----------------------------------------------------------
			when PLAYER_WAIT_1 =>
				--If Player received a card. Stop waiting and go give a card to the dealer.
				if(s_player_is_available_out = '1') then
					next_state <= DEALER_BEGIN_1;
				else
					--Keep waiting untill the player receives a new card.
					next_state <= PLAYER_WAIT_1;
				end if;
			----------------------------------------------------------
			when DEALER_BEGIN_1 =>
				--Send signal to dealer deck controller buy the first card and jump to next state
				next_state <= DEALER_WAIT_1;
			----------------------------------------------------------
			when DEALER_WAIT_1 =>
				--If Dealer received a card. Stop waiting and go give a card to the player.
				if(s_dealer_is_available_out = '1') then
					next_state <= PLAYER_BEGIN_2;
				else
					--Keep waiting untill the dealer receives a new card.
					next_state <= DEALER_WAIT_1;
				end if;
			---------------------------------------------------------
			when PLAYER_BEGIN_2 =>
				--Send signal to player deck controller buy the last card and jump to next state
				next_state <= PLAYER_WAIT_2;
			----------------------------------------------------------
			when PLAYER_WAIT_2 =>
				--If Player received a card. Stop waiting and go give a card to the dealer.
				if(s_player_is_available_out = '1') then
					next_state <= DEALER_BEGIN_2;
				else
					--Keep waiting untill the player receives a new card.
					next_state <= PLAYER_WAIT_2;
				end if;
			----------------------------------------------------------
			when DEALER_BEGIN_2 =>
				--Send signal to dealer deck controller buy the last card and jump to next state
				next_state <= DEALER_WAIT_2;
			----------------------------------------------------------
			when DEALER_WAIT_2 =>
				--If Dealer received a card. Stop waiting and Start the game (wait for player interaction)
				if(s_dealer_is_available_out = '1') then
					next_state <= PLAYER_WAIT;
				else
					--Keep waiting untill the dealer receives a new card.
					next_state <= DEALER_WAIT_2;
				end if;				
			----------------------------------------------------------			
			when PLAYER_WAIT =>
				--Only read player inputs if deck controller is available
				if(s_player_is_available_out = '1') then
				
					--Player loses automatically if score is greater than 21
					if(s_player_score_out > 21) then
						next_state <= GAME_OVER;
					
					--If player pressed both 'hit' and 'stay' buttons at the same time, ignore instruction.
					elsif(s_hit_rise = '1' and s_stay_rise = '1') then
						next_state <= PLAYER_WAIT;
					
					--Stay button: player ends and dealer starts playing
					elsif(s_stay_rise = '1') then
						next_state <= DEALER_WAIT;
					
					--Hit button: player asked for a new card
					elsif(s_hit_rise = '1') then
						next_state <= PLAYER_HIT;
					
					--Unexpected signal: keep waiting
					else
						next_state <= PLAYER_WAIT;
					
					end if;
				else
					--Player deck is not ready: wait untill becomes available
					next_state <= PLAYER_WAIT;
				end if;
			----------------------------------------------------------
			when PLAYER_HIT =>
				--Send signal to player deck controller buy a new card and jump to next state
				next_state <= PLAYER_WAIT;
			----------------------------------------------------------
			when DEALER_WAIT =>
				--Only evaluate dealer score if deck controller is available
				if(s_dealer_is_available_out = '1') then
				
					--Dealer stops playing if score is greather than 16
					if(s_dealer_score_out > 16) then
						next_state <= GAME_OVER;
						
					--Didn't reach score goal: buy a new card
					else
						next_state <= DEALER_HIT;
					end if;
				else
					--Dealer deck is not ready: wait untill becomes available
					next_state <= DEALER_WAIT;
				end if;
			----------------------------------------------------------
			when DEALER_HIT =>
				--Send signal to dealer deck controller buy a new card and jump to next state
				next_state <= DEALER_WAIT;
			----------------------------------------------------------
			when GAME_OVER =>
				--End of the game: player shall press the RESET button to start again
				next_state <= GAME_OVER;
			----------------------------------------------------------
			when others => --RESET (Initial condition)
				next_state <= PLAYER_BEGIN_1;
		end case;
	end process fsm_next_state;
	
	--Player deck instantiation
	player_deck: entity work.deck_controller
	generic map 
	(
		CLK_EDGE => CLK_EDGE,
		IS_FIRST_TO_PLAY => '1'
	)
	port map
	(
		clk_in => clk,
		rst_in => reset,		
		start_in => s_player_start_in,	
		encoded_card_in => card,
		buy_card_out => s_player_buy_card_out,
		is_available_out => s_player_is_available_out,
		score_out => s_player_score_out
	);
	
	--Dealer deck instantiation
	dealer_deck: entity work.deck_controller
	generic map 
	(
		CLK_EDGE => CLK_EDGE,
		IS_FIRST_TO_PLAY => '0'
	)
	port map
	(
		clk_in => clk,
		rst_in => reset,
		start_in => s_dealer_start_in,	
		encoded_card_in => card,
		buy_card_out => s_dealer_buy_card_out,
		is_available_out => s_dealer_is_available_out,
		score_out => s_dealer_score_out
	);
	
	--Send signal to player deck controller start the card requisition process
	s_player_start_in <=	'1' when (state = PLAYER_BEGIN_1) or (state = PLAYER_BEGIN_2) or (state = PLAYER_HIT) else
							'0';
							
	--Send signal to dealer deck controller start the card requisition process
	s_dealer_start_in <=	'1' when (state = DEALER_BEGIN_1) or (state = DEALER_BEGIN_2) or (state = DEALER_HIT) else
							'0';

	--External deck FIFO card request mux
	request <=	s_player_buy_card_out when s_player_is_available_out = '0' else
				s_dealer_buy_card_out when s_dealer_is_available_out = '0' else
				'0';
	
	--Player win signal is displayed when game ends, score is not above 21 and higher than dealer score
	win <=	'1' when next_state = GAME_OVER and s_player_score_out <= 21 and ((s_dealer_score_out > 21) or (s_player_score_out > s_dealer_score_out)) else
			'0';
			
	--Player lose signal is displayed when game ends, score is above 21 or lower than dealer score		
	lose <=	'1' when next_state = GAME_OVER and s_dealer_score_out <= 21 and ((s_player_score_out > 21) or (s_player_score_out < s_dealer_score_out)) else
			'0';
			
	--Game tie signal is displayed when game ends, player and dealer score are equal
	tie <=	'1' when next_state = GAME_OVER and s_player_score_out = s_dealer_score_out else
			'0';
			
	--Total score output: display player score or dealer score according to the table below:
	--	state signal	|	DEBUG input	|	SHOW input	|	TOTAL output
	--		x			|		1		|		0		|	player score
	--		x			|		1		|		1		|	dealer score
	--	GAME_OVER		|		x		|		0		|	player score
	--	GAME_OVER		|		x		|		1		|	dealer score
	--		x			|		x		|		0		|	player score
	total <=	s_dealer_score_out when show = '1' and ((state = GAME_OVER) or (debug = '1')) else
				s_player_score_out;
	
end arch_blackjack;