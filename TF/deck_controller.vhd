--------------------------------------------------
-- File:    deck_controller.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

entity deck_controller is
	generic(
	CLK_EDGE    : std_logic := '1');
	
	port(
	clk_in 					: in std_logic; 
	rst_in 					: in std_logic;
	start_in				: in std_logic;
	encoded_card_in			: in std_logic_vector(3 downto 0);	
	buy_card_out			: out std_logic;
	is_available_out	: out std_logic;
	score_out				: out std_logic_vector(4 downto 0));
end deck_controller;


architecture arch_deck_controller of deck_controller is
	
	--Ace card value after being decoded
	constant ACE: std_logic_vector(4 downto 0) := "00001";
	
	--state machine.
	type fsm_state_type is (RESET, IDLE, BUY_CARD, DECODE_CARD, CALCULATE_SCORE, EVALUATE_ACE);
	signal state		: fsm_state_type := IDLE;
	signal next_state	: fsm_state_type := IDLE;
	
	--Holds the card value after decoding it
	signal s_decoded_card	: std_logic_vector(3 downto 0) := "0000";
	
	--Describe if this entity is waiting for an external signal to start working.
	signal s_is_available : std_logic := '1';
	
	--The user score
	signal s_score : std_logic_vector(4 downto 0) := "00000";
begin
	
	fsm_transition: process(clk_in)
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				state <= RESET;
			else
				state <= next_state;
			end if;
		end if;
	end process fsm_transition;

	fsm_next_state_decoder: process(state, start_in)
	begin
		case state is
			---------------------------------------------------------
			when IDLE => 
				--wait to receive signal to buy a new card
				if(start_in = '1') then
					next_state <= BUY_CARD;
				else
					--Keep waiting
					next_state <= IDLE;
				end if;
			----------------------------------------------------------
			when BUY_CARD =>
				--Wait one cycle to receive a new card
				next_state <= DECODE_CARD;
			----------------------------------------------------------
			when DECODE_CARD =>
				--If decoded value is valid, calculate new score
				if(s_decoded_card /= "00000") then
					next_state <= CALCULATE_SCORE;
				else
					--Invalid card: buy a new one
					next_state <= BUY_CARD;
				end if;
			----------------------------------------------------------
			when CALCULATE_SCORE =>
				--Sum the decoded card value with the user score
				next_state <= EVALUATE_ACE;
			----------------------------------------------------------
			when EVALUATE_ACE =>
				--Check ace condition, show the new calculated score to the user and wait for the next call
				next_state <= IDLE;
			----------------------------------------------------------
			when others => --RESET (Initial condition)
				next_state <= IDLE;
		end case;
	end process fsm_next_state_decoder;
	
	calculate_score_proc: process(clk_in)
		--Flag that says if user is holding an ace with value 11 that can be casted to value 1
		variable v_ace_in_the_hole : boolean := false;		
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				v_ace_in_the_hole := false;
				s_score <= "00000";
			elsif(next_state = CALCULATE_SCORE) then
				--Calculate new score
				s_score <= s_score + s_decoded_card;
						
			elsif(next_state = EVALUATE_ACE) then
				--If decoded card is an ACE and the actual score is lower than 11, consider the ACE value as 11 and set the ACE flag
				if(s_decoded_card = ACE and s_score <= 11) then
					s_score <= s_score + 10;
					v_ace_in_the_hole := true;
					
				--If the user is about to lose and have an ACE in the hole, use it to reduce the score and keep playing
				elsif(s_score > 21 and v_ace_in_the_hole = true) then
					s_score <= s_score - 10;
					v_ace_in_the_hole := false;
				end if;
			end if;
		end if;
	end process calculate_score_proc;	
	
	--Controls busy-wait flag
	s_is_available <=	'1' when state = RESET or state = IDLE else
							'0';
							
	is_available_out <= s_is_available;
	
	--Asks for a new card according to FSM state
	buy_card_out <=	'1' when state = BUY_CARD else
					'0';
	
	--Decode requested card
	s_decoded_card <=	encoded_card_in when s_is_available = '0' and encoded_card_in < 10 else	--Card is invalid (0) or an A, 2, 3, 4, 5, 6, 7, 8 or 9
						x"A" when s_is_available = '0' and encoded_card_in < 14 else	-- Card is 10, J, Q or K
						"0000";	--Invalid decoded value	
						
	--Displays score. While working, displays the previus calculated score
	score_out <= s_score when s_is_available = '1';
	
end arch_deck_controller;