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
			 C_ASCII_A when C_SCANCODE_A,			 
			 C_ASCII_B when C_SCANCODE_B,			 
			 C_ASCII_C when C_SCANCODE_C,
			 C_ASCII_D when C_SCANCODE_D,
			 C_ASCII_E when C_SCANCODE_E,
			 C_ASCII_F when C_SCANCODE_F,
			 C_ASCII_G when C_SCANCODE_G,
			 C_ASCII_H when C_SCANCODE_H,
			 C_ASCII_I when C_SCANCODE_I,
			 C_ASCII_J when C_SCANCODE_J,
			 C_ASCII_K when C_SCANCODE_K,
			 C_ASCII_L when C_SCANCODE_L,
			 C_ASCII_M when C_SCANCODE_M,
			 C_ASCII_N when C_SCANCODE_N,
			 C_ASCII_O when C_SCANCODE_O,
			 C_ASCII_P when C_SCANCODE_P,
			 C_ASCII_Q when C_SCANCODE_Q,
			 C_ASCII_R when C_SCANCODE_R,
			 C_ASCII_S when C_SCANCODE_S,
			 C_ASCII_T when C_SCANCODE_T,
			 C_ASCII_U when C_SCANCODE_U,
			 C_ASCII_V when C_SCANCODE_V,
			 C_ASCII_W when C_SCANCODE_W,
			 C_ASCII_X when C_SCANCODE_X,
			 C_ASCII_Y when C_SCANCODE_Y,
			 C_ASCII_Z when C_SCANCODE_Z,
			 C_ASCII_OTHERS when others;

END decoder_scancode_ascii_arch;