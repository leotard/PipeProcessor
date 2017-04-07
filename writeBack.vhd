library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity writeBack is
port(
	clock : in std_logic;
	write_reg_MEM : in std_logic_vector(4 downto 0);
	control : in std_logic;
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0);
	write_reg_MEM_OUT : out std_logic_vector(4 downto 0)
);
end writeBack;

architecture arch of writeBack is

--signal REG_output: std_logic_vector(31 downto 0):="00000000000000000000000000000000";

begin


output <= A when control = '1' else
            B;
write_reg_MEM_OUT <= write_reg_MEM;


end arch;

