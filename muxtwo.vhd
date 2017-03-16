library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUXTWO is
port(
	control : in std_logic;
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end MUXTWO;

architecture arch of MUXTWO is

begin

  output <= A when control = '1' else
            B;
end arch;

