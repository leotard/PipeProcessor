library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registers_tb is

end registers_tb;

architecture test of registers_tb is 

component registers_lib is 
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
end component registers_lib;

signal clk : std_logic;

signal rd1_t : std_logic_vector(31 downto 0);
signal rd2_t : std_logic_vector(31 downto 0);
signal rr1_t : std_logic_vector(4 downto 0);
signal rr2_t : std_logic_vector(4 downto 0);

signal writeEnable_t : std_logic;
signal wr_t : std_logic_vector(4 downto 0);
signal wd_t : std_logic_vector(31 downto 0);

begin

testReg: registers_lib
	PORT MAP
	(
		rd1 => rd1_t,
		rd2 => rd2_t,
		rr1 => rr1_t,
		rr2 => rr2_t,
		writeEnable => writeEnable_t,
		wr => wr_t,
		wd => wd_t,
		clk => clk
	);

test_registers: process
begin
-- write to 2 registers
	REPORT "Testing Register.vhd to write to two registers";
	
	wr_t	<= "01011";	--register 11
	wd_t	<= "10001000100010001000100010001000";
	writeEnable_t	<= '1';

	wait for 20 ns;

	wr_t	<= "11010";	--register 26
	wd_t	<= "11111111111000001110111011101110";
	writeEnable_t	<= '1';

	wait for 20 ns;

--read registers and check they are correct

	rr1_t	<= "01011"; --reg 11
	rr2_t	<= "01010"; --reg 10

	wait for 20 ns;

	REPORT "Testing Register.vhd to read two registers";

	ASSERT (rd1_t = "10001000100010001000100010001000")	REPORT "Error in reg 11"	SEVERITY ERROR;
	ASSERT (rd2_t = "11111111111000001110111011101110")	REPORT "Error in reg 10"	SEVERITY ERROR;

	wait for 20 ns;

WAIT;

end process test_registers;
end test;