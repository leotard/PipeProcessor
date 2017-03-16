
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionFetch_tb is
end instructionFetch_tb;

architecture behavior of instructionFetch_tb is

component instructionFetch is
port(
		clock: in std_logic;
		control : in std_logic;
		EX_stage: in std_logic_vector(31 downto 0);
		--PC: in std_logic_vector(31 downto 0);
		PC_out: out std_logic_vector(31 downto 0);
		IR: out std_logic_vector(31 downto 0)
	);
end component;

	
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;

signal control : std_logic;
signal EX_stage: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
signal PC_out: std_logic_vector(31 downto 0);
signal IR: std_logic_vector(31 downto 0);

begin 
  
  dut: instructionFetch port map(clk, control, EX_stage, PC_out, IR);
  
  
  
  clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;


test_process : process
begin 
  wait for clk_period/2;

control <= '0';
  wait for 5*clk_period;

  control <= '1';
  wait for 1*clk_period;

  control <= '0';
  wait for 5*clk_period;
  
  
end process;
end behavior;