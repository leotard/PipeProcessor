LIBRARY ieee;
USE ieee.std_logic_1164.all;
use STD.textio.all; 
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;


ENTITY instructionFetch IS
	port(
		clock: in std_logic;
		control : in std_logic;
		EX_stage: in std_logic_vector(31 downto 0);
		--PC: in std_logic_vector(31 downto 0);
		PC_out: out std_logic_vector(31 downto 0);
		IR: out std_logic_vector(31 downto 0)
	);
end instructionFetch;

ARCHITECTURE behav OF instructionFetch IS

	component instructionMem is 
		port(
			PC: in std_logic_vector(31 downto 0);
			instr_reg: out std_logic_vector(31 downto 0)
		);
	end component;

	component PC_adder is
		port(
			PC: in std_logic_vector(31 downto 0);
			adder_out: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component MUXTWO is
		port(
			control : in std_logic;
			A : in std_logic_vector(31 downto 0);	
			B : in std_logic_vector(31 downto 0);
			output : out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal PC, new_PC, REG_PC, mux_in, new_IR, REG_IR: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	
	
BEGIN 

ADDER : PC_adder port map(PC, mux_in);
MUX   : MUXTWO port map(control,EX_stage,mux_in,new_PC);
INSTR : instructionMem port map(PC, new_IR);

	process(clock)
	begin
		if(rising_edge(clock)) then
			IR <= REG_IR;
			PC<=REG_PC;
		elsif(falling_edge(clock)) then 
			REG_IR <= new_IR;
			REG_PC <= new_PC;
		end if;
	end process;
	
	PC_out <= PC;

end behav;
	
	




