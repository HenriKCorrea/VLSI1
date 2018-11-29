library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity blackjack is
	port (
		CLK     : in  STD_LOGIC;
		RESET   : in  STD_LOGIC;
		STAY    : in  STD_LOGIC;
		HIT     : in  STD_LOGIC;
		DEBUG   : in  STD_LOGIC;
		SHOW    : in  STD_LOGIC;
		WIN     : out STD_LOGIC;
		LOSE    : out STD_LOGIC;
		TIE     : out STD_LOGIC;
		TOTAL   : out STD_LOGIC_VECTOR (4 downto 0);
		REQUEST : out STD_LOGIC;
		CARD    : in  STD_LOGIC_VECTOR (3 downto 0)
	);
end blackjack;

architecture blackjack_behavior of blackjack is
	signal player_card, player_card_latched : integer range 0 to 63;
	signal dealer_card, dealer_card_latched : integer range 0 to 63;
	signal add_to_player : std_logic;
	signal add_to_dealer : std_logic;

	type type_state is (
		s_reset,
		s_stabilize,

		s_check_player_0,
		s_give_player_0,
		s_check_dealer_0,
		s_give_dealer_0,
		s_check_player_1,
		s_give_player_1,
		s_check_dealer_1,
		s_give_dealer_1,

		s_wait,

		s_check_player_2,
		s_give_player_2,
		s_check_dealer_2,
		s_give_dealer_2,

		s_comp,

		s_win,
		s_tie,
		s_lose
	);
	signal CurrS, NextS : type_state;

	signal POSITIVE_REQUEST : std_logic;

	signal IS_GAME_OVER_STATE : std_logic;

	signal IS_CARD_VALID : std_logic;

	signal IS_DEALER_REQUEST_STATE, IS_PLAYER_REQUEST_STATE : std_logic;
	signal IS_DEALER_GIVING_STATE, IS_PLAYER_GIVING_STATE : std_logic;
	signal IS_NEXT_CHECK : std_logic;
