--------------------------------------------------
-- File:    pkg_tb_blackjack.vhd
-- Author:  Henrique Krausburg Corrêa <henrique.krausburg.correa@gmail.com>
-- Author:  Giuseppe Generoso <giuseppe.generoso@acad.pucrs.br>
--------------------------------------------------

--Help page about VHDL predefined attributes: https://www.csee.umbc.edu/portal/help/VHDL/attribute.html

LIBRARY ieee;
    USE ieee.std_logic_1164.all;
	use ieee.numeric_std.all;


package pkg_tb_blackjack is

	--Used by procedures to inform an expected score sequence that shall occur during gameplay
	--type t_score_array is array (0 to 21) of std_logic_vector(4 downto 0);
	--(integer range <>)
	type t_score_array is array (natural range <>) of std_logic_vector(4 downto 0);
	
	--Aux constant to limit the max allowed time to stay in a loop
	constant c_timeout_treshold : natural := 10;
	
	-----------------------------------------
	--Aux: helper function to convert unsigned score values to std_logic_vector
	-----------------------------------------  
	function aux_score (score : integer range 0 to 40)
		return std_logic_vector;
	
	-----------------------------------------
	--Aux: validate output
	-----------------------------------------  
	procedure aux_validate_output
	(
		signal win				: in std_logic; 
		constant expected_win	: in std_logic;
		signal lose				: in std_logic; 
		constant expected_lose	: in std_logic; 
		signal tie				: in std_logic; 
		constant expected_tie	: in std_logic; 
		signal total			: in std_logic_vector(4 downto 0);
		constant expected_total	: in std_logic_vector(4 downto 0);
		constant msg_prefix		: in string;
		constant score_owner	: in string
	);
	 
	-----------------------------------------
	--Aux: reset CUV and check output values
	-----------------------------------------  
	procedure aux_reset_and_check
	(
		signal clk 			: in std_logic; 
		signal reset 		: out std_logic; 
		signal debug 		: out std_logic; 
		signal show 		: out std_logic; 
		signal win			: in std_logic; 
		signal lose			: in std_logic; 
		signal tie			: in std_logic; 
		signal total		: in std_logic_vector(4 downto 0);
		constant msg_prefix	: in string
	);
	
	-----------------------------------------
	--Aux: wait player receive a new card and check if the new score match expected value
	----------------------------------------- 		
	procedure aux_player_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		signal lose						: in std_logic;
		signal tie						: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_player_score		: in std_logic_vector(4 downto 0);
		constant actual_dealer_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	);	

	-----------------------------------------
	--Aux: wait dealer receive a new card and check if the new score match expected value
	----------------------------------------- 		
	procedure aux_dealer_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		signal lose						: in std_logic;
		signal tie						: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_dealer_score		: in std_logic_vector(4 downto 0);
		constant actual_player_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	);	 
	
	-----------------------------------------
	--Aux: wait dealer receive the final card and check if the new score match expected value
	----------------------------------------- 	
	procedure aux_dealer_final_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		constant expected_win			: in std_logic;
		signal lose						: in std_logic;
		constant expected_lose			: in std_logic;
		signal tie						: in std_logic;
		constant expected_tie			: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_dealer_score		: in std_logic_vector(4 downto 0);
		constant actual_player_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	);

	-----------------------------------------
	--Aux: wait player receive the final card and check if the new score match expected value
	----------------------------------------- 	
	procedure aux_player_final_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		constant expected_win			: in std_logic;
		signal lose						: in std_logic;
		constant expected_lose			: in std_logic;
		signal tie						: in std_logic;
		constant expected_tie			: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_player_score		: in std_logic_vector(4 downto 0);
		constant actual_dealer_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	);
	
	-----------------------------------------
	--Aux: Validate the first and second card from both player and dealer
	-----------------------------------------  	
	procedure aux_default_initialization
	(
		signal clk 					: in std_logic; 
		signal debug 				: out std_logic; 
		signal show 				: out std_logic; 
		signal win					: in std_logic; 
		signal lose					: in std_logic; 
		signal tie					: in std_logic; 
		signal total				: in std_logic_vector(4 downto 0);
		constant player_score		: in t_score_array;
		variable player_score_index	: inout integer;
		constant dealer_score		: in t_score_array;
		variable dealer_score_index	: inout integer;
		constant msg_prefix	: in string
	);
	 
	-----------------------------------------
	--Test 1: Successfull gameplay: Player wins
	-----------------------------------------  
	procedure test_1_success_win
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
	
	-----------------------------------------
	--Test 2: Successfull gameplay: Player loses
	-----------------------------------------  
	procedure test_2_player_lose
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
	
	-----------------------------------------
	--Test 3: Successfull gameplay: Tie
	-----------------------------------------  
	procedure test_3_tie
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
	
	-----------------------------------------
	--Test 4: Successfull gameplay: ACE only
	-----------------------------------------  
	procedure test_4_ace_only
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
	
	-----------------------------------------
	--Test 5: Successfull gameplay: Player loses for passing 21
	-----------------------------------------  
	procedure test_5_player_passing_21
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
	
	-----------------------------------------
	--Test 6: Successfull gameplay: Dealer loses for passing 21
	-----------------------------------------  
	procedure test_6_dealer_passing_21
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);

	-----------------------------------------
	--Test 7: Decode all kind of cards (valids and invalids)
	-----------------------------------------  
	procedure test_7_decode_all_cards
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);	
	
	-----------------------------------------
	--Test 8: Successfull gameplay: HIT and STAY press test
	-----------------------------------------  
	procedure test_8_hit_stay_press_test
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	);
  
  
end pkg_tb_blackjack;


