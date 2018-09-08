--------------------------------------------------
-- File:    pkg_rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso
--------------------------------------------------

LIBRARY ieee;
    USE ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;	

package pkg_rcv_fsm is
  
	-----------------------------------------
	--Auxiliary procedure to generate the alignment data to the serial input
	-----------------------------------------  
	procedure aux_generate_alignment
	(signal clk: in std_logic;
	 signal data: out std_logic);
	 
	-----------------------------------------
	--Auxiliary procedure to generate a dummy payload
	-----------------------------------------  
	procedure aux_generate_dummy_payload
	(signal clk: in std_logic;
	 signal data: out std_logic);	 
  
  
end pkg_rcv_fsm;


-----------------------------------------------
-----------------------------------------------
-----------------------------------------------


package body pkg_rcv_fsm is
	-----------------------------------------
	--Auxiliary procedure to generate the alignment data to the serial input
	-----------------------------------------  
	procedure aux_generate_alignment
	(signal clk: in std_logic;
	 signal data: out std_logic) is
	---------------------------------
	begin
		data <= '1'; wait until clk = '1';
		wait until clk = '0'; data <= '0'; wait until clk = '1';
		wait until clk = '0'; data <= '1'; wait until clk = '1';
		wait until clk = '0'; data <= '0'; wait until clk = '1';
		wait until clk = '0'; data <= '0'; wait until clk = '1';
		wait until clk = '0'; data <= '1'; wait until clk = '1';
		wait until clk = '0'; data <= '0'; wait until clk = '1';
		wait until clk = '0'; data <= '1'; wait until clk = '1'; wait until clk = '0';
	end aux_generate_alignment;
	
	
	-----------------------------------------
	--Auxiliary procedure to generate a dummy payload
	-----------------------------------------  
	procedure aux_generate_dummy_payload
	(signal clk: in std_logic;
	 signal data: out std_logic) is
	---------------------------------
	constant dummy_payload: std_logic_vector := x"123456789A";
	begin
		--Iterate dummy_payload from the Most Significant Bit (MSB) to the Least Significant Bit (LSB)
		for i in dummy_payload'low to dummy_payload'high loop
			data <= dummy_payload(i);					--Send bit
			wait until clk = '1'; wait until clk = '0';	--Wait one clock period
		end loop;
	end aux_generate_dummy_payload;
	
end pkg_rcv_fsm;

