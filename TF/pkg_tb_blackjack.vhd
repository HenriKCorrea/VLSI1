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
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
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
		variable dealer_score_index	: inout integer
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
		signal clk 		: in std_logic; 
		signal reset 	: out std_logic; 
		signal debug 	: out std_logic; 
		signal show 	: out std_logic; 
		signal win		: in std_logic; 
		signal lose		: in std_logic; 
		signal tie		: in std_logic; 
		signal total	: in std_logic_vector(4 downto 0)
	) is
	begin
		--Reset circuit and prepare to validate dealer output
		wait until clk = '0'; 
		reset <= '1'; 
		debug <= '1';
		show <= '1';
		wait until clk = '1'; wait until clk = '0';
		aux_validate_output(win, '0', lose, '0', tie, '0', total, "00000", "Reset: ", "dealer");
		--Wait half cycle to validate player output
		debug <= '0';
		show <= '0';
		wait until clk = '1';
		aux_validate_output(win, '0', lose, '0', tie, '0', total, "00000", "Reset: ", "player");
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
		variable actual_player_score : std_logic_vector(4 downto 0) := (others => '0');
	begin
		--Read actual player score
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		actual_player_score := total;
	
		--Wait until player score changes
		while(actual_player_score = total) loop
			--Validate if player output didn't changed
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_player_score, msg_prefix, "player");
			
			--Validate if dealer output didn't changed
			wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';		
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_dealer_score, msg_prefix, "dealer");
			
			--Check if player score changed
			wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		end loop;
		
		--Validate if player score changed to the expected value
		aux_validate_output(win, '0', lose, '0', tie, '0', total, next_player_score, msg_prefix, "player");
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
		variable actual_dealer_score : std_logic_vector(4 downto 0) := (others => '0');
	begin
		--Read actual dealer score
		wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';
		actual_dealer_score := total;
	
		--Wait until player score changes
		while(actual_dealer_score = total) loop
			--Validate if dealer output didn't changed
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_dealer_score, msg_prefix, "dealer");
			
			--Validate if player output didn't changed
			wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';		
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_player_score, msg_prefix, "player");
			
			--Check if dealer score changed
			wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';
		end loop;
		
		--Validate if dealer score changed to the expected value
		aux_validate_output(win, '0', lose, '0', tie, '0', total, next_dealer_score, msg_prefix, "dealer");
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
		variable actual_dealer_score : std_logic_vector(4 downto 0) := (others => '0');
	begin
		--Read actual dealer score
		wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';
		actual_dealer_score := total;
	
		--Wait until player score changes
		while(actual_dealer_score = total) loop
			--Validate if dealer output didn't changed
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_dealer_score, msg_prefix, "dealer");
			
			--Validate if player score didn't changed
			wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
			assert (total = actual_player_score) report msg_prefix & "Invalid player score. Expected: " & integer'image(to_integer(unsigned(actual_player_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
			
			--Check if dealer score changed
			wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';
		end loop;
		
		--Validate if dealer final score changed to the expected value
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, next_dealer_score, msg_prefix, "dealer");
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
		variable actual_player_score : std_logic_vector(4 downto 0) := (others => '0');
	begin
		--Read actual player score
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		actual_player_score := total;
	
		--Wait until dealer score changes
		while(actual_player_score = total) loop
			--Validate if player output didn't changed
			aux_validate_output(win, '0', lose, '0', tie, '0', total, actual_player_score, msg_prefix, "player");
			
			--Validate if dealer score didn't changed
			wait until clk = '0'; debug <= '1'; show <= '1'; wait until clk = '1';
			assert (total = actual_dealer_score) report msg_prefix & "Invalid dealer score. Expected: " & integer'image(to_integer(unsigned(actual_dealer_score))) & " Got: " & integer'image(to_integer(unsigned(total))) severity error;
			
			--Check if player score changed
			wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		end loop;
		
		--Validate if dealer final score changed to the expected value
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, next_player_score, msg_prefix, "player");
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
		variable dealer_score_index	: inout integer
	) is
	begin
		--Validate first player card
		player_score_index := player_score_index + 1;
		aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player 1st card init: ");
		
		--Validate first dealer card
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer 1st card init: ");
		
		--Validate second player card
		player_score_index := player_score_index + 1;
		aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player 2nd card init: ");
		
		--Validate second dealer card
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer 2nd card init: ");	
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Start player turn (iterate over player_score array)
		while(player_score_index /= player_score'high)loop
			--Press the 'HIT' button
			wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
			
			--Validate next card
			player_score_index := player_score_index + 1;
			aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player turn: ");
		end loop;
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer turn: ");
			end if;
		end loop;
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), "Player final result: ", "player");
		
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Final game turn (Dealer)
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer final turn: ");
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), "Player final result: ", "player");
		
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Final game turn (Dealer)
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer final turn: ");
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), "Player final result: ", "player");
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Start player turn (iterate over player_score array)
		while(player_score_index /= player_score'high)loop
			--Press the 'HIT' button
			wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
			
			--Validate next card
			player_score_index := player_score_index + 1;
			aux_player_hit_check(clk, debug, show, win, lose, tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player turn: ");
		end loop;
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer turn: ");
			end if;
		end loop;
		
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '0'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), "Player final result: ", "player");
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
				
		--Press the 'HIT' button
		wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
		
		player_score_index := player_score_index + 1;
		--Final game turn
		aux_player_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player final turn: ");
				
		--Validate player final result
		wait until clk = '0'; debug <= '0'; show <= '1'; wait until clk = '1';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), "Dealer final result: ", "dealer");
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';
		
		--Start dealer turn
		while(dealer_score_index /= dealer_score'high)loop
			--Check if the next card will be the final game turn or if will be a normal turn
			dealer_score_index := dealer_score_index + 1;
			if(dealer_score_index = dealer_score'high) then
				--Final game turn
				aux_dealer_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer final turn: ");
			else
				--Dealer normal turn
				aux_dealer_hit_check(clk, debug, show, win, lose, tie, total, dealer_score(dealer_score_index), player_score(player_score_index), "Dealer turn: ");
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
		--constant expected_win: std_logic := '0';
		--constant expected_lose: std_logic := '1';
		--constant expected_tie: std_logic := '0';
	begin
		--First round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
				
		--Second round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--increment scores to set expected initial score equal to zero
		player_score_index := player_score_index + 1;
		dealer_score_index := dealer_score_index + 1;
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Press the 'STAY' button
		wait until clk = '0'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; stay <= '0';

		--Wait dealer take the next card and win this round
		dealer_score_index := dealer_score_index + 1;
		aux_dealer_final_hit_check(clk, debug, show, win, '0', lose, '1', tie, '0', total, dealer_score(dealer_score_index), player_score(player_score_index), "Test 7: Dealer 2nd round final turn: ");
		
		--Third and final round: Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);

		--increment scores to set expected initial score equal to zero
		player_score_index := player_score_index + 1;
		dealer_score_index := dealer_score_index + 1;
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);		
				
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
	begin
		--Reset blackjack
		aux_reset_and_check(clk, reset, debug, show, win, lose, tie, total);
		
		--wait initialization
		aux_default_initialization(clk, debug, show, win, lose, tie, total, player_score, player_score_index, dealer_score, dealer_score_index);
		
		--Press the 'HIT' and 'STAY' button
		wait until clk = '0'; hit <= '1'; stay <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0'; stay <= '0';
		aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, dealer_score(dealer_score_index), "Dealer final result: ", "dealer");
		
		--Wait a while to see if CUV compute a undesired 'HIT' or 'STAY' press 
		for i in 0 to 5 loop
			debug <= '0'; show <= '0'; wait until clk = '1'; wait until clk = '0';
			aux_validate_output(win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), "Player wait: ", "player");
		end loop;
		
		--Press the 'HIT' button
		wait until clk = '0'; hit <= '1'; wait until clk = '1'; wait until clk = '0'; hit <= '0';
		
		player_score_index := player_score_index + 1;
		--Final game turn
		aux_player_final_hit_check(clk, debug, show, win, expected_win, lose, expected_lose, tie, expected_tie, total, player_score(player_score_index), dealer_score(dealer_score_index), "Player final turn: ");
	end test_8_hit_stay_press_test;
	
	
end pkg_tb_blackjack;

