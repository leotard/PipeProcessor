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

if(rising_edge(clock)) then
	if(control = "000") then
		output <= A;
	elsif(control = "001") then
		output <= B;
	elsif(control = "010") then
		output <= C;
	elsif(control = "011") then
		output <= D;
	elsif(control = "100") then
		output <= E;
	end if;
end if;


end arch;
