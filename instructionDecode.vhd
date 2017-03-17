LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity instruction_decode is
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
		mem_reg : out std_logic

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

component sign_extender is

port(
	input : in std_logic_vector(15 downto 0);
	sign_extend : out std_logic_vector(31 downto 0)
);

end component;

component registers_lib is
	port (
		rd1 : out std_logic_vector(31 downto 0);
		rd2 : out std_logic_vector(31 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rr2 : in std_logic_vector(4 downto 0);
		--alu_lh_r : in std_logic;

		--alu_lo_in : in std_logic_vector(31 downto 0);
		--alu_hi_in : in std_logic_vector(31 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0)
		--alu_hi_out : out std_logic_vector(31 downto 0);
		--alu_lo_out : out std_logic_vector(31 downto 0);

		--clk : in std_logic
	);
end component;

begin

--signal new_regWrite, new_ALUSrc,  new_regDest, new_branch, new_BNE, new_jump, new_LUI, new_memWrite, new_memRead, new_memToReg : std_logic;
--signal new_ALUOpCode : std_logic_vector(3 downto 0);

control_unit : control port map(instruction(31 downto 26), instruction(5 downto 0), dest_reg_sel, BNE_out, jump_out, jr_out, branch_out, LUI_out, alu_op, alu_src, memRead_out, memWrite_out, reg_write_out, memToReg_out);

reg : registers_lib port map(read_data1, read_data2, instruction(25 downto 21), instruction(20 downto 16),
regWrite_in, wr_in, wd_in);

sign : sign_extender port map(instruction(15 downto 0), sign_extend_out);

shamt <= instruction(10 downto 6);

end arch;


