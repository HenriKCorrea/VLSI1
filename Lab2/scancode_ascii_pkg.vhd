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
	
	constant C_ASCII_A: std_logic_vector := x"41"; constant C_SCANCODE_A: std_logic_vector := x"1C";
	constant C_ASCII_B: std_logic_vector := x"42"; constant C_SCANCODE_B: std_logic_vector := x"32";
	constant C_ASCII_C: std_logic_vector := x"43"; constant C_SCANCODE_C: std_logic_vector := x"21";
	constant C_ASCII_D: std_logic_vector := x"44"; constant C_SCANCODE_D: std_logic_vector := x"23";
	constant C_ASCII_E: std_logic_vector := x"45"; constant C_SCANCODE_E: std_logic_vector := x"24";
	constant C_ASCII_F: std_logic_vector := x"46"; constant C_SCANCODE_F: std_logic_vector := x"2B";
	constant C_ASCII_G: std_logic_vector := x"47"; constant C_SCANCODE_G: std_logic_vector := x"34";
	constant C_ASCII_H: std_logic_vector := x"48"; constant C_SCANCODE_H: std_logic_vector := x"33";
	constant C_ASCII_I: std_logic_vector := x"49"; constant C_SCANCODE_I: std_logic_vector := x"43";
	constant C_ASCII_J: std_logic_vector := x"4A"; constant C_SCANCODE_J: std_logic_vector := x"3B";
	constant C_ASCII_K: std_logic_vector := x"4B"; constant C_SCANCODE_K: std_logic_vector := x"42";
	constant C_ASCII_L: std_logic_vector := x"4C"; constant C_SCANCODE_L: std_logic_vector := x"4B";
	constant C_ASCII_M: std_logic_vector := x"4D"; constant C_SCANCODE_M: std_logic_vector := x"3A";
	constant C_ASCII_N: std_logic_vector := x"4E"; constant C_SCANCODE_N: std_logic_vector := x"31";
	constant C_ASCII_O: std_logic_vector := x"4F"; constant C_SCANCODE_O: std_logic_vector := x"44";
	constant C_ASCII_P: std_logic_vector := x"50"; constant C_SCANCODE_P: std_logic_vector := x"4D";
	constant C_ASCII_Q: std_logic_vector := x"51"; constant C_SCANCODE_Q: std_logic_vector := x"15";
	constant C_ASCII_R: std_logic_vector := x"52"; constant C_SCANCODE_R: std_logic_vector := x"2D";
	constant C_ASCII_S: std_logic_vector := x"53"; constant C_SCANCODE_S: std_logic_vector := x"1B";
	constant C_ASCII_T: std_logic_vector := x"54"; constant C_SCANCODE_T: std_logic_vector := x"2C";
	constant C_ASCII_U: std_logic_vector := x"55"; constant C_SCANCODE_U: std_logic_vector := x"3C";
	constant C_ASCII_V: std_logic_vector := x"56"; constant C_SCANCODE_V: std_logic_vector := x"2A";
	constant C_ASCII_W: std_logic_vector := x"57"; constant C_SCANCODE_W: std_logic_vector := x"1D";
	constant C_ASCII_X: std_logic_vector := x"58"; constant C_SCANCODE_X: std_logic_vector := x"22";
	constant C_ASCII_Y: std_logic_vector := x"59"; constant C_SCANCODE_Y: std_logic_vector := x"35";
	constant C_ASCII_Z: std_logic_vector := x"5A"; constant C_SCANCODE_Z: std_logic_vector := x"1A";
	

    constant C_ASCII_OTHERS: std_logic_vector := x"FF";

end package scancode_ascii_pkg;