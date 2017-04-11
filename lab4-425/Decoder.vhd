library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
port(
	clock : in std_logic;
	instruction : in std_logic_vector(31 downto 0);
	op_code : out std_logic_vector(5 downto 0);
	dest_reg : out std_logic_vector(4 downto 0);
	store : out std_logic;
	load : out std_logic;
	use_imm : out std_logic;
	imm : out std_logic_vector(15 downto 0);
	r1 : out std_logic_vector(4 downto 0);
	r2 : out std_logic_vector(4 downto 0);
	format_select_IJ : out std_logic
);

end control;

architecture arch of control is

begin

process(clock)

begin

if(rising_edge(clock)) then
	op_code <= instruction(31 downto 27);
	dest_reg <= instruction(15 downto 11);
	r1 <= instruction(25 downto 21);
	r2 <= instruction(20 downto 16);
	
	if(instruction(31 downto 27) = ADDI
end if;


end process;

end arch;