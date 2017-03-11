library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_lib is
	port (
		rd1 : out std_logic_vector(31 downto 0);
		rd2 : out std_logic_vector(31 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rr2 : in std_logic_vector(4 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0);

		clk : in std_logic
	);
end register_lib;

arcitecture behavioral of register_lib is 
	type registers is array(0 to 31) of std_logic_vector(31 downto 0);
	signal register : registers;

begin
	regFile : process (clk) is
	begin
		if rising_edge (clk) then
			rd1 <= register(to_integer(unsigned(rr1)));
			rd2 <= register(to_integer(unsigned(rr2)));

			if writeEnable = '1' then
				register(to_integer(unsigned(wr))) <= wd;

				if rr1 = wr then
					rd1 <= wd;
				end if;
				
				if rr2 = wr then
					rd2 <= wd;
				end if;

				-- make register(0) read only
				if wr = '0' then
					wd <= wd;
				end if;

			end if;
		end if;
	end process;
end behavioral;