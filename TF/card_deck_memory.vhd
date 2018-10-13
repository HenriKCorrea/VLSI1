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
	
	--Set tests definition HERE!
	--Convention: constant TEST_NAME : std_logic_cector := x"<first card>.......<last card>"
	constant FIRST_CARD : std_logic_vector := x"0";	--Mandatory: the first card is not consumed by 
	constant TEST_1 : std_logic_vector := x"6d126841";
	constant TEST_2 : std_logic_vector := x"cab65";
	
	--TEST_SET: Set all tests to be applied HERE!
	constant TEST_SET : std_logic_vector := FIRST_CARD & TEST_1 & TEST_2;
	
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
	