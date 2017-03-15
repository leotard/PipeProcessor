library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_processor is
port (
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
	new_pc : out std_logic_vector(31 downto 0);

	branch_in, memRead_in, memToReg_in, memWrite_in, regWrite_in: in std_logic;
	branch_out, memRead_out, memToReg_out, memWrite_out, regWrite_out: out std_logic
);

end pipeline_processor;


architecture arch of pipeline_processor is



COMPONENT EXECUTION is
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




signal EX_MEM_REG_PC, new_pc_shifted : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_ALU_zero, zero_out_new : std_logic := '0';
signal EX_MEM_REG_ALU_result, alu_output_new : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_dest_reg, selected_dest_new : std_logic_vector(4 downto 0) := "00000";
signal branch, memRead, memToReg, memWrite, regWrite : std_logic := '0';

begin

EXEC : EXECUTION port map (clock, read_data1, read_data2, pc, alu_op, alu_src, funct, imm, dest_reg1, dest_reg2, dest_reg_sel, selected_dest_new, zero_out_new, alu_output_new, new_pc_shifted);

process(clock)

begin
if(rising_edge(clock)) then

	--Output old values
	new_pc <= EX_MEM_REG_PC;
	zero_out <= EX_MEM_REG_ALU_zero;
	alu_output <= EX_MEM_REG_ALU_result;
	selected_dest <= EX_MEM_REG_dest_reg;

	branch_out <= branch;
	memRead_out <= memRead;
	memToReg_out <= memToReg;
	memWrite_out <= memWrite;
	regWrite_out <= regWrite;
elsif(falling_edge(clock)) then
	--Put new values in register
	EX_MEM_REG_PC  <= new_pc_shifted;
	EX_MEM_REG_ALU_zero <= zero_out_new;
	EX_MEM_REG_ALU_result <= alu_output_new;
	EX_MEM_REG_dest_reg <= selected_dest_new;

	branch <= branch_in;
	memRead <= memRead_in;
	memToReg <= memToReg_in;
	memWrite <= memWrite_in;
	regWrite <= regWrite_in;
end if;

end process;

end arch;

