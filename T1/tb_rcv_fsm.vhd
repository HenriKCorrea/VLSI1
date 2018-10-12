--------------------------------------------------
-- File:    tb_rcv_fsm.vhd
-- Author:  Henrique Krausburg Corr�a <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

--TODO: Testes que faltam ser implementados:
--data_pl_out (ativo): 	Escrever uma rajada de dados serial (5x payload) e verificar se est� na sa�da;
--						NOTA: O requisito n�o deixa claro quanto tempo leva para o dado estar dispon�vel na sa�da paralela. Considerar uma toler�ncia de 7 ciclos de clock.
--						DICA: mandar pelo menos 2 bytes de payload replicados
--POR FIM: Test coverage passando 100%

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;

library work;
	use work.pkg_rcv_fsm.all;
	use work.txt_util.all;

entity tb_rcv_fsm is
end tb_rcv_fsm;


architecture tb_rcv_fsm of tb_rcv_fsm is
	constant 	CLK_EDGE    : std_logic := '1';
	constant	PERIOD	: time := 10 ns;	-- period time.
	constant	HALF_PERIOD	: time := 5 ns;	-- period time.

	-- auxiliary signals
	signal s_clk: std_logic := '1';				--Clock reference used in testbench
	signal s_finishTest: std_logic := '0';		--Flag to indicate if test finish
	signal change: std_logic := '0';
	
	--signals used to map  (CUV)
	signal s_clk_in, s_data_sr_in, s_data_en_out, s_sync_out : STD_LOGIC := '0'; 
	signal s_rst_in: std_logic := '1';
    signal s_data_pl_out :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0');
	signal s_serial_queue: STD_LOGIC_VECTOR (103 downto 0) := (others => '0');
	signal s_previous_sync_out: std_logic := '0';
	signal s_previous_data_pl_out :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0');

begin

	--Clock generation
	--Works untill test is not finished
	s_clk <= not s_clk after HALF_PERIOD when s_finishTest /= '1' else '0';
	s_clk_in <= s_clk;
	
	--Queue insertion
	s_serial_queue <= s_serial_queue (102 downto 0) & s_data_sr_in when (s_clk'event and s_clk = '1');
	s_previous_sync_out <= s_sync_out when (s_clk'event and s_clk = '1');
	s_previous_data_pl_out <= s_data_pl_out when (s_clk'event and s_clk = '1');
	

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
		aux_sync_device(s_clk, s_data_sr_in);
		loop
			aux_generate_dummy_payload(s_clk, s_data_sr_in);
			aux_generate_alignment(s_clk, s_data_sr_in);
		end loop;
		s_finishTest <= '1';
	end process test;
	
	sync_validation: process(s_sync_out)
	constant alignment: std_logic_vector (7 downto 0) := "10100101";
	variable sync_validation: boolean := false;
	begin
		if (s_sync_out = '1' and s_previous_sync_out = '0') then
			--Validate 0 -> 1 transition
			-- Check if the last 3 alignment were correct
			assert (s_serial_queue(7 downto 0) = alignment and
				s_serial_queue(55 downto 48) = alignment and
				s_serial_queue(103 downto 96) = alignment)
			report "Test alignment validation: Invalid sync transition 0 => 1" severity error;
		elsif(s_sync_out = '0' and s_previous_sync_out = '1') then
			--Validate 1 -> 0 transition
			
			--Check if reset button has been pressed
			if (s_rst_in = '1') then
				sync_validation := true;
			--Check if 1 -> 0 reason was an invalid std_logic value
			elsif (s_data_sr_in /= '1' and s_data_sr_in /= '0') then
				sync_validation := true;
			--Check if 1 -> 0 reason was caused by wrong alignment word
			elsif (aux_is_alignment_broken(s_serial_queue(55 downto 0))) then
				sync_validation := true;
			end if;
			--Validate 1 -> 0 transition
			assert (sync_validation = true) report "Test alignment validation: Invalid sync transition 1 => 0" severity error;
		end if;
	end process sync_validation;

	data_pl_out_validation: process (s_data_pl_out)
	begin
		-- se if data_pl_out changed
		change <= or_reduce(s_data_pl_out xor s_previous_data_pl_out);

		if (change = '1') then 
			-- If YES then check:
			
			-- test if data_en_out permit data_pl_out change
			assert (s_data_en_out = '1') report "Test data_pl_out validation: Invalid change of data: data_en_out is DOWN" severity error;
			-- test if rst is high to validate data_pl_out change
			assert (s_rst_in /= '1') report "Test data_pl_out validation: Invalid change of data: s_rst_in is HIGH" severity error;
		end if;
	end process data_pl_out_validation;

	data_en_out_master_clock: process(s_data_en_out, s_clk)
	variable cont: integer := 0;
	begin
		-- Validate data_en_out in master clock
		-- Use falling edge
		if (s_clk'event and s_clk = '0') then
			-- check if data_en_out is up
			if (s_data_en_out = '1') then
				-- if YES then count +1
				cont := cont + 1;
			elsif (s_data_en_out = '0') then
				-- if NO then count = 0
				cont := 0;
			end if;
		end if;
		-- if count is bigger than 2, in others words, stayed up after two falling edges then assert
		assert(cont < 2) report "Test data_en_out validation: Invalid enable: master clock already passed" severity error;
	end process data_en_out_master_clock;

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
