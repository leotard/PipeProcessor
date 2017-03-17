
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end processor_tb;

architecture behavior of processor_tb is

component processor is
port(
	clock : in std_logic;
	--PC : in std_logic_vector(31 downto 0);
	--new_pc : in std_logic_vector(31 downto 0)
	instruction_out1 : in std_logic_vector(31 downto 0);
	wr_in1 : in std_logic_vector(4 downto 0);
	wd_in1 : in std_logic_vector(31 downto 0);
	regWrite_in1 : in std_logic;
	alu_output : out std_logic_vector(31 downto 0)
);
end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;


signal instruction_out1, alu_output : std_logic_vector(31 downto 0);
signal wr_in1 : std_logic_vector(4 downto 0);
signal wd_in1 : std_logic_vector(31 downto 0);
signal regWrite_in1 : std_logic;



begin

-- Connect the components which we instantiated above to their
-- respective signals.
dut: processor 
port map(
	clock => clk,
	instruction_out1 => instruction_out1,
	wr_in1 => wr_in1,
	wd_in1 => wd_in1,
	regWrite_in1 => regWrite_in1,
	alu_output => alu_output
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
	alu_output <= alu_output;
	instruction_out1 <= "00100000000010100000000000000100";
	wr_in1 <= "00000";
	wd_in1 <= "00000000000000000000000000000000";
	regWrite_in1 <= '0';

	wait for 4*clk_period;
	
wait;
end process;
	
--reset <= wait_signal_1;

end;
