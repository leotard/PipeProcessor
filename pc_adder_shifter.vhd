library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder_shifter is
port(
	clock : in std_logic;
	address : in std_logic_vector(31 downto 0);
	pc : in std_logic_vector(31 downto 0);
	new_pc : out std_logic_vector(31 downto 0)
);

end pc_adder_shifter;


architecture arch of pc_adder_shifter is


begin

process(clock)

variable shifted : unsigned(31 downto 0);


begin

if(rising_edge(clock)) then
	shifted := shift_left(unsigned(address), 2);
	new_pc <= std_logic_vector(shifted + unsigned(pc));
end if;

end process;

end arch;
