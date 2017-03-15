library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTION is
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

end EXECUTION;

architecture arch of EXECUTION is

COMPONENT PC_adder_shifter is
	port(
		address : in std_logic_vector(31 downto 0);
		pc : in std_logic_vector(31 downto 0);
		new_pc : out std_logic_vector(31 downto 0)
	);
end component;


COMPONENT ALU is
	port(
		A : in std_logic_vector (31 downto 0);
		B : in std_logic_vector (31 downto 0);
		imm : in std_logic_vector (31 downto 0);
		control : in std_logic_vector (4 downto 0);
		ALU_MUX : in std_logic;
		output : out std_logic_vector (31 downto 0);
		zero : out std_logic
	);
end component;

COMPONENT DEST_MUX is
	port(
		control : in std_logic;
		A : in std_logic_vector(4 downto 0);
		B : in std_logic_vector(4 downto 0);
		output : out std_logic_vector(4 downto 0)
	);
end component;

signal dest_reg_selected : std_logic_vector(4 downto 0);
signal dest_reg1_new : std_logic_vector(4 downto 0);
signal dest_reg2_new : std_logic_vector(4 downto 0);
signal dest_reg_sel_new : std_logic;

signal ALU_input_2: std_logic_vector(31 downto 0);
signal read_data2_new: std_logic_vector(31 downto 0);
signal imm_new: std_logic_vector(31 downto 0);


begin

REG_DEST: DEST_MUX port map (dest_reg_sel, dest_reg1, dest_reg2, selected_dest);

ALU_COMP : ALU port map(read_data1, read_data2, imm, alu_op, alu_src, alu_output, zero_out);

PC_ADDER_SHIFTER_COMP : PC_ADDER_SHIFTER port map(imm, pc, new_pc);


end arch;