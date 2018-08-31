--------------------------------------------------
-- File:    tb_reg_bank.vhd
-- Author:  Henrique Krausburg Corrêa
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

library work;
    use work.txt_util.all;
	use work.pkg_reg_bank.all;

entity tb_reg_bank is
end tb_reg_bank;


architecture tb_reg_bank of tb_reg_bank is
	constant 	CLK_EDGE    : std_logic := '1';
	constant	PERIOD	: time := 20 ns;	-- period time.
	constant	HALF_PERIOD	: time := 10 ns;	-- period time.

	-- auxiliary signals
	signal s_clk: std_logic := '1';				--Clock reference used in testbench
	signal s_finishTest: std_logic := '0';		--Flag to indicate if test finish
	
	--signals used to map register bank entity (CUV)
	signal s_clk_in, s_rd_en_in, s_rst_in, s_wr_en_in : STD_LOGIC := '0'; 
    signal s_rd_data_out, s_wr_data_in :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0'); 
    signal s_rd_address_in, s_wr_address_in : STD_LOGIC_VECTOR ( 3 downto 0 ):= (others => '0'); 

begin

	--Clock generation
	--Works untill test is not finished
	s_clk <= not s_clk after HALF_PERIOD when s_finishTest /= '1' else '0';
	s_clk_in <= s_clk;
	
	--Call procedures to validate CUV
	test: process
	begin
	  test_initial_values(s_clk_in, s_rd_en_in, s_rd_address_in, s_rd_data_out);	
	  test_write(s_clk_in, s_rst_in, s_rd_en_in, s_wr_en_in, s_rd_address_in, s_wr_address_in, s_rd_data_out, s_wr_data_in);
	  test_reset_memory(s_clk_in, s_rst_in, s_rd_en_in, s_rd_address_in, s_rd_data_out);	
	  wait until s_clk = '0';
	  s_finishTest <= '1';	--Test finished
	  wait;
	end process;


	--Instantiate CUV
	cuv_reg_bank: entity work.reg_bank
	port map
	(
		clk => s_clk_in,
		rd_en => s_rd_en_in, 
		rst => s_rst_in,
		wr_en => s_wr_en_in,
		rd_data => s_rd_data_out,
		rd_address => s_rd_address_in,
		wr_data => s_wr_data_in,
		wr_address => s_wr_address_in
    );


end tb_reg_bank;