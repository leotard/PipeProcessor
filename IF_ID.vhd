library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID is
port(
	clock : in std_logic;

	--signals in
	instruction_old : in std_logic_vector(31 downto 0);
	address_old : in std_logic_vector(31 downto 0);
	--hazard detection
	IF_ID_forward : in std_logic :='1';

	--signals out
	instruction_out : out std_logic_vector(31 downto 0);
	address_out : out std_logic_vector(31 downto 0)

);
end entity;

architecture behavior of IF_ID is 

signal instruction_old_t, address_old_t : std_logic_vector(31 downto 0);

begin
	fetch: process(address_old, instruction_old)
	begin
		address_old_t <= address_old;
		instruction_old_t <= instruction_old;
	end process;

	latch: process(clock)
	begin
		if(rising_edge(clock) and IF_ID_forward = '1') then 
			instruction_out <= instruction_old_t;
			address_out <= address_old_t;
		end if;
	end process;

end behavior;