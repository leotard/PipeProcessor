library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder_shifter is
port(
	address : in std_logic_vector(31 downto 0);
	pc : in std_logic_vector(31 downto 0);
	new_pc : out std_logic_vector(31 downto 0)
);

end pc_adder_shifter;


architecture arch of pc_adder_shifter is


begin

	
	new_pc <= std_logic_vector(shift_left(unsigned(address), 2) + unsigned(pc));




end arch;
