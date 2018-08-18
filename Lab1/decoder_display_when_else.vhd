---------------------------------------------------------------------------------------------
--File:             decoder_display_when_else.vhd
--Developer:        Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
--Description:      Laboratory 1: 7 segment display decoder using when / else structure
---------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all

entity decoder is
port
(
	abcd:		in std_logic_vector(3 downto 0),
	display:	out std_logic_vector(6 downto 0)
);
end decoder;

architecture decoder_arch of decoder is
begin

display <= 	"1111110" when "0000" else --0
			"0110000" when "0001" else --1
			"1101101" when "0010" else --2
			"1111001" when "0011" else --3
			"0110011" when "0100" else --4
			"1011011" when "0101" else --5
			"1011111" when "0110" else --6
			"1110000" when "0111" else --7
			"1111111" when "1000" else --8
			"1111011" when "1001" else --9
			"1110111" when "1010" else --A
			"0011111" when "1011" else --b
			"0001101" when "1100" else --c
			"0111101" when "1101" else --d
			"1001111" when "1110" else --E
			"1000111" when "1111" else --F
			"0000000"  				   --Default behavior

end decoder_arch;