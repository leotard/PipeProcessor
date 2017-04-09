LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ID_tb is
end ID_tb;

architecture test of ID_tb is

COMPONENT instruction_decode is
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
END COMPONENT;

signal clock: std_logic := '0';
signal instruction_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal wr_in_t : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal wd_in_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal regWrite_in_t : std_logic;
signal pc_in_t : std_logic_vector(31 downto 0) := (OTHERS => '0');

signal read_data1_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal read_data2_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal pc_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal alu_op_t : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal alu_src_t : std_logic;
signal funct_t : std_logic_vector(5 downto 0) := (OTHERS => '0');
signal imm_t : std_logic_vector(31 downto 0) := (OTHERS => '0');
signal shamt_t : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal dest_reg_sel_t : std_logic;
signal dest_reg1_t : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal dest_reg2_t : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal branch_out_t, memRead_out_t, memToReg_out_t, memWrite_out_t, reg_write_out_t: std_logic;
signal BNE_out_t : std_logic;
signal Jump_out_t : std_logic;
signal LUI_out_t : std_logic;
signal jr_out_t : std_logic;

BEGIN

instruction_decode_t : instruction_decode
PORT MAP
(
	instruction => instruction_t,
	wr_in => wr_in_t,
	wd_in => wd_in_t,
	regWrite_in => regWrite_in_t,
	pc_in => pc_in_t,
	read_data1 => read_data1_t,
	read_data2 => read_data2_t,
	pc => pc_t,
	alu_op => alu_op_t,
	alu_src => alu_src_t,
	funct => funct_t,
	imm => imm_t,
	shamt => shamt_t,
	dest_reg_sel => dest_reg_sel_t,
	dest_reg1 => dest_reg1_t,
	dest_reg2 => dest_reg2_t,
	branch_out => branch_out_t,
	memRead_out => memRead_out_t,
	memToReg_out => memToReg_out_t,
	memWrite_out => memWrite_out_t,
	reg_write_out => reg_write_out_t,
	BNE_out => BNE_out_t,
	Jump_out => Jump_out_t,
	LUI_out => LUI_out_t,
	jr_out => jr_out_t,
	clock => clock
	);

id_test : process
begin

instruction_t <= "00000000011000100010000000100000";
pc_in_t <= "00000000000000000000000000100000";
regWrite_in_t <= '0';
wr_in_t <= "00000";
wd_in_t <= "00000000000000000000000000000000";

WAIT;

end process id_test;
end test;