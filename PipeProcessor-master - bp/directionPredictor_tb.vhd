LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY directionPredictor_tb is
end directionPredictor_tb;

architecture test of directionPredictor_tb is
component directionPredictor is
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
end component;
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;

signal op_code_t : std_logic_vector(5 downto 0):= (OTHERS => '0');
signal branch_t : std_logic:= '0';
signal branch_actual_t : std_logic:= '0';
signal branch_pred_t : std_logic := '0';
signal pred_t : std_logic_vector(1 downto 0) := (OTHERS => '0');

begin
directionPredictor_t : directionPredictor
PORT MAP(
	clock => clk,
	op_code => op_code_t,
	branch => branch_t,
	branch_actual => branch_actual_t,
	branch_pred => branch_pred_t,
	pred_s => pred_t
);


clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;


directionPredictor_test : process
begin
--Branch test1
op_code_t <= "000100";
branch_t <= '0';
branch_actual_t <= '0';

REPORT "---------------Testing Branch Predictor---------------";

ASSERT(branch_pred_t = '0' and pred_t = "00")
REPORT "Branch is wrong"	SEVERITY ERROR;
wait for 1*clk_period;

--Branch test2
op_code_t <= "000100";
branch_t <= '1';


REPORT "---------------Testing Branch Predictor---------------";

ASSERT(branch_pred_t = '0' and pred_t = "01")
REPORT "Branch is wrong"	SEVERITY ERROR;
wait for 1*clk_period;
branch_actual_t <= '1';

--Branch test3
op_code_t <= "000100";
branch_t <= '0';


REPORT "---------------Testing Branch Predictor---------------";

ASSERT(branch_pred_t = '1' and pred_t = "10")
REPORT "Branch is wrong"	SEVERITY ERROR;
wait for 1*clk_period;
branch_actual_t <= '1';

--Branch test4
op_code_t <= "000100";
branch_t <= '1';


REPORT "---------------Testing Branch Predictor---------------";

ASSERT(branch_pred_t = '1' and pred_t = "11")
REPORT "Branch is wrong"	SEVERITY ERROR;
wait for 1*clk_period;
branch_actual_t <= '1';
WAIT;

end process;

end test;