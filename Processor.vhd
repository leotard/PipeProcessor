library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
port (
	clock : in std_logic;
	--PC : in std_logic_vector(31 downto 0);
	--new_pc : in std_logic_vector(31 downto 0)
	instruction_out1 : in std_logic_vector(31 downto 0);
	wr_in1 : in std_logic_vector(4 downto 0);
	wd_in1 : in std_logic_vector(31 downto 0);
	regWrite_in1 : in std_logic;
	alu_output : out std_logic_vector(31 downto 0)
);

end entity;
architecture arch of processor is 

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
		shamt : in std_logic_vector(4 downto 0);
		dest_reg1 : in std_logic_vector(4 downto 0);
		dest_reg2 : in std_logic_vector(4 downto 0);
		dest_reg_sel : in std_logic;
		selected_dest : out std_logic_vector(4 downto 0);
		zero_out : out std_logic;
		alu_output : out std_logic_vector(31 downto 0);
		new_pc : out std_logic_vector(31 downto 0)
	);
end component;

COMPONENT Instruction_Decode is

port(
	clock : in std_logic;

	instruction : in std_logic_vector(31 downto 0);
    	wr_in : in std_logic_vector(4 downto 0);
	wd_in : in std_logic_vector(31 downto 0);
	regWrite_in : in std_logic;
	
	read_data1 : out std_logic_vector(31 downto 0);
	read_data2 : out std_logic_vector(31 downto 0);
	pc : out std_logic_vector(31 downto 0);
	alu_op : out std_logic_vector(4 downto 0);
	alu_src : out std_logic;
	funct : out std_logic_vector(5 downto 0);
	imm : out std_logic_vector(31 downto 0);
	shamt : out std_logic_vector(4 downto 0);
	dest_reg1 : out std_logic_vector(4 downto 0);
	dest_reg2 : out std_logic_vector(4 downto 0);
	dest_reg_sel : out std_logic;
	branch_out, memRead_out, memToReg_out, memWrite_out, reg_write_out: out std_logic;

	BNE_out : out std_logic;
	Jump_out : out std_logic;
	LUI_out : out std_logic;
	jr_out : out std_logic;
	sign_extend_out : out std_logic_vector(31 downto 0)
);

end component;

--IF/ID registers

signal IF_REG_instruction, IF_REG_PC, pc_incremented, instruction_out, PC_out_IF, instruction_in : std_logic_vector(31 downto 0);

--ID/EX registers

signal read_data1_ID_EX, read_data2_ID_EX, read_data1_new, read_data2_new, read_data1_new_out, read_data2_new_out, pc_new_ID_EX, pc_new_ID, pc_new_ID_out, imm_new_ID_EX, imm_new, imm_new_out : std_logic_vector(31 downto 0);
signal alu_src_new_ID_EX, alu_src_new, alu_src_new_out, dest_reg_sel_new_ID_EX, dest_reg_sel_new, branch_out_new_ID_EX, branch_out_new,
memRead_out_new_ID_EX, memRead_out_new, memToReg_out_new_ID_EX, memToReg_out_new, memWrite_out_new_ID_EX, memWrite_out_new,
reg_write_out_new_ID_EX, reg_write_out_new : std_logic;
signal shamt_new, shamt_new_out, shamt_new_ID_EX, alu_op_new, alu_op_new_out, alu_op_new_ID_EX, dest_reg1_new, dest_reg1_new_out, dest_reg2_new, dest_reg2_new_out, dest_reg1_new_ID_EX, dest_reg2_new_ID_EX: std_logic_vector(4 downto 0);
signal funct_new, funct_new_out, funct_new_ID_EX: std_logic_vector(5 downto 0);


--EX/MEM registers

signal EX_MEM_REG_PC, new_pc_shifted : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_ALU_zero, zero_out_new : std_logic := '0';
signal EX_MEM_REG_ALU_result, alu_output_new : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_dest_reg, selected_dest_new : std_logic_vector(4 downto 0) := "00000";
signal branch_EX_MEM, memRead_EX_MEM, memToReg_EX_MEM, memWrite_EX_MEM, regWrite_EX_MEM : std_logic := '0';

--MEM

signal pc_new_EX_MEM  : std_logic_vector(31 downto 0);


--WB

signal wr_in, wr : std_logic_vector(4 downto 0);
signal wd_in, wd : std_logic_vector(31 downto 0);
signal regWrite_in : std_logic;


begin




