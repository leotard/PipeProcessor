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
	
	signal control_t:std_logic:='0';
	signal MUX_PC : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	signal PC, new_PC, temp_PC, REG_PC, mux_in, new_IR, REG_IR, branch_PC, PC_FOUR: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	
	
BEGIN 

ADDER : PC_adder port map(new_PC, mux_in);
MUX   : MUXTWO port map(control_t,branch_PC,PC_FOUR,new_PC);
INSTR : instructionMem port map(new_PC, new_IR);

	process(clock)
	begin


		if(rising_edge(clock)) then
			if(branch_stall="00")then
				control_t <= control;
				branch_PC <= EX_stage;
				PC_FOUR <= REG_PC;

				IR <= REG_IR;
				PC_OUT <= REG_PC;
			elsif(branch_stall="11" or branch_stall="10")then
				IR <= "00000000000000000000000000100000";
			end if;
				
		elsif(falling_edge(clock)) then
			REG_IR <= new_IR;
			REG_PC <= mux_in;
			
		end if;



	--	if(rising_edge(clock)) then
			--mux_in;
		--	IR <= REG_IR;
	--		--PC<=REG_PC;
		--	PC_out <= temp_PC;
		--	MUX_PC <= mux_in;
		--elsif(falling_edge(clock)) then 
		--	MUX_PC <= mux_in;
		--	temp_PC <= mux_in;
			--REG_IR <= new_IR;
		--	if(control= '1') then 
		--		EX_t <= '1';
			--	REG_PC <= temp_PC;
		--	else
		--		EX_t <= '0';
		--		REG_PC <= new_PC;
			--end if;
			
			--if(EX_t= '1') then 
		--		REG_PC <= temp_PC;
		--	else
			--	REG_PC <= new_PC;
			--end if;
			
		--end if;
	end process;

	

	--PC_out <= PC;
	
end behav;
	
	




