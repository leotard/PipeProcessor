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
		MUX_branch: in std_logic_vector(1 downto 0);
		adder_ID: in std_logic_vector(31 downto 0);
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
	
	component MUXASYNC is
		port(
			control : in std_logic_vector(1 downto 0);
			A : in std_logic_vector(31 downto 0);	
			B : in std_logic_vector(31 downto 0);
			C : in std_logic_vector(31 downto 0);
			D : in std_logic_vector(31 downto 0);
			output : out std_logic_vector(31 downto 0)
		);
	end component;
	

	signal control_t:std_logic:='0'; 
	signal MUX_PC : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	signal PC, new_PC, temp_PC, REG_PC, mux_in, new_IR, REG_IR, branch_PC, PC_FOUR: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	signal past_stall : std_logic_vector(1 downto 0):="00";
	signal D : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
	
BEGIN 

ADDER : PC_adder port map(new_PC, mux_in);
MUX   : MUXASYNC port map(MUX_branch,EX_STAGE,PC_FOUR,adder_ID, D, new_PC);
INSTR : instructionMem port map(new_PC, new_IR);

	process(clock)
	begin


		if(rising_edge(clock)) then
			PC_FOUR <= REG_PC;
			--control_t <= control;
			--branch_PC <= EX_stage;
			
			--add stall in IF
	
			--if((REG_IR(31 downto 26) = "000100" OR REG_IR(31 downto 26) = "000101") and past_stall = "00")then
				--past_stall <= "11";
				--IR <= REG_IR;
			--elsif(past_stall= "11") then
				--past_stall <= "10";
				--IR <= (OTHERs => '0');
			--elsif(past_stall= "10") then
				--past_stall <= "00";
				--IR <= (OTHERs => '0');
			--else
			IR <= REG_IR;
			--end if; 
			PC_OUT <= REG_PC;
		elsif(falling_edge(clock)) then
			REG_IR <= new_IR;
			REG_PC <= mux_in;
			
			--PC_OUT <= mux_in;
			
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
	
	




