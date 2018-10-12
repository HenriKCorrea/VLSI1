--------------------------------------------------
-- File:    pkg_rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

--Help page about VHDL predefined attributes: https://www.csee.umbc.edu/portal/help/VHDL/attribute.html

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

	-----------------------------------------
	--Check if the last alignment has been broken by the correct means as defined in requirements
	--Assumption: device is synchronized (must find at least one valid alignment word)
	-----------------------------------------  
	function aux_is_alignment_broken (v : std_logic_vector)
		return boolean;	 

	-----------------------------------------
	--Auxiliary procedure to generate a dummy payload
	--max payload size is 39 (considering zero)
	-----------------------------------------  
	procedure aux_generate_dummy_payload_v2
	(signal clk: in std_logic;
	 signal data: out std_logic;
	 constant size: integer range 0 to 39);			

	-----------------------------------------
	--Auxiliary procedure to generate the alignment data to the serial input
	--max alignment size is 7 (considering zero)
	-----------------------------------------  
	procedure aux_generate_alignment_v2
	(signal clk: in std_logic;
	 signal data: out std_logic;
	 constant size: integer range 0 to 7);	

	-----------------------------------------
	--Auxiliary procedure to siychronize device
	-----------------------------------------  
	procedure aux_sync_device
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
	
	-----------------------------------------
	--Check if the last alignment has been broken by the correct means as defined in requirements
	--Assumption: device is synchronized (must find at least one valid alignment word)
	-----------------------------------------  
	function aux_is_alignment_broken (v : std_logic_vector)
		return boolean is
	-----------------------
	constant alignment: std_logic_vector (7 downto 0) := "10100101";
	variable result: boolean := false;
	variable v_pos: integer := v'LENGTH - 1;
	variable final_alignment_offset: integer range -10 to 10 := 0;
	begin
		--input vector size shall be at least 56 bits
		if(v'LENGTH > 55) then
			--Search for a valid alignment word untill reach payload position (47)
			while(v_pos > 47) loop
				if(v(v_pos downto (v_pos - 7)) = alignment) then
					exit;
				else
					v_pos := v_pos - 1;
				end if;
			end loop;
			
			--check if found valid payload before reach 
			if(v_pos > 47) then
				--Skip payload to the next alignment word
				v_pos := v_pos - 48;

				final_alignment_offset := 7 - v_pos;
				
				--Alignment word shall be correct untill position 0 (this shall be the wrong value)
				while(v_pos > 0) loop
					if(v(v_pos) = alignment(final_alignment_offset + v_pos))then
						v_pos := v_pos - 1;
					else
						--Fail: 1 -> 0 transition happen too late
						exit;
					end if;
				end loop;

				--At last, check if the present sent bit is wrong 'as expected'
				if(v_pos = 0 and v(0) /= alignment(final_alignment_offset)) then
					result := true;
				end if;

			end if;
		end if;
		return result;
	end aux_is_alignment_broken;

	-----------------------------------------
	--Auxiliary procedure to generate a dummy payload
	--max payload size is 39 (considering zero)
	-----------------------------------------  
	procedure aux_generate_dummy_payload_v2
	(signal clk: in std_logic;
	 signal data: out std_logic;
	 constant size: integer range 0 to 39) is
	---------------------------------
	constant dummy_payload: std_logic_vector := x"123456789A";
	begin
		--Iterate dummy_payload from the Most Significant Bit (MSB) to the Least Significant Bit (LSB)
		for i in 0 to size loop
			data <= dummy_payload(i);					--Send bit
			wait until clk = '1'; wait until clk = '0';	--Wait one clock period
		end loop;
	end aux_generate_dummy_payload_v2;	

	-----------------------------------------
	--Auxiliary procedure to generate the alignment data to the serial input
	--max alignment size is 7 (considering zero)
	-----------------------------------------  
	procedure aux_generate_alignment_v2
	(signal clk: in std_logic;
	 signal data: out std_logic;
	 constant size: integer range 0 to 7) is
	 -------------------------------------------
	 constant alignment: std_logic_vector (7 downto 0) := "10100101";
	 begin
		--Iterate alignment from the Most Significant Bit (MSB) to the Least Significant Bit (LSB)
		for i in 0 to size loop
			data <= alignment(i);						--Send bit
			wait until clk = '1'; wait until clk = '0';	--Wait one clock period
		end loop;
	 end aux_generate_alignment_v2;

	-----------------------------------------
	--Auxiliary procedure to siychronize device
	-----------------------------------------  
	procedure aux_sync_device
	(signal clk: in std_logic;
	 signal data: out std_logic) is
	 ----------------------------------------
	 begin
	 	aux_generate_alignment_v2(clk, data, 7);
		aux_generate_dummy_payload_v2(clk, data, 39);
	 	aux_generate_alignment_v2(clk, data, 7);
		aux_generate_dummy_payload_v2(clk, data, 39);		
		aux_generate_alignment_v2(clk, data, 7);
	 end aux_sync_device; 
	
end pkg_rcv_fsm;

