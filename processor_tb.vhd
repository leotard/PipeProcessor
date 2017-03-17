
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end processor_tb;

architecture behavior of processor_tb is

component processor is
port(
	clock : in std_logic
);
end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;



begin

-- Connect the components which we instantiated above to their
-- respective signals.
dut: processor 
port map(
	clock => clk
);


				

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;



test_process : process

begin
	--add
	wait for clk_period/2;
	

	wait for 4*clk_period;
	
wait;
end process;
	
--reset <= wait_signal_1;

end;