-----------------------------------------------
-----------------------------------------------
-----------------------------------------------


package body pkg_tb_blackjack is

	-----------------------------------------
	--Aux: helper function to convert unsigned score values to std_logic_vector
	-----------------------------------------  
	function aux_score (score : integer range 0 to 40)
		return std_logic_vector is  
		variable result: std_logic_vector(4 downto 0) := (others => '0');
	begin
		result := std_logic_vector(to_unsigned(score, result'length));
		return result;
	end aux_score;

	-----------------------------------------
	--Aux: validate output
	-----------------------------------------  
	procedure aux_validate_output
	(
		signal win				: in std_logic; 
		constant expected_win	: in std_logic;
		signal lose				: in std_logic; 
		constant expected_lose	: in std_logic; 
		signal tie				: in std_logic; 
		constant expected_tie	: in std_logic; 
		signal total			: in std_logic_vector(4 downto 0);
		constant expected_total	: in std_logic_vector(4 downto 0);
		constant msg_prefix		: in string;
		constant score_owner	: in string
	) is
	begin
		assert (win = expected_win) report msg_prefix & "Invalid win value. Expected: " & std_logic'image(expected_win) & " Got: " & std_logic'image(win) severity error;
		assert (lose = expected_lose) report msg_prefix & "Invalid lose value. Expected: " & std_logic'image(expected_lose) & " Got: " & std_logic'image(lose) severity error;
		assert (tie = expected_tie) report msg_prefix & "Invalid tie value. Expected: " & std_logic'image(expected_tie) & " Got: " & std_logic'image(tie) severity error;
		assert (total = expected_total) report msg_prefix & "Invalid " & score_owner & " score. Expected: " & integer'image(to_integer(unsigned(expected_total))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
	end aux_validate_output;
	
	-----------------------------------------
	--Aux: reset CUV and check output values
	-----------------------------------------  
	procedure aux_reset_and_check
	(
		signal clk 			: in std_logic; 
		signal reset 		: out std_logic; 
		signal debug 		: out std_logic; 
		signal show 		: out std_logic; 
		signal win			: in std_logic; 
		signal lose			: in std_logic; 
		signal tie			: in std_logic; 
		signal total		: in std_logic_vector(4 downto 0);
		constant msg_prefix	: in string
	) is
	begin
		--Reset circuit and prepare to validate dealer output
		wait until clk = '0'; 
		reset <= '1'; 
		debug <= '1';
		show <= '1';
		wait until clk = '1'; wait until clk = '0';
		aux_validate_output(win, '0', lose, '0', tie, '0', total, "00000", msg_prefix & "Reset: ", "dealer");
		--Wait half cycle to validate player output
		debug <= '0';
		show <= '0';
		wait until clk = '1';
		aux_validate_output(win, '0', lose, '0', tie, '0', total, "00000", msg_prefix & "Reset: ", "player");
		--Exit reset procedure
		reset <= '0';
	end aux_reset_and_check;
	
	-----------------------------------------
	--Aux: wait player receive a new card and check if the new score match expected value
	----------------------------------------- 		
	procedure aux_player_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		signal lose						: in std_logic;
		signal tie						: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_player_score		: in std_logic_vector(4 downto 0);
		constant actual_dealer_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	) is
		variable watchdog : natural range 0 to 10 := c_timeout_treshold;
	begin
		--Read actual player score
		debug <= '0'; show <= '0'; wait until clk = '1';
	
		--Wait until player score changes
		while(next_player_score /= total and watchdog > 0) loop			
			--Decrement watchdog counter to avoid stay blocked in this loop
			watchdog := watchdog - 1;			
			
			--Check if player score changed
			wait until clk = '0'; wait until clk = '1';
		end loop;
		
		--Check if loop ended because of a new card or if occoured an timeout
		if(watchdog = 0) then
			report msg_prefix & "Timeout while waiting for player hit the next card. Expected: " & integer'image(to_integer(unsigned(next_player_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
		else
			--Validate if player score changed to the expected value
			aux_validate_output(win, '0', lose, '0', tie, '0', total, next_player_score, msg_prefix, "player");
		end if;
	end aux_player_hit_check;
	
	-----------------------------------------
	--Aux: wait dealer receive a new card and check if the new score match expected value
	----------------------------------------- 	
	procedure aux_dealer_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		signal lose						: in std_logic;
		signal tie						: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_dealer_score		: in std_logic_vector(4 downto 0);
		constant actual_player_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	) is
		variable watchdog : natural range 0 to 10 := c_timeout_treshold;
	begin
		--Read actual dealer score
		debug <= '1'; show <= '1'; wait until clk = '1';
	
		--Wait until player score changes
		while(next_dealer_score /= total and watchdog > 0) loop
			--Decrement watchdog counter to avoid stay blocked in this loop
			watchdog := watchdog - 1;					
			
			--Check if dealer score changed
			wait until clk = '0'; wait until clk = '1';	
		end loop;
		
		--Check if loop ended because of a new card or if occoured an timeout
		if(watchdog = 0) then
			report msg_prefix & "Timeout while waiting for dealer hit the next card. Expected: " & integer'image(to_integer(unsigned(next_dealer_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
		else		
			--Validate if dealer score changed to the expected value
			aux_validate_output(win, '0', lose, '0', tie, '0', total, next_dealer_score, msg_prefix, "dealer");
		end if;
	end aux_dealer_hit_check;	
	
	-----------------------------------------
	--Aux: wait dealer receive the final card and check if the new score match expected value
	----------------------------------------- 	
	procedure aux_dealer_final_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		constant expected_win			: in std_logic;
		signal lose						: in std_logic;
		constant expected_lose			: in std_logic;
		signal tie						: in std_logic;
		constant expected_tie			: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_dealer_score		: in std_logic_vector(4 downto 0);
		constant actual_player_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	) is
		variable watchdog : natural range 0 to 10 := c_timeout_treshold;
	begin
		--Read actual dealer score
		debug <= '1'; show <= '1'; wait until clk = '1';
	
		--Wait until player score changes
		while(next_dealer_score /= total and watchdog > 0) loop						
			--Decrement watchdog counter to avoid stay blocked in this loop
			watchdog := watchdog - 1;			
			
			--Check if dealer score changed
			wait until clk = '0';  wait until clk = '1';			
		end loop;
		
		--Check if loop ended because of a new card or if occoured an timeout
		if(watchdog = 0) then
			report msg_prefix & "Timeout while waiting for dealer hit the next card. Expected: " & integer'image(to_integer(unsigned(next_dealer_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
		else		
			--Validate if dealer final score changed to the expected value
			aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, next_dealer_score, msg_prefix, "dealer");
		end if;
	end aux_dealer_final_hit_check;	
	
	-----------------------------------------
	--Aux: wait player receive the final card and check if the new score match expected value
	----------------------------------------- 	
	procedure aux_player_final_hit_check
	(
		signal clk 						: in std_logic; 
		signal debug 					: out std_logic; 
		signal show 					: out std_logic; 		
		signal win						: in std_logic;
		constant expected_win			: in std_logic;
		signal lose						: in std_logic;
		constant expected_lose			: in std_logic;
		signal tie						: in std_logic;
		constant expected_tie			: in std_logic;
		signal total					: in std_logic_vector(4 downto 0);
		constant next_player_score		: in std_logic_vector(4 downto 0);
		constant actual_dealer_score	: in std_logic_vector(4 downto 0);
		constant msg_prefix				: in string
	) is
		variable watchdog : natural range 0 to 10 := c_timeout_treshold;
	begin
		--Read actual player score
		debug <= '0'; show <= '0'; wait until clk = '1';
	
		--Wait until dealer score changes
		while(next_player_score /= total and watchdog > 0) loop
			--Decrement watchdog counter to avoid stay blocked in this loop
			watchdog := watchdog - 1;			
			
			--Check if player score changed
			wait until clk = '0'; wait until clk = '1';			
		end loop;
		
		--Check if loop ended because of a new card or if occoured an timeout
		if(watchdog = 0) then
			report msg_prefix & "Timeout while waiting for player hit the next card. Expected: " & integer'image(to_integer(unsigned(next_player_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
		else		
			--Validate if dealer final score changed to the expected value
			aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, next_player_score, msg_prefix, "player");
		end if;
	end aux_player_final_hit_check;
	
	-----------------------------------------
	--Aux: Validate the first and second card from both player and dealer
	-----------------------------------------  
	procedure aux_default_initialization
	(
		signal clk 					: in std_logic; 
		signal debug 				: out std_logic; 
		signal show 				: out std_logic; 
		signal win					: in std_logic; 
		signal lose					: in std_logic; 
		signal tie					: in std_logic; 
		signal total				: in std_logic_vector(4 downto 0);
		constant player_score		: in t_score_array;
		variable player_score_index	: inout integer;
		constant dealer_score		: in t_score_array;
		variable dealer_score_index	: inout integer;
		constant msg_prefix			: in string
	) is
	begin
		--Validate first player card
		player_score_index := player_score_index + 1;
		aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player 1st card init: ");
		
		--Validate first dealer card
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer 1st card init: ");
		
		--Validate second player card
		player_score_index := player_score_index + 1;
		aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player 2nd card init: ");
		
		--Validate second dealer card
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer 2nd card init: ");	
	end;
	
	
	-----------------------------------------
	--Test 1: Successfull gameplay: Player wins
	-----------------------------------------  
	procedure test_1_success_win
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(6), aux_score(17), aux_score(13), aux_score(21));	--Expected player score: 0, 6, 17, 13 and 21
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(12), aux_score(16), aux_score(20));	--Expected dealer score: 0, 10, 12, 16 and 20
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '1';
		constant expected_lose: std_logic := '0';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 1: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Start player turn (iterate over player_score array)
		while(player_score_index /= player_score'high)loop
			--Press the 'HIT' button
			wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
			
			--Validate next card
			player_score_index := player_score_index + 1;
			aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player turn: ");
		end loop;
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer turn: ");
			end if;
		end loop;
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), msg_prefix & "Player final result: ", "player");
		
	end test_1_success_win;
	
	-----------------------------------------
	--Test 2: Successfull gameplay: Player loses
	-----------------------------------------  
	procedure test_2_player_lose
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20));	--Expected player score: 0, 10 and 20. 
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(16), aux_score(21));	--Expected dealer score: 0, 10, 16 and 21
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '0';
		constant expected_lose: std_logic := '1';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 2: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Final game turn (Dealer)
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer final turn: ");
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), msg_prefix & "Player final result: ", "player");
		
	end test_2_player_lose;

	-----------------------------------------
	--Test 3: Successfull gameplay: Tie
	-----------------------------------------  
	procedure test_3_tie
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20));	--Expected player score: 0, 10 and 20. 
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(16), aux_score(20));	--Expected dealer score: 0, 10, 16 and 20
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '0';
		constant expected_lose: std_logic := '0';
		constant expected_tie: std_logic := '1';
		constant msg_prefix: string := "Test 3: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Final game turn (Dealer)
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer final turn: ");
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), msg_prefix & "Player final result: ", "player");
	end test_3_tie;
	
	-----------------------------------------
	--Test 4: Successfull gameplay: ACE only
	-----------------------------------------  
	procedure test_4_ace_only
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		--Expected player score: ace only 
		constant player_score : t_score_array := 	(aux_score(0), aux_score(11), aux_score(12), aux_score(13), aux_score(14), aux_score(15), aux_score(16), aux_score(17), aux_score(18), aux_score(19), aux_score(20), aux_score(21), aux_score(12),
													 aux_score(13), aux_score(14), aux_score(15), aux_score(16), aux_score(17), aux_score(18), aux_score(19), aux_score(20), aux_score(21));	
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(11), aux_score(12), aux_score(13), aux_score(14), aux_score(15), aux_score(16), aux_score(17));	--Expected dealer score: ace only
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '1';
		constant expected_lose: std_logic := '0';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 4: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Start player turn (iterate over player_score array)
		while(player_score_index /= player_score'high)loop
			--Press the 'HIT' button
			wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
			
			--Validate next card
			player_score_index := player_score_index + 1;
			aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player turn: ");
		end loop;
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer turn: ");
			end if;
		end loop;
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), msg_prefix & "Player final result: ", "player");
	end test_4_ace_only;
	
	-----------------------------------------
	--Test 5: Successfull gameplay: Player loses for passing 21
	-----------------------------------------  
	procedure test_5_player_passing_21
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20), aux_score(30));	--Expected player score: 0, 10, 20 and 30. 
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(16));	--Expected dealer score: 0, 10 and 16
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '0';
		constant expected_lose: std_logic := '1';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 5: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
				
		--Press the 'HIT' button
		wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
		
		player_score_index := player_score_index + 1;
		--Final game turn
		aux_player_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player final turn: ");
				
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '1'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), msg_prefix & "Dealer final result: ", "dealer");
	end test_5_player_passing_21;
	
	-----------------------------------------
	--Test 6: Successfull gameplay: Dealer loses for passing 21
	-----------------------------------------  
	procedure test_6_dealer_passing_21
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20));	--Expected player score: 0, 10, and 20. 
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(11), aux_score(16), aux_score(15), aux_score(25));	--Expected dealer score: 0, 10, 16 and 26
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '1';
		constant expected_lose: std_logic := '0';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 6: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "Dealer turn: ");
			end if;
		end loop;
	end test_6_dealer_passing_21;
	

	-----------------------------------------
	--Test 7: Decode all kind of cards (valids and invalids)
	-----------------------------------------  
	procedure test_7_decode_all_cards
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20), aux_score(0), aux_score(9), aux_score(16), aux_score(0), aux_score(4), aux_score(6));	--Player - First round:(10 + 10 = 20) Second round(9 + 7 = 16) Third round(4 + 2 = 6)
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20), aux_score(0), aux_score(8), aux_score(14), aux_score(19), aux_score(0), aux_score(3), aux_score(14));	
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant msg_prefix: string := "Test 7: ";
	begin
		--First round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix & "1st round: ");
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix & "1st round: ");
				
		--Second round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix & "2nd round: ");
		wait until request = '1';	--Wait dealer take a card
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix & "2nd round: ");
		
		--increment scores to set expected initial score equal to zero
		player_score_index := player_score_index + 1;
		dealer_score_index := dealer_score_index + 1;
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix & "2nd round: ");
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';

		--Wait dealer take the next card and win this round
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, '0', lose, '1', tie, '0', total, dealer_score(dealer_score_index), player_score(player_score_index), msg_prefix & "2nd round: ");
		
		--Third and final round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix & "3rd round: ");
		wait until request = '1';	--Wait dealer take a card
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix & "3rd round: ");

		--increment scores to set expected initial score equal to zero
		player_score_index := player_score_index + 1;
		dealer_score_index := dealer_score_index + 1;
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix & "3rd round: ");		
				
		--Test finish: decoded all 16 possible card codes
	end test_7_decode_all_cards;	
	

	-----------------------------------------
	--Test 8: Successfull gameplay: HIT and STAY press test
	-----------------------------------------  
	procedure test_8_hit_stay_press_test
	(
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal stay 	: out std_logic; 
		signal hit	 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal card		: in std_logic_vector(3 downto 0);
		signal request	: in std_logic;
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is 
		constant player_score : t_score_array := (aux_score(0), aux_score(10), aux_score(20), aux_score(21));	--Expected player score: 0, 10, 20 and 21
		variable player_score_index : integer range player_score'range := player_score'low;
		constant dealer_score : t_score_array := (aux_score(0), aux_score(10), aux_score(16));	--Expected dealer score: 0, 10 and 16
		variable dealer_score_index : integer range dealer_score'range := dealer_score'low;
		constant expected_win: std_logic := '0';
		constant expected_lose: std_logic := '0';
		constant expected_tie: std_logic := '0';
		constant msg_prefix: string := "Test 8: ";
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total, msg_prefix);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index, msg_prefix);
		
		--Press the 'HIT' and 'STAY' button
		wait until clk = '0'; hit <= '1'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0'; stay <= '0';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), msg_prefix & "Dealer final result: ", "dealer");
		
		--Wait a while to see if CUV compute a undesired 'HIT' or 'STAY' press 
		for i in 0 to 5 loop
			debug <= '0'; show <= '0'; wait until clk = '1'; wait until clk = '0';
			aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), msg_prefix & "Player wait: ", "player");
		end loop;
		
		--Press the 'HIT' button
		wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
		
		player_score_index := player_score_index + 1;
		--Final game turn
		aux_player_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), dealer_score(dealer_score_index), msg_prefix & "Player final turn: ");
	end test_8_hit_stay_press_test;
	
	
end pkg_tb_blackjack;

