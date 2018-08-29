LIBRARY ieee;
    USE ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;	

library work;
    use work.txt_util.all;

package pkg_reg_bank is
  type rom_array is array (0 to 15) of std_logic_vector(7 downto 0);
  constant rom : rom_array := ( x"32", x"30", x"31", x"37", x"30", x"39", x"06", x"07", x"08", x"09", x"0A", x"FF", x"FF", x"FF", x"FF", x"FF");
  
  procedure check_initial_values
   (signal clk : in std_logic;
    signal rd_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0));
--   procedure check_initial_values(signal clk: in std_logic);	
end pkg_reg_bank;

package body pkg_reg_bank is
	procedure check_initial_values
   (signal clk : in std_logic;
    signal rd_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0)) is
	--------------------------------------
	variable v_rd_address: std_logic_vector (3 downto 0) := (others => '0');
	begin

	--OPTIONAL: reset reg_bang before execute procedure 
	wait for 100 ns;	--wait reg_bank start

	for i in rom'range loop
		--wait to send request
		 wait until clk = '0';

		--send memory read request
		rd_en <= '1';
		v_rd_address := conv_std_logic_vector(i, rd_address'length);
		rd_address <= v_rd_address;

		wait until clk = '1'; --CUV shall receive request
		wait until clk = '0'; wait until clk = '1';	--wait for one cycle to fetch data

		--Check if initial value match expected data
		assert (rd_data = rom(i)) report "Code 1: Invalid CUV register initial value for address (0x" & hstr(v_rd_address) & "). Expected: 0x" & hstr(rom(i)) & " Got: 0x" & hstr(rd_data) severity error;
	end loop;
	end check_initial_values;	

end pkg_reg_bank;

