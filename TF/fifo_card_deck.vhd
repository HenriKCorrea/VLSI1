--------------------------------------------------
-- File:    rcv_fsm.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TB_STD_FIFO IS
END TB_STD_FIFO;

ARCHITECTURE behavior OF TB_STD_FIFO IS 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component STD_FIFO
		Generic (
			constant DATA_WIDTH  : positive := 4;
			constant FIFO_DEPTH	: positive := 16;
			constant TEST_1 := x"1245";
			constant TEST_2 := x"78A4";
			constant TEST_3 := x"AA82"
		);
		port (
			CLK		: in std_logic;
			RST		: in std_logic;
			WriteEn	: in std_logic;
			DataOut	: out std_logic_vector(3 downto 0)
		);
	end component;
	
	--Inputs
	signal CLK		: std_logic := '0';
	signal RST		: std_logic := '0';
	signal WriteEn	: std_logic := '0';
	
	--Outputs
	signal DataOut	: std_logic_vector(3 downto 0);
	
	-- Clock period definitions
	constant CLK_period : time := 5 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: STD_FIFO
		PORT MAP (
			CLK		=> CLK,
			RST		=> RST,
			WriteEn	=> WriteEn,
			DataOut	=> DataOut
		);
	
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
	
	-- Reset process
	rst_proc : process
	begin
	wait for CLK_period * 5;
		
		RST <= '1';
		
		wait for CLK_period * 5;
		
		RST <= '0';
		
		wait;
	end process;
	
	-- Write process
	wr_proc : process
		variable counter : unsigned (7 downto 0) := (others => '0');
	begin		
		wait for CLK_period * 20;

		for i in 1 to 32 loop
			counter := counter + 1;
			
			DataIn <= std_logic_vector(counter);
			
			wait for CLK_period * 1;
			
			WriteEn <= '1';
			
			wait for CLK_period * 1;
		
			WriteEn <= '0';
		end loop;
		
		wait;
	end process;
	
	-- Read process
	rd_proc : process
	begin
		wait for CLK_period * 20;
		
		wait for CLK_period * 40;
			
		ReadEn <= '1';
		
		wait for CLK_period * 60;
		
		ReadEn <= '0';
		
		wait for CLK_period * 256 * 2;
		
		ReadEn <= '1';
		
		wait;
	end process;

END;



--------------------------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity STD_FIFO is
	Generic (
		constant DATA_WIDTH  : positive := 8;
		constant FIFO_DEPTH	: positive := 256;
		constant TEST_1 := x"1245";
		constant TEST_2 := x"78A4";
		constant TEST_3 := x"AA82"
	);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC;
		Full	: out STD_LOGIC
	);
end STD_FIFO;

architecture Behavioral of STD_FIFO is

begin

	-- Memory Pointer Process
	fifo_proc : process (CLK)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		variable Memory : FIFO_Memory;
		
		variable Head : natural range 0 to FIFO_DEPTH - 1;
		variable Tail : natural range 0 to FIFO_DEPTH - 1;
		
		variable Looped : boolean;
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Head := 0;
				Tail := 0;
				
				Looped := false;
				
				Full  <= '0';
				Empty <= '1';
			else
				if (ReadEn = '1') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						DataOut <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = FIFO_DEPTH - 1) then
							Tail := 0;
							
							Looped := false;
						else
							Tail := Tail + 1;
						end if;
						
						
					end if;
				end if;
				
				if (WriteEn = '1') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) := DataIn;
						
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head := 0;
							
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
				end if;
				
				-- Update Empty and Full flags
				if (Head = Tail) then
					if Looped then
						Full <= '1';
					else
						Empty <= '1';
					end if;
				else
					Empty	<= '0';
					Full	<= '0';
				end if;
			end if;
		end if;
	end process;
		
end Behavioral;