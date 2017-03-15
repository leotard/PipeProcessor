
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execution_tb is
end execution_tb;

architecture behavior of execution_tb is

component pipeline_processor is
port(
	clock : in std_logic;
	read_data1 : in std_logic_vector(31 downto 0);
	read_data2 : in std_logic_vector(31 downto 0);
	pc : in std_logic_vector(31 downto 0);
	alu_op : in std_logic_vector(4 downto 0);
	alu_src : in std_logic;
	funct : in std_logic_vector(5 downto 0);
	imm : in std_logic_vector(31 downto 0);
	dest_reg1 : in std_logic_vector(4 downto 0);
	dest_reg2 : in std_logic_vector(4 downto 0);
	dest_reg_sel : in std_logic;
	selected_dest : out std_logic_vector(4 downto 0);
	zero_out : out std_logic;
	alu_output : out std_logic_vector(31 downto 0);
	new_pc : out std_logic_vector(31 downto 0)
);
end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;


signal read_data1 : std_logic_vector(31 downto 0);
signal read_data2 : std_logic_vector(31 downto 0);
signal pc : std_logic_vector(31 downto 0);
signal alu_op : std_logic_vector(4 downto 0);
signal alu_src : std_logic;
signal funct : std_logic_vector(5 downto 0);
signal imm : std_logic_vector(31 downto 0);
signal dest_reg1 : std_logic_vector(4 downto 0);
signal dest_reg2 : std_logic_vector(4 downto 0);
signal dest_reg_sel : std_logic;
signal selected_dest : std_logic_vector(4 downto 0);
signal zero_out : std_logic;
signal alu_output : std_logic_vector(31 downto 0);
signal new_pc : std_logic_vector(31 downto 0);



begin

-- Connect the components which we instantiated above to their
-- respective signals.
dut: pipeline_processor 
port map(
	clock => clk,
	read_data1 => read_data1,
	read_data2 => read_data2,
	pc => pc,
	alu_op => alu_op,
	alu_src => alu_src,
	funct => funct,
	imm => imm,
	dest_reg1 => dest_reg1,
	dest_reg2 => dest_reg2,
	dest_reg_sel => dest_reg_sel,
	selected_dest => selected_dest,
	zero_out => zero_out,
	alu_output => alu_output,
	new_pc => new_pc
);


				

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;



test_process : process

begin
	--add
	wait for clk_period/2;
	read_data1 <= "00000000000000000000000000000001";
	read_data2 <= "00000000000000000000000000000000";
	pc <= "00000000000000000000000000000000";
	alu_op <= "00000";
	alu_src <= '0';
	funct <= "100000";
	imm <= "00000000000000000000000000000000";
	dest_reg1 <= "00000";
	dest_reg2 <= "00000";
	dest_reg_sel <= '0';


	wait for 1*clk_period;
	
	--mult
	read_data1 <= "00000000000000000000000000000010";
	read_data2 <= "00000000000000000000000000000010";
	pc <= "00000000000000000000000000000000";
	alu_op <= "00010";
	alu_src <= '0';
	funct <= "000000";
	imm <= "00000000000000000000000000000000";
	dest_reg1 <= "00000";
	dest_reg2 <= "00000";
	dest_reg_sel <= '0';

	wait for 1*clk_period;

	--div
	read_data1 <= "00000000000000000000000000000010";
	read_data2 <= "00000000000000000000000000000001";
	pc <= "00000000000000000000000000000000";
	alu_op <= "00010";
	alu_src <= '0';
	funct <= "000000";
	imm <= "00000000000000000000000000000000";
	dest_reg1 <= "00000";
	dest_reg2 <= "00000";
	dest_reg_sel <= '0';

	wait for 1*clk_period;

	--sub and check shifted counter

	read_data1 <= "00000000000000000000000000000100";
	read_data2 <= "00000000000000000000000000000010";
	pc <= "00000000000000000000000000000001";
	alu_op <= "00001";
	alu_src <= '0';
	funct <= "000000";
	imm <= "00000000000000000000000000000001";
	dest_reg1 <= "00000";
	dest_reg2 <= "00000";
	dest_reg_sel <= '0';

	wait for 1*clk_period;

	--beq

	read_data1 <= "00000000000000000000000000000100";
	read_data2 <= "00000000000000000000000000000100";
	pc <= "00000000000000000000000000000000";
	alu_op <= "01011";
	alu_src <= '0';
	funct <= "000000";
	imm <= "00000000000000000000000000001000";
	dest_reg1 <= "00000";
	dest_reg2 <= "00000";
	dest_reg_sel <= '0';


	wait for 4*clk_period;
	
wait;
end process;
	
--reset <= wait_signal_1;

end;