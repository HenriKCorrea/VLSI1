--------------------------------------------------
-- File:    rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso
--------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

entity rcv_fsm is
	port(
	clk_in 		: in std_logic; 
	rst_in 		: in std_logic; 
	data_sr_in 	: in std_logic; 
	data_pl_out	: out std_logic_vector(7 downto 0);
	data_en_out	: out std_logic;
	sync_out	: out std_logic);
end rcv_fsm;


architecture arch_rcv_fsm of rcv_fsm is
	constant 	CLK_EDGE    : std_logic := '1';
	constant 	INV_CLK_EDGE    : std_logic := '0';

	--Reference of a valid alignment word
	constant C_ALIGNMENT_REF : std_logic_vector(7 downto 0) := x"A5";
	
	--serial data in state machine.
	type fsm_state_type is (VALIDATE_ALIGNMENT, WAIT_PAYLOAD, READ_ALIGNMENT, READ_PAYLOAD, RESET);
	signal state		: fsm_state_type := VALIDATE_ALIGNMENT;
	signal next_state	: fsm_state_type := VALIDATE_ALIGNMENT;
	
	signal buffer_in, buffer_eval, buffer_out : std_logic_vector(7 downto 0) := (others => '0');
	
	--Flag used to indicate when received 8 serial bits.
	signal s_data_sr_received : std_logic := '0';
	
	--Signal of new data available at paralel output
	signal s_data_en_out : std_logic := '0';

	
begin


	read_serial_in: process(clk_in)
	variable v_count : integer range 0 to 7 := 0;
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				buffer_in <= (others => '0');
				v_count := 0;
				s_data_sr_received <= '0';
			else
				--Shift data and insert new received data
				buffer_in <=  buffer_in(6 downto 0) & data_sr_in;
				
				if v_count = 7 then
					--move received data to internal buffer
					v_count := 0;
					s_data_sr_received <= '1';
				else
					--Increment counter and go back get the next serial bit
					v_count := v_count + 1;
					s_data_sr_received <= '0';
				end if;
			end if;
		end if;
	end process read_serial_in;	

	buffer_eval <= buffer_in when s_data_sr_received'event and s_data_sr_received = '1';
	
	fsm_transition: process(clk_in)
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				state <= RESET;
			else
				state <= next_state;
			end if;
		end if;
	end process fsm_transition;

	fsm_next_state_decoder: process(state, s_data_sr_received)
	--Count the number of received payload bytes after an alignment validation
	variable payload_counter : integer range 0 to 4 := 0;	
	--Count the number of received valid alignments before enable output
	variable alignemt_counter : integer range 0 to 2 := 0;
	begin
		case state is
			---------------------------------------------------------
			when VALIDATE_ALIGNMENT =>
				--only proceed if input serial flag is ON (input buffer is full)
				if(s_data_sr_received = '1') then
					--Check if alignment is valid
					if(buffer_in = C_ALIGNMENT_REF) then
						--If received three valid alignments, enable output
						if(alignemt_counter = 2) then
							alignemt_counter := 0;
							next_state <= READ_PAYLOAD;
						else
							--Increment counter and wait for the next alignment word
							alignemt_counter := alignemt_counter + 1;
							next_state <= WAIT_PAYLOAD;
						end if;
					else
						--Invalid alignment: reset state and counter
						alignemt_counter := 0;
						next_state <= VALIDATE_ALIGNMENT;
					end if;
				else
					--did not completed input buffer. Wait to fill it
					next_state <= VALIDATE_ALIGNMENT;
				end if;
			----------------------------------------------------------
			when WAIT_PAYLOAD =>
				--only proceed if input serial flag is ON (input buffer is full)
				if(s_data_sr_received = '1') then
					--If waited for all all 5 payload bytes, wait for the alignment byte
					if(payload_counter = 4) then
						payload_counter := 0;
						next_state <= VALIDATE_ALIGNMENT;
					else
						--keep waiting untill receive 5 payload bytes
						payload_counter := payload_counter + 1;
						next_state <= WAIT_PAYLOAD;
					end if;
				else
					--did not completed input buffer. Wait to fill it
					next_state <= WAIT_PAYLOAD;
				end if;
			----------------------------------------------------------
			when READ_PAYLOAD =>
				--only proceed if input serial flag is ON (input buffer is full)
				if(s_data_sr_received = '1') then
					--If waited for all all 5 payload bytes, wait for the alignment byte
					if(payload_counter = 4) then
						payload_counter := 0;
						next_state <= READ_ALIGNMENT;
					else
						--keep waiting untill receive 5 payload bytes
						payload_counter := payload_counter + 1;
						next_state <= READ_PAYLOAD;
					end if;
				else
					--did not completed input buffer. Wait to fill it
					next_state <= READ_PAYLOAD;
				end if;				
			----------------------------------------------------------
			when READ_ALIGNMENT =>
				--only proceed if input serial flag is ON (input buffer is full)
				if(s_data_sr_received = '1') then
					--Check if alignment is valid and read payload
					if(buffer_in = C_ALIGNMENT_REF) then
						next_state <= READ_PAYLOAD;
					else
						--Invalid alignment: reset state and counter
						next_state <= VALIDATE_ALIGNMENT;
					end if;
				else
					--did not completed input buffer. Wait to fill it
					next_state <= READ_ALIGNMENT;
				end if;
			----------------------------------------------------------
			when others => --RESET
				alignemt_counter := 0;
				payload_counter := 0;
				next_state <= VALIDATE_ALIGNMENT;
		end case;
	end process fsm_next_state_decoder;
	
	sync_out <= '1' when ((state = READ_ALIGNMENT) or (state = READ_PAYLOAD)) else
				'0';
			
	--Bind output ports to signals
	data_pl_out <= buffer_out;
	data_en_out <= s_data_en_out;
	
	write_serial_out: process(clk_in)
	variable v_delay: std_logic := '0';
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				--clear output and control signals / variables
				buffer_out <= (others => '0');
				v_delay := '0';
				s_data_en_out <= '0';
			else
				--Check if received a new data during read state
				if(state = READ_PAYLOAD and s_data_sr_received = '1') then
					--Force a delay to set the output on the next clock cycle
					v_delay := '1';
					s_data_en_out <= '0';					
				elsif(v_delay = '1') then
					--Set output from internal data buffer
					v_delay := '0';
					s_data_en_out <= '1';
					buffer_out <= buffer_eval;
				else
					--Not receiving payload
					v_delay := '0';
					s_data_en_out <= '0';					
				end if;
			end if;
		end if;
	end process write_serial_out;				
	
end arch_rcv_fsm;