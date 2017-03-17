library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
port (
	clock : in std_logic
	--PC : in std_logic_vector(31 downto 0);
	--new_pc : in std_logic_vector(31 downto 0)
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
	selected_dest_out : out std_logic_vector(4 downto 0);
	zero_out : out std_logic;
	alu_output : out std_logic_vector(31 downto 0);
	new_pc_out : out std_logic_vector(31 downto 0);
	
	branch_in, memRead_in, memToReg_in, memWrite_in, reg_write_in: in std_logic;
	
	BNE_in, Jump_in, LUI_in, jr_in : in std_logic;
	
	branch_out, memRead_out, memToReg_out, memWrite_out, reg_write_out: out std_logic;
	
	BNE_out, Jump_out, LUI_out, jr_out : out std_logic
);
end component;

COMPONENT Instruction_Decode is

port(
	clock : in std_logic;

	instruction : in std_logic_vector(31 downto 0);
    	wr_in : in std_logic_vector(4 downto 0);
	wd_in : in std_logic_vector(31 downto 0);
	regWrite_in : in std_logic;
	pc_in : in std_logic_vector(31 downto 0);
	
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
	jr_out : out std_logic
);

end component;

COMPONENT instructionFetch is
  port(
		clock: in std_logic;
		control : in std_logic;
		EX_stage: in std_logic_vector(31 downto 0);
		--PC: in std_logic_vector(31 downto 0);
		PC_out: out std_logic_vector(31 downto 0);
		IR: out std_logic_vector(31 downto 0)
	);
	
end component;

COMPONENT MUXTWO is
  port(
	 control : in std_logic;
	 A : in std_logic_vector(31 downto 0);
	 B : in std_logic_vector(31 downto 0);
	 output : out std_logic_vector(31 downto 0)
  );
end component;


--IF/ID registers

signal IF_instruction, IF_REG_PC, pc_incremented, instruction_out, PC_out_IF, instruction_in : std_logic_vector(31 downto 0);
signal pc_IF_new : std_logic_vector(31 downto 0); 

--ID/EX registers

signal read_data1_ID_EX, read_data2_ID_EX, read_data1_new, read_data2_new, read_data1_new_out, read_data2_new_out, pc_new_ID_EX, pc_new_ID, pc_new_ID_out, imm_new_ID_EX, imm_new, imm_new_out : std_logic_vector(31 downto 0);
signal alu_src_new_ID_EX, alu_src_new, alu_src_new_out, dest_reg_sel_new_ID_EX, dest_reg_sel_new, dest_selector, branch_out_new_ID_EX, branch_out_new,
memRead_out_new_ID_EX, memRead_out_new, memToReg_out_new_ID_EX, memToReg_out_new, memWrite_out_new_ID_EX, memWrite_out_new,
reg_write_out_new_ID_EX, reg_write_out_new : std_logic;
signal shamt_new, shamt_new_out, shamt_new_ID_EX, alu_op_new, alu_op_new_out, alu_op_new_ID_EX, dest_reg1_new, dest_reg1_new_out, dest_reg2_new, dest_reg2_new_out, dest_reg1_new_ID_EX, dest_reg2_new_ID_EX: std_logic_vector(4 downto 0);
signal funct_new, funct_new_out, funct_new_ID_EX: std_logic_vector(5 downto 0);
signal BNE_out_new, jump_out_new, LUI_out_new, jr_out_new : std_logic;


--EX/MEM registers

signal EX_MEM_REG_PC, new_pc_shifted : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_ALU_zero, zero_out_new : std_logic := '0';
signal EX_MEM_REG_ALU_result, alu_output_new : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_dest_reg, selected_dest_new : std_logic_vector(4 downto 0) := "00000";
--signal branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, regWrite_out_new : std_logic := '0';

--MEM

signal branch_out_pc : std_logic;
signal pc_new_EX_MEM  : std_logic_vector(31 downto 0);
signal memToReg_MEM : std_logic;
signal read_data_MEM, ALU_output_MEM: std_logic_vector(31 downto 0);
--WB

signal write_reg_WB : std_logic_vector(4 downto 0);
signal write_data_WB : std_logic_vector(31 downto 0);

signal wr_in, wr : std_logic_vector(4 downto 0);
signal wd_in, wd : std_logic_vector(31 downto 0);
signal regWrite_in : std_logic;


begin



EXEC : EXECUTION port map (clock, read_data1_new, read_data2_new, pc_new_ID, alu_op_new, alu_src_new, funct_new, imm_new, shamt_new, dest_reg1_new, dest_reg2_new, dest_reg_sel_new, selected_dest_new, zero_out_new, alu_output_new, new_pc_shifted,
branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, reg_write_out_new, BNE_out_new, jump_out_new, LUI_out_new, jr_out_new);

ID : Instruction_Decode port map(clock, instruction_out, write_reg_WB, write_data_WB, regWrite_in, pc_IF_new, read_data1_new, read_data2_new, pc_new_ID, alu_op_new, alu_src_new, funct_new, imm_new, shamt_new, dest_reg1_new, dest_reg2_new, dest_selector, branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, reg_write_out_new,
BNE_out_new, jump_out_new, LUI_out_new, jr_out_new);

Fetch : instructionFetch port map (clock, branch_out_pc, pc_IF_new, IF_instruction);
  
WB_stage : MUXTWO port map (memToReg_MEM, read_data_MEM, ALU_output_MEM, write_data_WB);

--MEM_stage : port map (





end arch;
