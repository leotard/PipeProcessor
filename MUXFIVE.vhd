library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUXFIVE is
port(
	clock : in std_logic;
	control : in std_logic_vector(2 downto 0);
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	C : in std_logic_vector(31 downto 0);
	D : in std_logic_vector(31 downto 0);
	E : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end MUXFIVE;

architecture arch of MUXFIVE is

begin

  output <= A when control = "000" else
            B when control = "001" else
            C when control = "010" else
            D when control = "011" else
            E;
          


end arch;
