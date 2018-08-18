---------------------------------------------------------------------------------------------
--File:             decoder_display_with_select.vhd
--Developer:        Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
--Description:      Laboratory 1: 7 segment display decoder using with / select structure
---------------------------------------------------------------------------------------------

LIBRARY ieee;
    USE ieee.std_logic_1164.all;

ENTITY decoder IS
PORT
(
    abcd        : IN    std_logic_vector(3 downto 0);
    display     : OUT   std_logic_vector(6 downto 0)
);
END decoder;

ARCHITECTURE decoder_arch OF decoder IS
BEGIN

with abcd select

display <=  "1111110" when "0000", --0
            "0110000" when "0001", --1
            "1101101" when "0010", --2
            "1111001" when "0011", --3
            "0110011" when "0100", --4
            "1011011" when "0101", --5
            "1011111" when "0110", --6
            "1110000" when "0111", --7
            "1111111" when "1000", --8
            "1111011" when "1001", --9
            "1110111" when "1010", --A
            "0011111" when "1011", --b
            "0001101" when "1100", --c
            "0111101" when "1101", --d
            "1001111" when "1110", --E
            "1000111" when "1111", --F
            "0000000" when others; --Default behavior

END decoder_arch;