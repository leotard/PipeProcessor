library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers_lib is
	port (
		rd1 : out std_logic_vector(31 downto 0);
		rd2 : out std_logic_vector(31 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rr2 : in std_logic_vector(4 downto 0);
		--alu_lh_w : in std_logic;

		--alu_lo_in : in std_logic_vector(31 downto 0);
		--alu_hi_in : in std_logic_vector(31 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0);
		--alu_hi_out : out std_logic_vector(31 downto 0);
		--alu_lo_out : out std_logic_vector(31 downto 0);
		clk : in std_logic
	);
end registers_lib;

architecture behavioral of registers_lib is 
	type registers is array(0 to 33) of std_logic_vector(31 downto 0);
	signal reg : registers;
	signal rd1_t, rd2_t, alu_lo_out_t, alu_hi_out_t : std_logic_vector(31 downto 0);

begin

rd1 <= rd1_t;
rd2 <= rd2_t;
--alu_lo_out <= alu_lo_out_t;
--alu_hi_out <= alu_hi_out_t;

	process(clk)
	begin
		--wait for active clock edge
		--register 0 is hardwired to 0
		reg(0) <= (others => '0');
		if (clk'event and clk = '1') then
			rd1_t <= reg(to_integer(unsigned(rr1)));
			rd2_t <= reg(to_integer(unsigned(rr2)));
			--alu_lo_out_t <= reg(32);
			--alu_hi_out_t <= reg(33);

			if writeEnable = '1' then
				reg(to_integer(unsigned(wr))) <= wd;
			end if;
						
				--if rr1 = wr then
					--rd1_t <= wd;
				--end if;
				
				--if rr2 = wr then
					--rd2_t <= wd;
				--end if;


				--if alu_lh_w = '1' then
				--	reg(32) <= alu_lo_in;
				--	reg(33) <= alu_hi_in;
				--end if;
		end if;
	end process;
end behavioral;
