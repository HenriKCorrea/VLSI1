LIBRARY ieee;
    USE ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;	

library work;
    use work.txt_util.all;

package pkg_reg_bank is
  type rom_array is array (0 to 15) of std_logic_vector(7 downto 0);
  constant rom : rom_array := ( x"32", x"30", x"31", x"37", x"30", x"39", x"06", x"07", x"08", x"09", x"0A", x"FF", x"FF", x"FF", x"FF", x"FF");
  constant c_rom_write_test : rom_array := ( x"32", x"30", x"31", x"37", x"30", x"39", x"76", x"77", x"78", x"79", x"7A", x"7B", x"7C", x"7D", x"7E", x"7F");
  
  -----------------------------------------
  --Auxiliary procedure to reset register bank
  -----------------------------------------  
  procedure aux_reset_reg_bank
  (signal clk: in std_logic; signal rst: out std_logic);
  
  -----------------------------------------
  --Procedure to validate if initial values of the register bank are expected.
  -----------------------------------------
  procedure test_initial_values
   (signal clk : in std_logic;
    signal rd_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0));
	
  -----------------------------------------
  --Test: Attempt to write on all registers
  --Check if read-only registers didn't changed
  --Check if writable register contains expected value
  -----------------------------------------
  procedure test_write
   (signal clk : in std_logic;
	signal rst: out std_logic;
    signal rd_en : out std_logic;
	signal wr_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal wr_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0);	
	signal wr_data : out std_logic_vector(7 downto 0));	
	
  -----------------------------------------
  --Test: Check if register bank returns to default values after reset
  --Initial conditions: random data already written on registers
  -----------------------------------------
  procedure test_reset_memory
   (signal clk : in std_logic;
	signal rst: out std_logic;
    signal rd_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0));	
end pkg_reg_bank;


-----------------------------------------------
-----------------------------------------------
-----------------------------------------------


package body pkg_reg_bank is
  -----------------------------------------
  --Auxiliary procedure to reset register bank
  -----------------------------------------  
	procedure aux_reset_reg_bank
	(signal clk: in std_logic;
	 signal rst: out std_logic) is
	---------------------------------
	begin
		wait until clk = '1'; wait until clk = '0';
		rst <= '1';
		wait until clk = '1'; wait until clk = '0';
		rst <= '0';
		wait for 90 ns;
	end aux_reset_reg_bank;

	-----------------------------------------
	--Procedure to validate if initial values of the register bank are expected.
	-----------------------------------------	
	procedure test_initial_values
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
		assert (rd_data = rom(i)) report "Test initial values: Invalid CUV register initial value for address (0x" & hstr(v_rd_address) & "). Expected: 0x" & hstr(rom(i)) & " Got: 0x" & hstr(rd_data) severity error;
	end loop;
	end test_initial_values;	
	
	-----------------------------------------
	--Test: Attempt to write on all registers
	--Check if read-only registers didn't changed
	--Check if writable register contains expected value
	-----------------------------------------
	procedure test_write
	(signal clk : in std_logic;
	 signal rst: out std_logic;
	 signal rd_en : out std_logic;
	 signal wr_en : out std_logic;
	 signal rd_address : out std_logic_vector(3 downto 0);
	 signal wr_address : out std_logic_vector(3 downto 0);
	 signal rd_data : in std_logic_vector(7 downto 0);	
	 signal wr_data : out std_logic_vector(7 downto 0)) is
	-------------------------------------------
	variable v_rd_address: std_logic_vector (3 downto 0) := (others => '0');
	variable v_wr_address: std_logic_vector (3 downto 0) := (others => '0');
	begin

		--setup test initial values
		wait until clk = '1';
		rd_en <= '0';
		wr_en <= '0';
		rd_address <= (others => '0');
		wr_address <= (others => '0');
		wr_data <= (others => '0');

		--Write on all registers
		for i in c_rom_write_test'range loop
			--wait to send request
			 wait until clk = '0';

			--set data to be written
			wr_en <= '1';
			wr_address <= conv_std_logic_vector(i, wr_address'length);
			wr_data <= conv_std_logic_vector(i + 112, wr_data'length);	--write data following the pattern 0x7[i]

			wait until clk = '1'; --CUV shall receive request
		end loop;		
		
		--clear write enabble flag
		wr_en <= '0';

		--Read registers and validate if values are the expected ones
		for i in c_rom_write_test'range loop
			--wait to send request
			 wait until clk = '0';

			--send memory read request
			rd_en <= '1';
			v_rd_address := conv_std_logic_vector(i, rd_address'length);
			rd_address <= v_rd_address;

			wait until clk = '1'; --CUV shall receive request
			wait until clk = '0'; wait until clk = '1';	--wait for one cycle to fetch data

			--Check if initial value match expected data
			assert (rd_data = c_rom_write_test(i)) report "Test Write: Invalid CUV register value for address (0x" & hstr(v_rd_address) & "). Expected: 0x" & hstr(c_rom_write_test(i)) & " Got: 0x" & hstr(rd_data) severity error;
		end loop;
	end test_write;
	
-----------------------------------------------------------

  -----------------------------------------
  --Test: Check if register bank returns to default values after reset
  --Initial conditions: random data already written on registers
  -----------------------------------------
  procedure test_reset_memory
   (signal clk : in std_logic;
	signal rst: out std_logic;
    signal rd_en : out std_logic;
	signal rd_address : out std_logic_vector(3 downto 0);
	signal rd_data : in std_logic_vector(7 downto 0)) is
	--------------------------------------
	variable v_rd_address: std_logic_vector (3 downto 0) := (others => '0');
	begin

	--Reset memory to restore initial values
	aux_reset_reg_bank(clk, rst);
	wait until clk = '1';

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
		assert (rd_data = rom(i)) report "Test reset memory: Invalid CUV register value for address (0x" & hstr(v_rd_address) & "). Expected: 0x" & hstr(rom(i)) & " Got: 0x" & hstr(rd_data) severity error;
	end loop;
	end test_reset_memory;
	
end pkg_reg_bank;

