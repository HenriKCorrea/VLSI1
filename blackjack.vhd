-- Blackjack by Guilherme Rossato and Marcos Sokolowski

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity blackjack is
   generic (
		GIVE_UP_VALUE : integer range 0 to 21 := 17
	);
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

architecture blackjack_behavioral of blackjack is
	signal user_card : integer range 0 to 63;
	signal machine_card : integer range 0 to 63;
	signal add_to_user : std_logic;
	signal add_to_machine : std_logic;

	type type_state is (
		s_reset,
		s_stabilize,

		s_request_first_card_user,
		s_giving_first_card_user,
		s_request_first_card_machine,
		s_giving_first_card_machine,
		s_request_card_user,
		s_giving_card_user,
		s_request_card_machine,
		s_giving_card_machine,
		s_waiting_user_input,

		s_user_win,
		s_draw,
		s_machine_win
	);
	signal CurrS, NextS : type_state;

	signal POSITIVE_REQUEST : std_logic;

	signal IS_GAME_OVER_STATE, IS_USER_REQUEST_STATE, IS_MACHINE_REQUEST_STATE : std_logic;

	signal IS_CARD_VALID : std_logic;
	
	signal USER_HAS_PRESSED_STAY, USER_HAS_BETTER_CARDS : std_logic;
