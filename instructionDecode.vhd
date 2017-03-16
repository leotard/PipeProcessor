LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity instruction_decode is
	port(

		);
end entity;

architecture id of ID is


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


component Control_Unit is
	port(
		clk 			: in std_logic;
		opCode 			: in std_logic_vector(5 downto 0);
		funct 			: in std_logic_vector(5 downto 0);

		--ID
		RegWrite 		: out std_logic;

		--EX
		ALUSrc 			: out std_logic;
		ALUOpCode 		: out std_logic_vector(3 downto 0);
		RegDest 		: out std_logic;
		Branch 			: out std_logic;
		BNE 			: out std_logic;
		Jump 			: out std_logic;
		LUI 			: out std_logic;
		ALU_LOHI_Write 		: out std_logic;
		ALU_LOHI_Read 		: out std_logic_vector(1 downto 0);

		--MEM
		MemWrite 		: out std_logic;
		MemRead 		: out std_logic;

		--WB
		MemtoReg 		: out std_logic
		);
end component;

component register_lib is
	port (
		rd1 : out std_logic_vector(31 downto 0);
		rd2 : out std_logic_vector(31 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rr2 : in std_logic_vector(4 downto 0);
		alu_lh_r : in std_logic;

		alu_lo_in : in std_logic_vector(31 downto 0);
		alu_hi_in : in std_logic_vector(31 downto 0);

		writeEnable : in std_logic;
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0);
		alu_hi_out : out std_logic_vector(31 downto 0);
		alu_lo_out : out std_logic_vector(31 downto 0);

		clk : in std_logic
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

begin

