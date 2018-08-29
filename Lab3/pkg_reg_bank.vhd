LIBRARY ieee;
    USE ieee.std_logic_1164.all;

package pkg_reg_bank is
  type rom_array is array (0 to 15) of std_logic_vector(7 downto 0);
  constant rom : rom_array := ( x"32", x"30", x"31", x"37", x"30", x"39", x"06", x"07", x"08", x"09", x"0A", x"FF", x"FF", x"FF", x"FF", x"FF");
  
  -- procedure check_initial_values
   -- (signal clk : in std_logic;
    -- signal rd_en : out std_logic;
	-- signal rd_address : out std_logic_vector(3 downto 0);
	-- signal rd_data : in std_logic_vector(7 downto 0));
  procedure check_initial_values(signal clk: in std_logic);	
end pkg_reg_bank;

package body pkg_reg_bank is
	-- procedure check_initial_values
   -- (signal clk : in std_logic;
    -- signal rd_en : out std_logic;
	-- signal rd_address : out std_logic_vector(3 downto 0);
	-- signal rd_data : in std_logic_vector(7 downto 0)) is
	procedure check_initial_values(signal clk: in std_logic) is	
	--------------------------------------
	variable tmp : std_logic_vector (7 downto 0) := (others => '0');
	begin
		
	--for i in rom' range loop
		tmp := rom(0);
	--end loop;
	end check_initial_values;	

end pkg_reg_bank;

