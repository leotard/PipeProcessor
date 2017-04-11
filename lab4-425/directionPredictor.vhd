LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


--this is a 2-bit predictor
entity directionPredictor is
	Port(
		clock: in std_logic;
		op_code : in std_logic_vector(5 downto 0);
		branch : in std_logic;
		branch_actual : in std_logic;
		branch_pred : out std_logic;

		--00 strong not taken
		--01 weak not taken
		--10 weak taken
		--11 strong taken
		pred_s : out std_logic_vector(1 downto 0)
		);
end directionPredictor;

architecture behaviour of directionPredictor is
signal pred_t : std_logic_vector(1 downto 0):="00";
signal op_code_t : std_logic_vector(5 downto 0);

begin
	pred_s <= pred_t;
	op_code_t <= op_code;

	process(clock)
	begin
		if(falling_edge(clock) and branch = '1') then
			case pred_t is
				when "00" =>
					branch_pred <= '0';

				when "01" =>
					branch_pred <= '0';

				when "10" =>
					branch_pred <= '1';

				when "11" =>
					branch_pred <= '1';
			
				when others =>
					null;
			end case;
		end if;
	end process;

	process(clock)
	begin
		if(rising_edge(clock) and branch ='1') then
			case pred_t is
				when "00" =>
					if (branch_actual = '0' and (op_code_t = "000100" or op_code_t = "000101") ) then
						pred_t <= "00";
					elsif (branch_actual = '1' and (op_code_t = "000100" or op_code_t = "000101")) then
						pred_t <= "01";
					end if;

				when "01" =>
					if (branch_actual = '0' and (op_code_t = "000100" or op_code_t = "000101") ) then
						pred_t <= "00";
					elsif (branch_actual = '1' and (op_code_t = "000100" or op_code_t = "000101")) then
						pred_t <= "10";
					end if;

				when "10" =>
					if (branch_actual = '0' and (op_code_t = "000100" or op_code_t = "000101") ) then
						pred_t <= "01";
					elsif (branch_actual = '1' and (op_code_t = "000100" or op_code_t = "000101")) then
						pred_t <= "11";
					end if;

				when "11" =>
					if (branch_actual = '0' and (op_code_t = "000100" or op_code_t = "000101") ) then
						pred_t <= "10";
					elsif (branch_actual = '1' and (op_code_t = "000100" or op_code_t = "000101")) then
						pred_t <= "11";
					end if;

				when others =>
					null;
			end case;
		end if;
	end process;

end behaviour;




