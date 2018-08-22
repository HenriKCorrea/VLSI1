---------------------------------------------------------------------------------------------
--File:             decoder_scancode_ascii.vhd
--Developer:        Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
--Description:      Laboratory 2: simple keyboard scancode
---------------------------------------------------------------------------------------------

LIBRARY ieee;
    USE ieee.std_logic_1164.all;

LIBRARY work;
    USE work.scancode_ascii_pkg.all;

ENTITY decoder_scancode_ascii IS
PORT
(
    scancode_in   : IN    std_logic_vector(7 downto 0);
    ascii_out     : OUT   std_logic_vector(7 downto 0)
);
END decoder_scancode_ascii;

ARCHITECTURE decoder_scancode_ascii_arch OF decoder_scancode_ascii IS
BEGIN

with scancode_in select

ascii_out <= C_ASCII_1 when C_SCANCODE_1,
			 C_ASCII_2 when C_SCANCODE_2,
			 C_ASCII_3 when C_SCANCODE_3,
			 C_ASCII_4 when C_SCANCODE_4,
			 C_ASCII_5 when C_SCANCODE_5,
			 C_ASCII_6 when C_SCANCODE_6,
			 C_ASCII_7 when C_SCANCODE_7,
			 C_ASCII_8 when C_SCANCODE_8,
			 C_ASCII_9 when C_SCANCODE_9,
			 C_ASCII_0 when C_SCANCODE_0,
			 C_ASCII_OTHERS when others;

END decoder_scancode_ascii_arch;