begin
	WIN  <= '1' when (CurrS = s_win) else '0';
	TIE  <= '1' when (CurrS = s_tie) else '0';
	LOSE <= '1' when (CurrS = s_lose) else '0';

	IS_GAME_OVER_STATE <= '1' when (CurrS = s_win or CurrS = s_tie or CurrS = s_lose) else '0';

	TOTAL <= std_logic_vector(to_unsigned(dealer_card, TOTAL'length)) when ((DEBUG = '1' or IS_GAME_OVER_STATE = '1') and SHOW = '1') else
			std_logic_vector(to_unsigned(player_card_latched, TOTAL'length));

	IS_CARD_VALID <=  '0' when (CARD = "0000" or CARD = "1110" or CARD = "1111") else '1';

	NextS <=	s_stabilize when (CurrS = s_reset and RESET = '0') else

				s_check_player_0 when (CurrS = s_stabilize) else
				s_check_player_0 when (CurrS = s_check_player_0 and IS_CARD_VALID = '0') else
				s_give_player_0 when (CurrS = s_check_player_0 and IS_CARD_VALID = '1') else
				s_check_dealer_0 when (CurrS = s_give_player_0) else
				s_check_dealer_0 when (CurrS = s_check_dealer_0 and IS_CARD_VALID = '0') else
				s_give_dealer_0 when (CurrS = s_check_dealer_0 and IS_CARD_VALID = '1') else

				s_check_player_1 when (CurrS = s_give_dealer_0) else
				s_check_player_1 when (CurrS = s_check_player_1 and IS_CARD_VALID = '0') else
				s_give_player_1 when (CurrS = s_check_player_1 and IS_CARD_VALID = '1') else
				s_check_dealer_1 when (CurrS = s_give_player_1) else
				s_check_dealer_1 when (CurrS = s_check_dealer_1 and IS_CARD_VALID = '0') else
				s_give_dealer_1 when (CurrS = s_check_dealer_1 and IS_CARD_VALID = '1') else

				s_wait when (CurrS = s_give_dealer_1) else
				s_wait when (CurrS = s_wait and HIT='0' and STAY='0') else
				s_wait when (CurrS = s_wait and HIT='1' and STAY='1') else

				s_check_player_2 when (CurrS = s_wait and HIT = '1') else
				s_check_player_2 when (CurrS = s_check_player_2 and IS_CARD_VALID = '0') else
				s_give_player_2 when (CurrS = s_check_player_2 and IS_CARD_VALID = '1') else
				s_lose when (CurrS = s_give_player_2 and player_card >= 22) else
				s_wait when (CurrS = s_give_player_2 and player_card < 22) else

				s_check_dealer_2 when (CurrS = s_wait and STAY='1') else
				s_check_dealer_2 when (CurrS = s_check_dealer_2 and IS_CARD_VALID = '0') else
				s_give_dealer_2 when (CurrS = s_check_dealer_2 and IS_CARD_VALID = '1') else
				s_check_dealer_2 when (CurrS = s_give_dealer_2 and dealer_card <= 16) else
				s_win when (CurrS = s_give_dealer_2 and dealer_card >= 22) else
				s_comp when (CurrS = s_give_dealer_2 and dealer_card > 16) else
				s_win when (CurrS = s_comp and player_card > dealer_card) else
				s_lose when (CurrS = s_comp and player_card < dealer_card) else
				s_tie when (CurrS = s_comp and player_card = dealer_card) else
				s_tie when (CurrS = s_tie) else
				s_win when (CurrS = s_win) else
				s_lose;

	IS_PLAYER_REQUEST_STATE <= '1' when (CurrS = s_check_player_0 or CurrS = s_check_player_1 or CurrS = s_check_player_2) else '0';
	IS_DEALER_REQUEST_STATE <= '1' when (CurrS = s_check_dealer_0 or CurrS = s_check_dealer_1 or CurrS = s_check_dealer_2) else '0';

	IS_PLAYER_GIVING_STATE <= '1' when (CurrS = s_give_player_0 or CurrS = s_give_player_1 or CurrS = s_give_player_2) else '0';
	IS_DEALER_GIVING_STATE <= '1' when (CurrS = s_give_dealer_0 or CurrS = s_give_dealer_1 or CurrS = s_give_dealer_2) else '0';

	IS_NEXT_CHECK <= '1' when (NextS = s_check_player_0 or NextS = s_check_player_1 or NextS = s_check_player_2 or NextS = s_check_dealer_0 or NextS = s_check_dealer_1 or NextS = s_check_dealer_2) else '0';

	add_to_player <= '1' when (IS_PLAYER_GIVING_STATE = '1') else '0';
	add_to_dealer <= '1' when (IS_DEALER_GIVING_STATE = '1') else '0';

	REQUEST <= '0' when (RESET = '1') else
		POSITIVE_REQUEST when (IS_PLAYER_REQUEST_STATE = '1' or IS_DEALER_REQUEST_STATE = '1') else
		'0';

	user_controller: entity work.card_controller port map(
		RESET => RESET,
		CARD =>  CARD,
		TOTAL => player_card,
		ADD =>   add_to_player
	);

	machine_controller: entity work.card_controller port map(
		RESET => RESET,
		CARD =>  CARD,
		TOTAL => dealer_card,
		ADD =>   add_to_dealer
	);

	state_machine_transition : process(CLK)
	begin
		if (rising_edge(CLK)) then
			if (RESET = '1') then
				CurrS <= s_reset;
				-- Reset request card logic
				POSITIVE_REQUEST <= '0';
				-- Card Latch Logic
				player_card_latched <= player_card;
				dealer_card_latched <= dealer_card;
			elsif (CurrS = NextS and IS_NEXT_CHECK='1') then
				-- Request card logic
				POSITIVE_REQUEST <= not POSITIVE_REQUEST;
				-- Card Latch Logic
				player_card_latched <= player_card_latched;
				dealer_card_latched <= dealer_card_latched;
			else
				if (NextS /= s_check_player_0 and IS_NEXT_CHECK='1') then
					POSITIVE_REQUEST <= '1';
				else
					POSITIVE_REQUEST <= '0';
				end if;
				-- Reset request card logic
				-- Card Latch Logic for player
				if (IS_PLAYER_GIVING_STATE = '1' and CurrS /= NextS) then
					player_card_latched <= player_card;
				else
					player_card_latched <= player_card_latched;
				end if;
				-- Card Latch Logic for dealer
				if (IS_DEALER_GIVING_STATE = '1' and CurrS /= NextS) then
					dealer_card_latched <= dealer_card;
				else
					dealer_card_latched <= dealer_card_latched;
				end if;
				-- Actual Transition
				CurrS <= NextS;
			end if;
		end if;
	end process;

end blackjack_behavior;