EXEC : EXECUTION port map (clock, read_data1_new_out, read_data2_new_out, pc_new_ID_out, alu_op_new_out, alu_src_new_out, funct_new_out, imm_new_out, shamt_new_out, dest_reg1_new_out, dest_reg2_new_out, dest_reg_sel_new, selected_dest_new, zero_out_new, alu_output_new, new_pc_shifted);
ID : Instruction_Decode port map(clock, instruction_out1, wr_in1, wd_in1, regWrite_in1, read_data1_new, read_data2_new, pc_new_ID, alu_op_new, alu_src_new, funct_new, imm_new, shamt_new, dest_reg1_new, dest_reg2_new, dest_reg_sel_new, branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, reg_write_out_new);



process(clock)

begin
if(rising_edge(clock)) then

	--Output old values
	
	--IF/ID
	instruction_out <= IF_REG_instruction;
	PC_out_IF <= IF_REG_PC;

	--ID/EX
	
	read_data1_new_out <= read_data1_ID_EX;
	read_data2_new_out <= read_data2_ID_EX;
	pc_new_ID_out <= pc_new_ID_EX;
	alu_op_new_out <= alu_op_new_ID_EX;
	alu_src_new_out <= alu_src_new_ID_EX ;
	funct_new_out <= funct_new_ID_EX;
	imm_new_out <= imm_new_ID_EX;
	shamt_new_out <= shamt_new_ID_EX;
	dest_reg1_new_out <= dest_reg1_new_ID_EX;
	dest_reg2_new_out <= dest_reg2_new_ID_EX;
	dest_reg_sel_new_out <= dest_reg_sel_new_ID_EX;
	branch_out_new_out <= branch_out_new_ID_EX;
	memRead_out_new_out <= memRead_out_new_ID_EX;
	memToReg_out_new_out  <= memToReg_out_new_ID_EX;
	memWrite_out_new_out <= memWrite_out_new_ID_EX;
	reg_write_out_new_out <= reg_write_out_new_ID_EX;

	--EX
	new_pc_shifted_out <= EX_MEM_REG_PC;
	zero_out_new_out <= EX_MEM_REG_ALU_zero;
	alu_output_new_out <= EX_MEM_REG_ALU_result;
	selected_dest_new_out <= EX_MEM_REG_dest_reg;
	alu_output_out <= EX_MEM_REG_ALU_result;

	branch_out_new_out <= branch_EX_MEM;
	memRead_out_new_out <= memRead_EX_MEM;
	memToReg_out_new_out <= memToReg_EX_MEM;
	memWrite_out_new_out <= memWrite_EX_MEM;
	reg_write_out_new_out <= regWrite_EX_MEM;
	
elsif(falling_edge(clock)) then

	--Put new values in registers

	--IF/ID
	IF_REG_instruction <= instruction_in;
	IF_REG_PC <= PC_incremented;

	--ID/EX
	
	read_data1_ID_EX <= read_data1_new;
	read_data2_ID_EX <= read_data2_new;
	pc_new_ID_EX <= pc_out_IF;
	alu_op_new_ID_EX <= alu_op_new;
	alu_src_new_ID_EX <= alu_src_new;
	funct_new_ID_EX <= funct_new;
	imm_new_ID_EX <= imm_new;
	shamt_new_ID_EX <= shamt_new;
	dest_reg1_new_ID_EX <= dest_reg1_new;
	dest_reg2_new_ID_EX <= dest_reg2_new;
	dest_reg_sel_new_ID_EX <= dest_reg_sel_new;
	branch_out_new_ID_EX <= branch_out_new;
	memRead_out_new_ID_EX <= memRead_out_new;
	memToReg_out_new_ID_EX <= memToReg_out_new;
	memWrite_out_new_ID_EX <= memWrite_out_new;
	reg_write_out_new_ID_EX <= reg_write_out_new;

	--EX


	EX_MEM_REG_PC  <= new_pc_shifted;
	EX_MEM_REG_ALU_zero <= zero_out_new;
	EX_MEM_REG_ALU_result <= alu_output_new;
	EX_MEM_REG_dest_reg <= selected_dest_new;

	branch_EX_MEM <= branch_out_new;
	memRead_EX_MEM <= memRead_out_new;
	memToReg_EX_MEM <= memToReg_out_new;
	memWrite_EX_MEM <= memWrite_out_new;
	regWrite_EX_MEM <= reg_Write_out_new;
end if;

end process;





end arch;
