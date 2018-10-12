--------------------------------------------------
-- File:    rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
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

	--Flag used to indicate when the alignment has been validated with success
	signal s_valid_alignment : std_logic := '0';	
	
	--Flag used to indicate when an error occured during alignment validation
	signal s_invalid_alignment : std_logic := '0';	
	
	--Flag: Indicate if input data has been suspended by the user
	signal s_suspended_input_data : std_logic := '0';
	
	--Signal of new data available at paralel output
	signal s_data_en_out : std_logic := '0';
	
	--Count the number of received valid alignments before enable output
	signal s_alignemt_counter : integer range 0 to 3 := 0;	
	
	--Count the number of received payload bytes after an alignment validation
	signal s_payload_counter : integer range 0 to 5 := 0;		
begin

	s_suspended_input_data <= 	'1' when data_sr_in /= '1' and data_sr_in /= '0' else
								'0';
	
	validate_alignment_process: process(clk_in)
	variable v_count : integer range 0 to 7 := 7;
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				v_count := 7;
				s_invalid_alignment <= '0';
				s_valid_alignment <= '0';
				s_alignemt_counter <= 0;
			--Check if the actual state is to validate alignment
			elsif((next_state = VALIDATE_ALIGNMENT) or (next_state = READ_ALIGNMENT)) then
				--Check if alignment is valid
				if(C_ALIGNMENT_REF(v_count) /= data_sr_in) then
					--Validation failure
					s_invalid_alignment <= '1';
					s_valid_alignment <= '0';
					v_count := 7;
					s_alignemt_counter <= 0;
				elsif v_count = 0 then
					--Validation success
					v_count := 7;
					s_valid_alignment <= '1';
					s_invalid_alignment <= '0';
					
					--If device is still on VALIDATE_ALIGNMENT state, increment counter of successful alignment validation (consecutive)
					if(next_state = VALIDATE_ALIGNMENT) then
						s_alignemt_counter <= s_alignemt_counter + 1;
					end if;
				else
					--Wait for the next bit
					v_count := v_count - 1;
					s_invalid_alignment <= '0';
					s_valid_alignment <= '0';
				end if;			
			else
				--Not alignment state: skip
				s_invalid_alignment <= '0';
				s_valid_alignment <= '0';			
			end if;
		end if;
	end process validate_alignment_process;	


	read_serial_in: process(clk_in)
	variable v_count : integer range 0 to 7 := 0;
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				buffer_in <= (others => '0');
				v_count := 0;
				s_data_sr_received <= '0';
				s_payload_counter <= 0;
			elsif((next_state = WAIT_PAYLOAD) or (next_state = READ_PAYLOAD)) then
				--Shift data and insert new received data
				buffer_in <=  buffer_in(6 downto 0) & data_sr_in;
				
				if v_count = 7 then
					--move received data to internal buffer
					v_count := 0;
					s_data_sr_received <= '1';
					s_payload_counter <= s_payload_counter + 1;
				else
					--Increment counter and go back get the next serial bit
					v_count := v_count + 1;
					s_data_sr_received <= '0';
				end if;
			else
				--Not a payload: Skip
				v_count := 0;
				s_data_sr_received <= '0';
				s_payload_counter <= 0;
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

	fsm_next_state_decoder: process(state, s_data_sr_received, s_valid_alignment, s_invalid_alignment, s_suspended_input_data)
	begin
		case state is
			---------------------------------------------------------
			when VALIDATE_ALIGNMENT =>
				--If received three valid alignments, enable output
				if(s_valid_alignment = '1' and s_alignemt_counter = 3) then
					next_state <= READ_PAYLOAD;
				elsif(s_valid_alignment = '1') then
					--Not synced yet. Wait for the next alignment word
					next_state <= WAIT_PAYLOAD;
				else
					--did not completed validation. 
					next_state <= VALIDATE_ALIGNMENT;
				end if;
			----------------------------------------------------------
			when WAIT_PAYLOAD =>
				--If receive all 5 payload bytes, prepare to validate the alignment byte
				if(s_data_sr_received = '1' and s_payload_counter = 5) then
					next_state <= VALIDATE_ALIGNMENT;
				else
					--did not completed input buffer. Keep waiting until receive 5 payload bytes
					next_state <= WAIT_PAYLOAD;
				end if;
			----------------------------------------------------------
			when READ_PAYLOAD =>
				--If receive all 5 payload bytes, prepare to read the alignment byte
				if(s_data_sr_received = '1' and s_payload_counter = 5) then
					next_state <= READ_ALIGNMENT;
				elsif(s_suspended_input_data = '1') then
					--FAIL: data transmission has been suspended.
					next_state <= VALIDATE_ALIGNMENT;
				else
					--did not completed input buffer. Keep waiting untill receive 5 payload bytes
					next_state <= READ_PAYLOAD;
				end if;			
			----------------------------------------------------------
			when READ_ALIGNMENT =>
				--Check if alignment is valid
				if(s_valid_alignment = '1') then
					next_state <= READ_PAYLOAD;
				elsif(s_invalid_alignment = '1' or s_suspended_input_data = '1') then
					--Invalid alignment: reset state
					next_state <= VALIDATE_ALIGNMENT;
				else
					--did not completed validation.
					next_state <= READ_ALIGNMENT;
				end if;			
			----------------------------------------------------------
			when others => --RESET (Initial condition)
				next_state <= VALIDATE_ALIGNMENT;
		end case;
	end process fsm_next_state_decoder;
	
	--sync_out behavior
	sync_out <= '1' when ((next_state = READ_ALIGNMENT) or (next_state = READ_PAYLOAD)) else
				'0';
				
	--Bind output ports to signals
	data_pl_out <= buffer_out;
	data_en_out <= s_data_en_out;
	
	write_serial_out: process(clk_in)
	begin
		if clk_in'event and clk_in = CLK_EDGE then
			if rst_in = '1' then
				--clear output and control signals / variables
				buffer_out <= (others => '0');
				s_data_en_out <= '0';
			else
				--Check if received a new data during read state
				if(state = READ_PAYLOAD and s_data_sr_received = '1') then
					--Set output from internal data buffer
					s_data_en_out <= '1';
					buffer_out <= buffer_eval;
				else
					--Not receiving payload
					s_data_en_out <= '0';
				end if;
			end if;
		end if;
	end process write_serial_out;				
	
end arch_rcv_fsm;