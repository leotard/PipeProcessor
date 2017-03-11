library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
port(
	clock : in std_logic;
	instruction : in std_logic_vector(5 downto 0);
	op_code : out std_logic_vector(5 downto 0);
	branch : out std_logic;
	mem_read : out std_logic;
	mem_to_reg : out std_logic;
	mem_write : out std_logic;
	alu_src : out std_logic_vector(15 downto 0);
	reg_write : out std_logic_vector(4 downto 0)
);

end control;

architecture arch of control is

begin

process(clock)

begin

if(rising_edge(clock)) then
	op_code <= instruction;
	
	
end if;


end process;

end arch;