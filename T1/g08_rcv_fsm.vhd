--------------------------------------------------
-- File:    reg_bank.vhd
-- Author:  Prof. M.Sc. Marlon Moraes
-- E-mail:  marlon.moraes@pucrs.br
--------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity rcv_fsm is
	generic (
		align_single : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"A5"
	);
	port (
		clk_in : in STD_LOGIC;
		rst_in : in STD_LOGIC;
		data_sr_in : in STD_LOGIC;

		data_pl_out : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_en_out : out STD_LOGIC;
		sync_out : out STD_LOGIC
	);
end rcv_fsm;

architecture Structure of rcv_fsm is
	type type_state is (
		s_reset,
		s_esperando_alinhamento_triplo,
		s_processando_dados,
		s_esperando_alinhamento_unico
	);
	signal CurrS : type_state;
	
	
	signal shifting_buffer : STD_LOGIC_VECTOR(((6*4*8)-1) downto 0);

	signal last_24_bytes : STD_LOGIC_VECTOR(((6*4*8)-1) downto 0);
	signal last_byte : STD_LOGIC_VECTOR(7 downto 0);
	signal last_latched_byte : STD_LOGIC_VECTOR(7 downto 0);

	signal state_counter: integer range 0 to 127;
	signal deve_exportar_byte: STD_LOGIC;
	signal comparing_check: STD_LOGIC;
begin
	sync_out <= '1' when (CurrS = s_processando_dados or CurrS = s_esperando_alinhamento_unico) else
				'0';

	state_machine : process(clk_in)
	begin
		if (rising_edge(clk_in)) then
			if (rst_in = '1') then
				state_counter <= 0;
				CurrS <= s_reset;
				comparing_check <= '0';
			elsif (CurrS = s_reset) then
				CurrS <= s_esperando_alinhamento_triplo;
			elsif (CurrS = s_esperando_alinhamento_triplo) then
				state_counter <= 0;
				if (
					last_24_bytes((8*0+7) downto (8*0)) = align_single and
					--last_24_bytes(15 downto 8) = align_single and -- ignore payload
					last_24_bytes((8*6+7) downto (8*6)) = align_single and
					--last_24_bytes(32 downto 24) = align_single and -- ignore payload
					last_24_bytes((8*12+7) downto (8*12)) = align_single
				) then
					CurrS <= s_processando_dados;
					comparing_check <= '0';
				else
					CurrS <= CurrS;
					comparing_check <= '1';
				end if;
			elsif ((CurrS = s_processando_dados) and (state_counter < 40)) then
				comparing_check <= '0';
				state_counter <= state_counter + 1;
				CurrS <= CurrS;
			elsif ((CurrS = s_processando_dados) and (state_counter = 40)) then
				state_counter <= 0;
				CurrS <= s_esperando_alinhamento_unico;
			elsif (CurrS = s_esperando_alinhamento_unico and (state_counter < 6)) then
				state_counter <= state_counter + 1;
				CurrS <= CurrS;
				comparing_check <= '0';
			elsif (CurrS = s_esperando_alinhamento_unico and (state_counter = 6)) then
				state_counter <= 0;
				comparing_check <= '1';
				if (last_byte = align_single) then
					CurrS <= s_processando_dados;
				else
					CurrS <= s_esperando_alinhamento_triplo;
				end if;
			else
				CurrS <= CurrS;
			end if;
	   end if;
	end process;

	deve_exportar_byte <=	'0' when (CurrS = s_reset or CurrS = s_esperando_alinhamento_triplo) else
							'1' when (state_counter = (8-1) or state_counter = (8*2-1) or state_counter = (8*3-1) or state_counter = (8*4-1) or state_counter = (8*5-1)) else
							'0';

	last_24_bytes <= shifting_buffer;
	last_byte <= shifting_buffer(7 downto 0);

	exportar_dados: process(clk_in)
	begin
		if (rising_edge(clk_in)) then
			if (deve_exportar_byte = '1') then
				data_en_out <= '1';
				last_latched_byte <= last_byte;
			else
				last_latched_byte <= (others => 'Z');
				data_en_out <= '0';
			end if;
		end if;
	end process;

	data_pl_out <= last_latched_byte;

	-- Preenche o buffer, independente da maquina de estados
	importar_dados: process(clk_in)
	begin
		if (rising_edge(clk_in)) then
			if (CurrS = s_reset) then
				shifting_buffer <= (others => 'Z');
			elsif (data_sr_in = 'X') then
				-- Facilita no entendimento da simulacao
				shifting_buffer <= shifting_buffer(((6*4*8)-2) downto 0) & 'Z';
			else
				shifting_buffer <= shifting_buffer(((6*4*8)-2) downto 0) & data_sr_in;
			end if;
		end if;
	end process;

end Structure;

