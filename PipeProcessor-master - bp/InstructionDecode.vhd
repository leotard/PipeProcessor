library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg.all;

entity instruction_decode is
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
	--branch_stall: out std_logic_vector(1 downto 0);
	output_ready : out std_logic; 
	register_array : out registers(0 to 33);
	adder_NEW : out std_logic_vector(31 downto 0);
	
	--branch predict
	branch_out_s : out std_logic_vector(1 downto 0);
	branch_pred : in std_logic;
	branch_actual : in std_logic
	
);

end entity;

architecture arch of instruction_decode is


component IF_ID is
port(
	clock : in std_logic;

	--signals in
	instruction_in : in std_logic_vector(31 downto 0);
	address_in : in std_logic_vector(31 downto 0);
	--hazard detection
	IF_ID_forward : in std_logic :='1';
	--signals out
	instruction_out : out std_logic_vector(31 downto 0);
	address_out : out std_logic_vector(31 downto 0)

);
end component;

component ID_EX IS
	PORT (
		clk					: in std_logic;

		--Data inputs
		Addr_in				: in std_logic_vector(31 downto 0);
		RegData0_in			: in std_logic_vector(31 downto 0);
		RegData1_in			: in std_logic_vector(31 downto 0);
		SignExtended_in		: in std_logic_vector(31 downto 0);

		--Register inputs (5 bits each)
		Rs_in				: in std_logic_vector(4 downto 0);
		Rt_in				: in std_logic_vector(4 downto 0);
		Rd_in				: in std_logic_vector(4 downto 0);

		--Control inputs (8 of them?)
		RegWrite_in			: in std_logic;
		MemToReg_in			: in std_logic;
		MemWrite_in			: in std_logic;
		MemRead_in			: in std_logic;
		Branch_in			: in std_logic;
		LUI_in				: in std_logic;
		ALU_op_in			: in std_logic_vector(3 downto 0);
		ALU_src_in			: in std_logic;
		Reg_dest_in			: in std_logic;


		--Data Outputs
		Addr_out			: out std_logic_vector(31 downto 0);
		RegData0_out		: out std_logic_vector(31 downto 0);
		RegData1_out		: out std_logic_vector(31 downto 0);
		SignExtended_out	: out std_logic_vector(31 downto 0);

		--Register outputs
		Rs_out				: out std_logic_vector(4 downto 0);
		Rt_out				: out std_logic_vector(4 downto 0);
		Rd_out				: out std_logic_vector(4 downto 0);

		--Control outputs
		RegWrite_out		: out std_logic;
		MemToReg_out		: out std_logic;
		MemWrite_out		: out std_logic;
		MemRead_out			: out std_logic;
		Branch_out			: out std_logic;
		LUI_out				: out std_logic;
		ALU_op_out			: out std_logic_vector(3 downto 0);
		ALU_src_out			: out std_logic;
		Reg_dest_out		: out std_logic
	);
END component;


component Control is
	port(
		--input op code
		op_code : in std_logic_vector (5 downto 0);
		instruction	: in std_logic_vector(5 downto 0);

		--EX control
		reg_dst : out std_logic;
		bne : out std_logic;
		jump : out std_logic;
		jr : out std_logic;
		branch : out std_logic;
		LUI : out std_logic;
		--alu_lh_w : out std_logic;
		--set 00 to return, 01 to low, 10 to high
		--alu_lh_r : out std_logic_vector(1 downto 0);

		--ALU control
		alu_op : out std_logic_vector(4 downto 0);
		alu_src : out std_logic;

		--memory operations
		mem_r : out std_logic;
		mem_w : out std_logic;

		--ID stage
		reg_w : out std_logic;

		--WB stage
		mem_reg : out std_logic;

		--branch predictor
		clock : in std_logic;
		branch_pred : in std_logic;
		branch_actual : in std_logic;
		branch_out_s : out std_logic_vector(1 downto 0)

		);
end component;


component pc_adder_shifter is
port(
	clock : in std_logic;
	address : in std_logic_vector(31 downto 0);
	pc : in std_logic_vector(31 downto 0);
	new_pc : out std_logic_vector(31 downto 0)
);
end component;

