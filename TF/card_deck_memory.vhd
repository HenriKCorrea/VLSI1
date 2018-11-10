--------------------------------------------------
-- File:    card_deck_memory.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;

entity card_deck_memory is
	generic (
		TEST_NUMBER : natural := 0
	);	
	port(
	request		: in std_logic;
	card		: out std_logic_vector(3 downto 0));
end card_deck_memory;


architecture arch_card_deck_memory of card_deck_memory is	
	
	--Revert cards bit order to avoid write tests from right to left.
	function reverse_any_vector (a: in std_logic_vector)
	return std_logic_vector is
		variable result: std_logic_vector(a'RANGE);
		alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
		variable i: integer range 0 to a'length := 0;
	begin
		while (i < a'length) loop
			result(i + 3) := aa(i);
			result(i + 2) := aa(i + 1);
			result(i + 1) := aa(i + 2);
			result(i) := aa(i + 3);
			i := i + 4;
		end loop;
		return result;
	end reverse_any_vector;
	

	--Revert cards bit order to avoid write tests from right to left.
	function get_test (number: in natural)
	return std_logic_vector is
		--Set tests definition HERE!
		--Convention: constant TEST_NAME : std_logic_cector := x"<first card>.......<last card>"
		constant FIRST_CARD : std_logic_vector := x"0";							--Mandatory: the first card is not consumed by anyone
		constant TEST_1 : std_logic_vector := x"6d126844";						--Test 1: Successfull gameplay: Player wins. Expected player score: 0, 6, 17, 13 and 21. Expected dealer score: 0, 10, 12, 16 and 20
		constant TEST_2 : std_logic_vector := x"cab65";							--Test 2: Successfull gameplay: Player loses. Expected player score: 0, 10 and 20. Expected dealer score: 0, 10, 16 and 21
		constant TEST_3 : std_logic_vector := x"cab64";							--Test 3: Successfull gameplay: Tie. Expected player score: 0, 10 and 20. Expected dealer score: 0, 10, 16 and 20
		constant TEST_4 : std_logic_vector := x"1111111111111111111111111111";	--Test 4: Successfull gameplay: ACE only
		constant TEST_5 : std_logic_vector := x"cab6b";							--Test 5: Player loses for passing 21. Expected player score: 0, 10, 20 and 30. Expected dealer score: 0, 10 and 16
		constant TEST_6 : std_logic_vector := x"c1b59a";						--Test 6: Dealer loses for passing 21. Expected player score: 0, 10, and 20. Expected dealer score: 0, 11, 16, 15 and 25
		constant TEST_7 : std_logic_vector := x"fdecba9876504321";				--Test 7: Decode all kind of cards (valids and invalids) f(invalid) e(invalid) d(10) c(10) b(10) a(10)
																				--First round: tie - Player (0 + 0 + 10 + 10 = 20) Dealer (10 + 10 = 20) 
																				--Second round: Player (9 + 7 = 16) Dealer(8 + 6 + 5 = 19)
																				--Third round: Player (0 + 4 + 2 = 6) Dealer(3 + 1 = 4)	
		constant TEST_8 : std_logic_vector := x"cab61";							--Test 8: Successfull gameplay: Player wins. Expected player score: 0, 10, 20 and 21. Expected dealer score: 0, 10 and 16
	begin
		case( number ) is
			when 1 => return TEST_1;
			when 2 => return TEST_2;
			when 3 => return TEST_3;
			when 4 => return TEST_4;
			when 5 => return TEST_5;
			when 6 => return TEST_6;
			when 7 => return TEST_7;
			when 8 => return TEST_8;
			when others => return x"000";
		end case ;

		return TEST_1;
	end get_test;
	
	--TEST_SET: Set all tests to be applied HERE!
	--constant TEST_SET : std_logic_vector := FIRST_CARD & TEST_1 & TEST_2 & TEST_3 & TEST_4 & TEST_5 & TEST_6 & TEST_7 & TEST_8;
	constant TEST_SET : std_logic_vector := get_test(TEST_NUMBER);

	--Queue holding all tests cards in the correct order
	signal queue : std_logic_vector(TEST_SET'reverse_range) := reverse_any_vector(TEST_SET);
begin

	fifo_rotate: process(request)
	begin
		if(request'event and request = '1') then
			queue <= "0000" & queue(queue'high downto queue'low + 4);
		end if;
	end process fifo_rotate;
	
	card <= queue(3 downto 0);
	
end arch_card_deck_memory;
	