--------------------------------------------------
-- File:    tb_rcv_fsm.vhd
-- Author:  Henrique Krausburg Corr�a <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso
--------------------------------------------------

--TODO: Testes que faltam ser implementados:
--data_pl_out (passivo):	S� pode ocorrer uma mudan�a no barramento se a flag de data_en_out estiver ativa ou se o reset foi acionado;
--data_pl_out (ativo): 	Escrever uma rajada de dados serial (5x payload) e verificar se est� na sa�da;
--						NOTA: O requisito n�o deixa claro quanto tempo leva para o dado estar dispon�vel na sa�da paralela. Considerar uma toler�ncia de 7 ciclos de clock.
--						DICA: mandar pelo menos 2 bytes de payload replicados
--data_en_out (passivo): 	analisar transi��es v�lidas do sinal conforme requisito
--							NOTA: n�o esquecer de testar se o sinal N�O ficou mais de um ciclo em n�vel alto (talvez fazer uma fila de hist�rico de 2 bits).
--reset (ativo):	verificar se REALMENTE funciona apenas em borda de subida (tentar ressetar em borda de descida);
--					reiniciar ap�s sincronizado (flag de alinhamento � desativada);
--					reiniciar antes da sincroniza��o (verificar se alinhamento � ativo depois de 3x palavras)
--sync_out(ativo):	Para borda de descida 1 -> 0, verificar se a transmiss�o de dados serial foi interrompida (exemplo: s_data_sr_in <= 'Z')
--					Para borda de descida 1 -> 0, verificar se realmente ocorreu falha no alinhamento
--
--POR FIM: Test coverage passando 100%

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

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
	
	--signals used to map  (CUV)
	signal s_clk_in, s_data_sr_in, s_data_en_out, s_sync_out : STD_LOGIC := '0'; 
	signal s_rst_in: std_logic := '1';
    signal s_data_pl_out :  STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0');
	signal s_serial_queue: STD_LOGIC_VECTOR (103 downto 0) := (others => '0');
	signal s_previous_sync_out: std_logic := '0';

begin

	--Clock generation
	--Works untill test is not finished
	s_clk <= not s_clk after HALF_PERIOD when s_finishTest /= '1' else '0';
	s_clk_in <= s_clk;
	
	--Queue insertion
	s_serial_queue <= s_serial_queue (102 downto 0) & s_data_sr_in when (s_clk'event and s_clk = '1');
	s_previous_sync_out <= s_sync_out when (s_clk'event and s_clk = '1');
	

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
	
	sync_validation: process(s_sync_out)
	constant alignment: std_logic_vector (7 downto 0) := "10100101";
	variable sync_validation: boolean := false;
	begin
		if (s_sync_out = '1' and s_previous_sync_out = '0') then
			--Validate 0 -> 1 transition
			assert (s_serial_queue(7 downto 0) = alignment and
				s_serial_queue(55 downto 48) = alignment and
				s_serial_queue(103 downto 96) = alignment)
			report "Test alignment validation: Invalid sync transition 0 => 1: " --& hstr(s_serial_queue)-- & " " & hstr(s_serial_queue(20 downto 13)) & " " & hstr(s_serial_queue(33 downto 26))
			severity error;
		elsif(s_sync_out = '0' and s_previous_sync_out = '1') then
			--Validate 1 -> 0 transition
			
			--Check if reset button has been pressed
			sync_validation := sync_validation or (s_rst_in = '1');

			--Check if 1 -> 0 reason was an invalid std_logic value
			sync_validation := sync_validation or (s_data_sr_in /= '1' and s_data_sr_in /= '0');

			--Check if 1 -> 0 reason was caused by wrong alignment word
			sync_validation := sync_validation or aux_is_alignment_broken(s_serial_queue(55 downto 0));

			--Validate 1 -> 0 transition
			assert (sync_validation = true) report "Test alignment validation: Invalid sync transition 1 => 0" severity error;

			--Check if 1 -> 0 reason was an invalid std_logic value
			--assert (s_data_sr_in /= '1' and s_data_sr_in /= '0') report "Test alignment validation: Invalid sync transition 1 => 0: Data in signal WAS NOT suspendend" severity error;
			
			--Check if 1 -> 0 reason was caused by wrong alignment word
			--assert (aux_is_alignment_broken(s_serial_queue(55 downto 0)) = true) report "Test alignment validation: Invalid sync transition 1 => 0: No error was detected in the present serial data in alignment bit (is this an alignment word?)" severity error;
		end if;
	end process sync_validation;

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