component PC_adder_ID IS 
port(
	PC: in std_logic_vector(31 downto 0);
	immediate : in std_logic_vector(31 downto 0);
	adder_out: out std_logic_vector(31 downto 0)
);
end component;

component sign_extender is

port(
	input : in std_logic_vector(15 downto 0);
	sign_extend : out std_logic_vector(31 downto 0)
);

end component;

component registers_lib is
	port (
		clock : in std_logic;
		rd1 : out std_logic_vector(31 downto 0);
		rd2 : out std_logic_vector(31 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rr2 : in std_logic_vector(4 downto 0);
		--alu_lh_w : in std_logic;

		--alu_lo_in : in std_logic_vector(31 downto 0);
		--alu_hi_in : in std_logic_vector(31 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		register_array : out registers(0 to 33);
		wd : in std_logic_vector(31 downto 0)
		--alu_hi_out : out std_logic_vector(31 downto 0);
		--alu_lo_out : out std_logic_vector(31 downto 0);
		--clock : in std_logic
	);
end component;

signal shamt_new_ID_EX, shamt_new : std_logic_vector(4 downto 0);
signal read_data1_ID_EX, read_data1_new : std_logic_vector(31 downto 0);
signal read_data2_ID_EX, read_data2_new : std_logic_vector(31 downto 0);
signal funct_new, funct_new_ID_EX : std_logic_vector(5 downto 0);

signal alu_op_new_ID_EX, alu_op_new : std_logic_vector(4 downto 0);
signal alu_src_new_ID_EX, alu_src_new : std_logic;

signal imm_new_ID_EX, imm_new : std_logic_vector(31 downto 0);

signal dest_reg1_new_ID_EX, dest_reg2_new_ID_EX: std_logic_vector(4 downto 0);
signal dest_reg1_new, dest_reg2_new : std_logic_vector(4 downto 0);
signal dest_reg_sel_new_ID_EX ,dest_reg_sel_new : std_logic;
signal branch_out_new_ID_EX, branch_out_new : std_logic;
signal memRead_out_new_ID_EX, memRead_out_new : std_logic;
signal memToReg_out_new_ID_EX, memToReg_out_new : std_logic;
signal memWrite_out_new_ID_EX, memWrite_out_new : std_logic;
signal reg_write_out_new_ID_EX, reg_write_out_new : std_logic;
signal pc_new, pc_new_ID_EX : std_logic_vector(31 downto 0);
signal stall_ALU:std_logic_vector(4 downto 0);
signal stall_MEM:std_logic_vector(4 downto 0);
signal stall :std_logic_vector(4 downto 0);
signal adder_NEW_t : std_logic_vector(31 downto 0);

signal sign_extend_out_new, sign_extend_ID_EX : std_logic_vector(31 downto 0);

signal BNE_out_new, jump_out_new, jr_out_new, LUI_out_new : std_logic;
signal BNE_out_new_ID_EX, jump_out_new_ID_EX, jr_out_new_ID_EX, LUI_out_new_ID_EX : std_logic;

--signal register_array_ID, register_array_REG : registers(0 to 33):= ((others=> (others=>'0')));
signal past_stall: std_logic_vector(1 downto 0):="00";
signal flag : std_logic:='1';
begin

--signal new_regWrite, new_ALUSrc,  new_regDest, new_branch, new_BNE, new_jump, new_LUI, new_memWrite, new_memRead, new_memToReg : std_logic;
--signal new_ALUOpCode : std_logic_vector(3 downto 0);



control_unit : Control port map(instruction(31 downto 26), instruction(5 downto 0), dest_reg_sel_new, BNE_out_new, jump_out_new, jr_out_new, branch_out_new, LUI_out_new, alu_op_new, alu_src_new, memRead_out, memWrite_out_new, reg_write_out_new, memToReg_out_new, clock, branch_pred, branch_actual, branch_out_s);

reg : registers_lib port map(clock, read_data1_new, read_data2_new, instruction(25 downto 21), instruction(20 downto 16),
regWrite_in, wr_in, register_array, wd_in);

PC_ID : PC_adder_ID port map(pc_in, sign_extend_out_new, adder_NEW_t);

sign : sign_extender port map(instruction(15 downto 0), sign_extend_out_new);



shamt_new <= instruction(10 downto 6);

funct_new <= instruction(5 downto 0);

dest_reg1_new <= instruction(20 downto 16);
dest_reg2_new <= instruction(15 downto 11);

process(clock)

variable var_stall: std_logic_vector(4 downto 0);

  begin
  if(rising_edge(clock)) then

	output_ready <= '1';
	--write to register
	flag <= '0';

  BNE_out <= BNE_out_new_ID_EX;
  jump_out <= jump_out_new_ID_EX;
  jr_out <= jr_out_new_ID_EX;
lui_out <= lui_out_new_ID_EX;
if(instruction(31 downto 26) = "101011") then
  	read_data1 <= read_data1_ID_EX;
else
	read_data1 <= read_data1_new;
end if;
	read_data2 <= read_data2_new;
	pc <= pc_new_ID_EX;
	alu_op <= alu_op_new_ID_EX;

	stall_ALU <= instruction(25 downto 21);
	var_stall := stall_ALU;
	--stall_MEM<=var_stall;

	alu_src <= alu_src_new_ID_EX;
	funct <= funct_new_ID_EX;
	imm <= imm_new_ID_EX;
	shamt <= shamt_new_ID_EX;
	dest_reg1 <= dest_reg1_new_ID_EX;
	dest_reg2 <= dest_reg2_new_ID_EX;
	dest_reg_sel <= dest_reg_sel_new_ID_EX;
	branch_out <= branch_out_new_ID_EX;
		
	memRead_out <= memRead_out_new_ID_EX;
	memToReg_out  <= memToReg_out_new_ID_EX;
	memWrite_out <= memWrite_out_new_ID_EX;
	reg_write_out <= reg_write_out_new_ID_EX;
  shamt <= shamt_new_ID_EX;
  funct <= funct_new_ID_EX;
  
  imm <= sign_extend_ID_EX;



elsif(falling_edge(clock)) then
	output_ready <= '0';

	--put inputs in register for read
	flag <= '1';

  BNE_out_new_ID_EX <= BNE_out_new;
  jump_out_new_ID_EX <= jump_out_new;
  jr_out_new_ID_EX <= jr_out_new;
  lui_out_new_ID_EX <= lui_out_new;
  --pc_new_ID_EX <= pc_new;

	
	--if(instruction(25 downto 21) = )then 
		
	--end if;
	pc_new_ID_EX <= pc_in;
	alu_op_new_ID_EX <= alu_op_new;
	alu_src_new_ID_EX <= alu_src_new; 
	funct_new_ID_EX <= funct_new;
	imm_new_ID_EX <= imm_new;
	shamt_new_ID_EX <= shamt_new;
	dest_reg1_new_ID_EX <= dest_reg1_new;
	dest_reg2_new_ID_EX <= dest_reg2_new;
	--stall_MEM <= stall_ALU;
  dest_reg_sel_new_ID_EX <= dest_reg_sel_new;

	branch_out_new_ID_EX <= branch_out_new;
	memRead_out_new_ID_EX <= memRead_out_new;
	memToReg_out_new_ID_EX <= memToReg_out_new;
	memWrite_out_new_ID_EX <= memWrite_out_new;
	reg_write_out_new_ID_EX <= reg_write_out_new;
	funct_new_ID_EX <= funct_new;
	sign_extend_ID_EX <= sign_extend_out_new;
	adder_NEW <= adder_NEW_t;
	
	--register_array_REG(to_integer(unsigned(wr_in))) <= wd_in;
	--if sw need to put register address in read_data1
	if(instruction(31 downto 26) = "101011") then
		read_data1_ID_EX(4 downto 0) <= instruction(25 downto 21);
		read_data1_ID_EX(31 downto 5) <= "000000000000000000000000000";
		read_data2_ID_EX <= read_data2_new;
	else
		read_data2_ID_EX <= read_data2_new;
		read_data1_ID_EX <= read_data1_new;
	end if;

end if;
end process;

--stall_ALU <= varStall_ALU;
end arch;


