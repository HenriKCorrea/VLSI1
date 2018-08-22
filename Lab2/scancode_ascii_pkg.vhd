---------------------------------------------------------------------------------------------
--File:             scancode_ascii_pkg.vhd
--Developer:        Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
--Description:      Laboratory 2: decoder_scancode_ascii constants definitions
---------------------------------------------------------------------------------------------

LIBRARY ieee;
    USE ieee.std_logic_1164.all;

package scancode_ascii_pkg is

    constant C_SCANCODE_1: std_logic_vector := x"16";
    constant C_SCANCODE_2: std_logic_vector := x"1E";
    constant C_SCANCODE_3: std_logic_vector := x"26";
    constant C_SCANCODE_4: std_logic_vector := x"25";
    constant C_SCANCODE_5: std_logic_vector := x"2E";
    constant C_SCANCODE_6: std_logic_vector := x"36";
    constant C_SCANCODE_7: std_logic_vector := x"3D";
    constant C_SCANCODE_8: std_logic_vector := x"3E";
    constant C_SCANCODE_9: std_logic_vector := x"46";
    constant C_SCANCODE_0: std_logic_vector := x"45";
	
    constant C_ASCII_1: std_logic_vector := x"31";
    constant C_ASCII_2: std_logic_vector := x"32";
    constant C_ASCII_3: std_logic_vector := x"33";
    constant C_ASCII_4: std_logic_vector := x"34";
    constant C_ASCII_5: std_logic_vector := x"35";
    constant C_ASCII_6: std_logic_vector := x"36";
    constant C_ASCII_7: std_logic_vector := x"37";
    constant C_ASCII_8: std_logic_vector := x"38";
    constant C_ASCII_9: std_logic_vector := x"39";
    constant C_ASCII_0: std_logic_vector := x"30";	

    constant C_ASCII_OTHERS: std_logic_vector := x"FF";

end package scancode_ascii_pkg;