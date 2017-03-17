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
<<<<<<< HEAD
		alu_lh_w : in std_logic;
=======
		--alu_lh_w : in std_logic;
>>>>>>> origin/master

		--alu_lo_in : in std_logic_vector(31 downto 0);
		--alu_hi_in : in std_logic_vector(31 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0)
		--alu_hi_out : out std_logic_vector(31 downto 0);
		--alu_lo_out : out std_logic_vector(31 downto 0);

		--clk : in std_logic
	);
end component registers_lib;

