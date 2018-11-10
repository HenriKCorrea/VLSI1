library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity card_controller is
	generic (
		CARD_A  : std_logic_vector(3 downto 0) := "0001";
		CARD_2  : std_logic_vector(3 downto 0) := "0010";
		CARD_3  : std_logic_vector(3 downto 0) := "0011";
		CARD_4  : std_logic_vector(3 downto 0) := "0100";
		CARD_5  : std_logic_vector(3 downto 0) := "0101";
		CARD_6  : std_logic_vector(3 downto 0) := "0110";
		CARD_7  : std_logic_vector(3 downto 0) := "0111";
		CARD_8  : std_logic_vector(3 downto 0) := "1000";
		CARD_9  : std_logic_vector(3 downto 0) := "1001";
		CARD_10 : std_logic_vector(3 downto 0) := "1010";
		CARD_11 : std_logic_vector(3 downto 0) := "1011";
		CARD_12 : std_logic_vector(3 downto 0) := "1100";
		CARD_13 : std_logic_vector(3 downto 0) := "1101"
	);
	port (
		RESET : in  std_logic;
		ADD   : in  std_logic;
		CARD  : in  std_logic_vector (3 downto 0);
		TOTAL : out integer range 0 to 63
	);
end card_controller;

architecture card_controller_behaviour of card_controller is
	signal card_value      : integer range 0 to 63;
	signal next_card_value : integer range 0 to 31;
	signal cards_received  : integer range 0 to 63;
	signal has_high_A      : std_logic;
begin
	TOTAL <= card_value;

	-- Treating edge cases as ZERO
	next_card_value <= 1 when CARD = CARD_A else
		2  when CARD = CARD_2 else
		3  when CARD = CARD_3 else
		4  when CARD = CARD_4 else
		5  when CARD = CARD_5 else
		6  when CARD = CARD_6 else
		7  when CARD = CARD_7 else
		8  when CARD = CARD_8 else
		9  when CARD = CARD_9 else
		10 when CARD = CARD_10 else
		10 when CARD = CARD_11 else
		10 when CARD = CARD_12 else
		10 when CARD = CARD_13 else
		0;

	handle_additions : process(RESET, ADD)
	begin
		if (RESET = '1') then
			card_value <= 0;
			has_high_A <= '0';
			cards_received <= 0;
		elsif (rising_edge(ADD)) then
			cards_received <= cards_received + 1;
			if (card_value+next_card_value > 21 and has_high_A = '1') then
				-- has a high A and will overflow
				card_value <= card_value + next_card_value - 10;
				has_high_A <= '0';
			elsif (next_card_value = 1 and card_value < 11 and has_high_A = '0') then
				-- (it's an A) and (is low enough to gain 11) and (don't have a high A)
				card_value <= card_value + 11;
				has_high_A <= '1';
			else
				card_value <= card_value + next_card_value;
			end if;
		end if;
	end process;
end card_controller_behaviour;