begin
	WIN  <= '1' when (CurrS = s_user_win) else '0';
	TIE  <= '1' when (CurrS = s_draw) else '0';
	LOSE <= '1' when (CurrS = s_machine_win) else '0';

	IS_GAME_OVER_STATE <= '1' when (CurrS = s_user_win or CurrS = s_draw or CurrS = s_machine_win) else '0';

	TOTAL <= std_logic_vector(to_unsigned(machine_card, TOTAL'length)) when ((DEBUG = '1' or IS_GAME_OVER_STATE = '1') and SHOW = '1') else
				std_logic_vector(to_unsigned(user_card, TOTAL'length));

	IS_CARD_VALID <=  '0' when (CARD = "0000" or CARD = "1110" or CARD = "1111") else '1';

	USER_HAS_BETTER_CARDS <= '1' when (user_card > machine_card) else '0';

	-- Normal startup cycle
	NextS <=	s_user_win when (CurrS = s_user_win) else
				s_draw when (CurrS = s_draw) else
				s_machine_win when (CurrS = s_machine_win) else
				s_stabilize when (CurrS = s_reset) else
				s_request_first_card_user when (CurrS = s_stabilize and IS_CARD_VALID = '0') else
				s_request_first_card_user when (CurrS = s_request_first_card_user and IS_CARD_VALID = '0') else
				s_giving_first_card_user when ((CurrS = s_stabilize or CurrS = s_request_first_card_user) and IS_CARD_VALID = '1') else

				s_request_first_card_machine when (CurrS = s_giving_first_card_user) else
				s_request_first_card_machine when (CurrS = s_request_first_card_machine and IS_CARD_VALID = '0') else
				s_giving_first_card_machine when (CurrS = s_request_first_card_machine and IS_CARD_VALID = '1') else

				s_request_card_user when (CurrS = s_giving_first_card_machine) else
				s_request_card_user when (CurrS = s_request_card_user and IS_CARD_VALID = '0') else
				s_giving_card_user when (CurrS = s_request_card_user and IS_CARD_VALID = '1') else

				s_request_card_machine when (CurrS = s_giving_card_user) else
				s_request_card_machine when (CurrS = s_request_card_machine and IS_CARD_VALID = '0') else
				s_giving_card_machine when (CurrS = s_request_card_machine and IS_CARD_VALID = '1' and not (machine_card >= GIVE_UP_VALUE)) else
				s_request_card_machine when (USER_HAS_PRESSED_STAY = '1' and not (machine_card >= GIVE_UP_VALUE)) else

				s_user_win when (USER_HAS_PRESSED_STAY = '1' and machine_card > 21) else
				s_user_win when (USER_HAS_PRESSED_STAY = '1' and machine_card >= GIVE_UP_VALUE and USER_HAS_BETTER_CARDS = '1') else
				s_draw when (USER_HAS_PRESSED_STAY = '1' and machine_card >= GIVE_UP_VALUE and USER_HAS_BETTER_CARDS = '0' and machine_card = user_card) else
				s_machine_win when (USER_HAS_PRESSED_STAY = '1' and machine_card >= GIVE_UP_VALUE and USER_HAS_BETTER_CARDS = '0') else
				s_request_card_machine when (USER_HAS_PRESSED_STAY = '1' and IS_CARD_VALID = '0') else
				s_giving_card_machine when (USER_HAS_PRESSED_STAY = '1' and IS_CARD_VALID = '1' and not (machine_card >= GIVE_UP_VALUE)) else

				s_draw when (USER_HAS_PRESSED_STAY = '1' and machine_card = user_card) else
				s_user_win when (USER_HAS_PRESSED_STAY = '1' and user_card > machine_card) else

				s_waiting_user_input;

	IS_USER_REQUEST_STATE <= '1' when (CurrS = s_request_first_card_user or CurrS = s_request_card_user) else '0';
	IS_MACHINE_REQUEST_STATE <= '1' when (CurrS = s_request_first_card_machine or CurrS = s_request_card_machine) else '0';

	add_to_user <= '1' when ((CurrS = s_giving_first_card_user or CurrS = s_giving_card_user) and IS_CARD_VALID = '1') else '0';			
	add_to_machine <= '1' when ((CurrS = s_giving_first_card_machine or CurrS = s_giving_card_machine) and IS_CARD_VALID = '1') else '0';

	REQUEST <= '0' when (RESET = '1') else
				  POSITIVE_REQUEST when (IS_USER_REQUEST_STATE = '1' or IS_MACHINE_REQUEST_STATE = '1') else
				  '1' when (CurrS = s_waiting_user_input) else
				  '0';

	user_controller: entity work.card_controller port map(
		RESET => RESET,
		CARD =>  CARD,
		TOTAL => user_card,
		ADD =>   add_to_user
	);

	machine_controller: entity work.card_controller port map(
		RESET => RESET,
		CARD =>  CARD,
		TOTAL => machine_card,
		ADD =>   add_to_machine
	);

	state_machine_transition : process(CLK)
	begin
		if (rising_edge(CLK)) then
			if (RESET = '1') then
				CurrS <= s_reset;
				POSITIVE_REQUEST <= '0';
				USER_HAS_PRESSED_STAY <= '0';
			elsif (NextS = s_waiting_user_input and STAY = '1' and HIT = '0') then
				USER_HAS_PRESSED_STAY <= '1';
				if (user_card = 21 and machine_card = 21) then
					-- Draw when the user stays and won
					CurrS <= s_draw;
				else
					if (IS_CARD_VALID = '0') then
						CurrS <= s_request_card_machine;
					else
						CurrS <= s_giving_card_machine;
					end if;
				end if;
			elsif (NextS = s_waiting_user_input and user_card > 21) then
				-- user cards > 21 = machine win
				CurrS <= s_machine_win;
			elsif (NextS = s_waiting_user_input and machine_card > 21) then
				-- machine cards > 21 = user win
				CurrS <= s_user_win;
			elsif (NextS = s_waiting_user_input and STAY = '0' and HIT = '1') then
				-- HIT normal press
				if (IS_CARD_VALID = '0') then
					CurrS <= s_request_card_user;
				else
					CurrS <= s_giving_card_user;
				end if;
			elsif (NextS = s_waiting_user_input and STAY = '1' and HIT = '1') then
				-- Does not exit the waiting state when both STAY and HIT are on
				CurrS <= s_waiting_user_input;
			elsif (NextS = s_request_first_card_user or NextS = s_request_card_user or NextS = s_request_first_card_machine or NextS = s_request_card_machine) then
				if (CurrS /= NextS) then
					-- We exited the state and the card was accepted
					POSITIVE_REQUEST <= '1';
				else
					-- We did not exit the state, so the card is unnaceptable, let's wait for 1 cycle:
					POSITIVE_REQUEST <= not POSITIVE_REQUEST;
				end if;
				CurrS <= NextS;
			else
				CurrS <= NextS;
			end if;
		end if;
	end process;

end blackjack_behavioral;

