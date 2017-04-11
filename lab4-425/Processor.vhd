library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;


entity processor is
port (
	clock : in std_logic;
	--PC : in std_logic_vector(31 downto 0);
	--new_pc : in std_logic_vector(31 downto 0)
	register_array : out registers(0 to 33);
	memory_array : out registers(0 to 32767)
);

end entity;
architecture arch of processor is 

COMPONENT EXECUTION is
	port(
	clock : in std_logic;
	ALU_ready : in std_logic;
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
	read_data2_out: out std_logic_vector(31 downto 0);
	
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
	jr_out : out std_logic;
	branch_stall: out std_logic_vector(1 downto 0);
	output_ready : out std_logic;
	register_array : out registers(0 to 33);
	adder_NEW : out std_logic_vector(31 downto 0);
	branch_out_s : out std_logic_vector(1 downto 0);
	branch_pred : in std_logic;
	branch_actual : in std_logic
);

end component;

COMPONENT instructionFetch is
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
	
end component;

COMPONENT MUXTWO is
  port(
	 control : in std_logic;
	 A : in std_logic_vector(31 downto 0);
	 B : in std_logic_vector(31 downto 0);
	 output : out std_logic_vector(31 downto 0)
  );
end component;

component directionPredictor is
	Port(
		clock: in std_logic;
		op_code : in std_logic_vector(5 downto 0);
		branch : in std_logic;
		branch_actual : in std_logic;
		branch_pred : out std_logic;
		pred_s : out std_logic_vector(1 downto 0)
		);
end component;


COMPONENT mem_stage is
  port( 
	clock                  : in std_logic;
	addr                   : in std_logic_vector(31 downto 0);
	addr_out               : out std_logic_vector(31 downto 0);
	write_data             : in std_logic_vector(31 downto 0);
	mem_r                  : in std_logic;
	mem_w                  : in std_logic;
	mem_toReg              : in std_logic;
	zero                   : in std_logic;
	branch                 : in std_logic;
	mux_instrStage_control : out std_logic;
	mem_toReg_out          : out std_logic;
	selected_dest_mem      : in std_logic_vector(4 downto 0);
	selected_dest_mem_out  : out std_logic_vector(4 downto 0);	
	regWrite_mem           : in std_logic;
	regWrite_mem_out       : out std_logic;
	read_data              : out std_logic_vector(31 downto 0);
	memory_array : out registers(0 to 32767)
);

end component;

component WRITEBACK is
port(
	clock : in std_logic;
	write_reg_MEM : in std_logic_vector(4 downto 0);
	control : in std_logic;
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0);
	write_reg_MEM_OUT : out std_logic_vector(4 downto 0)
);

end component;


--IF/ID registers

signal IF_instruction, IF_REG_PC, pc_incremented, instruction_out, PC_out_IF, instruction_in : std_logic_vector(31 downto 0);
signal pc_IF_new : std_logic_vector(31 downto 0); 
signal mux_instrStage_control_new: std_logic;
signal branch_stall_t:std_logic_vector(1 downto 0);

--Branch Prediction
signal adder_ID_out:std_logic_vector(31 downto 0);
signal MUX_branch:std_logic_vector(1 downto 0) := "01";
signal pred_s_t: std_logic_vector(1 downto 0) := "00";
signal branch_pred_t: std_logic := '0';

--ID/EX registers

signal read_data1_ID_EX, read_data2_ID_EX, read_data1_new, read_data2_new, read_data1_new_out, read_data2_new_out, pc_new_ID_EX, pc_new_ID, pc_new_ID_out, imm_new_ID_EX, imm_new, imm_new_out : std_logic_vector(31 downto 0);
signal alu_src_new_ID_EX, alu_src_new, alu_src_new_out, dest_reg_sel_new_ID_EX, dest_reg_sel_new, dest_selector, branch_out_new_ID_EX, branch_out_new,
memRead_out_new_ID_EX, memRead_out_new, memToReg_out_new_ID_EX, memToReg_out_new, memWrite_out_new_ID_EX, memWrite_out_new,
reg_write_out_new_ID_EX, reg_write_out_new : std_logic;
signal shamt_new, shamt_new_out, shamt_new_ID_EX, alu_op_new, alu_op_new_out, alu_op_new_ID_EX, dest_reg1_new, dest_reg1_new_out, dest_reg2_new, dest_reg2_new_out, dest_reg1_new_ID_EX, dest_reg2_new_ID_EX: std_logic_vector(4 downto 0);
signal funct_new, funct_new_out, funct_new_ID_EX: std_logic_vector(5 downto 0);
signal BNE_out_new, jump_out_new, LUI_out_new, jr_out_new : std_logic;
signal ALU_ready : std_logic;


--EX/MEM registers
signal branch_out_EX, memRead_out_EX, memToReg_out_EX, memWrite_out_EX,
reg_write_out_EX, BNE_out_EX, jump_out_EX, LUI_out_EX, jr_out_EX : std_logic;
signal EX_MEM_REG_PC, new_pc_shifted : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_ALU_zero, zero_out_new : std_logic := '0';
signal read_data2_EX : std_logic_vector(31 downto 0);
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

signal write_reg_MEM : std_logic_vector(4 downto 0);


begin



branchPredict : directionPredictor port map(clock, funct_new, branch_out_new, branch_out_EX, branch_pred_t, pred_s_t);

EXEC : EXECUTION port map (clock, ALU_ready, read_data1_new, read_data2_new, pc_new_ID, alu_op_new, alu_src_new,
 funct_new, imm_new, shamt_new, dest_reg1_new, dest_reg2_new, dest_selector, selected_dest_new, zero_out_new,
 alu_output_new, new_pc_shifted,read_data2_EX, branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, reg_write_out_new,
 BNE_out_new, jump_out_new, LUI_out_new, jr_out_new, branch_out_EX, memRead_out_EX, memToReg_out_EX, memWrite_out_EX,
reg_write_out_EX, BNE_out_EX, jump_out_EX, LUI_out_EX, jr_out_EX);

ID : Instruction_Decode port map(clock, IF_instruction, write_reg_WB, write_data_WB, regWrite_in, pc_IF_new, read_data1_new, read_data2_new, pc_new_ID, 
alu_op_new, alu_src_new, funct_new, imm_new, shamt_new, dest_reg1_new, dest_reg2_new, dest_selector, 
branch_out_new, memRead_out_new, memToReg_out_new, memWrite_out_new, reg_write_out_new,
BNE_out_new, jump_out_new, LUI_out_new, jr_out_new,branch_stall_t, ALU_ready, register_array, adder_ID_out, MUX_branch, branch_pred_t, branch_out_EX);

Fetch : instructionFetch port map (clock, mux_instrStage_control_new, new_pc_shifted, MUX_branch, adder_ID_out, pc_IF_new, IF_instruction);

MEM : mem_stage port map(clock, alu_output_new, ALU_output_MEM, read_data2_EX, memRead_out_EX, memWrite_out_EX,
 memToReg_out_EX, zero_out_new,
branch_out_EX, mux_instrStage_control_new, memToReg_MEM, selected_dest_new, write_reg_MEM, reg_write_out_EX, regWrite_in, read_data_MEM, memory_array);
  
--WB_stage : MUXTWO port map (memToReg_MEM, read_data_MEM, ALU_output_MEM, write_data_WB);
WB_stage : writeBack port map(clock, write_reg_MEM, memToReg_MEM, read_data_MEM, ALU_output_MEM, write_data_WB, write_reg_WB);

--MEM_stage : port map (





end arch;
