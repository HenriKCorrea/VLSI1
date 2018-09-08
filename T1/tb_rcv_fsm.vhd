--------------------------------------------------
-- File:    tb_rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

library work;
	use work.pkg_rcv_fsm.all;

entity tb_rcv_fsm is
end tb_rcv_fsm;


architecture tb_rcv_fsm of tb_rcv_fsm is
	constant 	CLK_EDGE    : std_logic := '1';
	constant	PERIOD	: time := 10 ns;	-- period time.
	constant	HALF_PERIOD	: time := 5 ns;	-- period time.

	-- auxiliary signals
	signal s_clk: std_logic := '1';				--Clock reference used in testbench
	signal s_finishTest: std_logic := '0';		--Flag to indicate if test finish
	
	--signals used to map  (CUV)
	signal s_clk_in, s_data_sr_in, s_data_en_out, s_sync_out : STD_LOGIC := '0'; 
	signal s_rst_in: std_logic := '1';
    signal s_data_pl_out :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0'); 

begin

	--Clock generation
	--Works untill test is not finished
	s_clk <= not s_clk after HALF_PERIOD when s_finishTest /= '1' else '0';
	s_clk_in <= s_clk;
	

	--Control reset to sync the serial data to be sent with the clock period
	reset:process
	begin
		wait until s_clk ='1'; wait until s_clk ='0';
		s_rst_in <= '0';
		wait;
	end process reset;
	
	--Call procedures to validate CUV
	test: process
	begin
		wait until s_rst_in = '0';
		loop
			aux_generate_alignment(s_clk, s_data_sr_in);
			aux_generate_dummy_payload(s_clk, s_data_sr_in);
		end loop;
	end process test;


	--Instantiate CUV
	cuv: entity work.rcv_fsm
	port map
	(
		clk_in => s_clk_in,
		rst_in => s_rst_in,
		data_sr_in => s_data_sr_in,
		data_pl_out => s_data_pl_out,
		data_en_out => s_data_en_out,
		sync_out => s_sync_out
    );


end tb_rcv_fsm;