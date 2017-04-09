library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Control_tb is
end Control_tb;

architecture test of Control_tb is

COMPONENT control is 
	PORT(
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
END COMPONENT;

signal clk: std_logic := '0';
signal op_code_t: std_logic_vector(5 downto 0)		:= (OTHERS => '0');
signal instruction_t: std_logic_vector(5 downto 0)		:= (OTHERS => '0');

signal reg_dst_t: std_logic:= '0';
signal bne_t: std_logic	:= '0';
signal jump_t: std_logic:= '0';
signal jr_t: std_logic:= '0';
signal branch_t: std_logic:= '0';
signal LUI_t: std_logic:= '0';
signal alu_op_t: std_logic_vector(4 downto 0):= (OTHERS => '0');
signal alu_src_t: std_logic	:= '0';
signal mem_r_t: std_logic:= '0';
signal mem_w_t: std_logic:= '0';
signal reg_w_t  : std_logic	:= '0';
signal mem_reg_t: std_logic	:= '0';

begin

control_t: control
PORT MAP
(
	op_code => op_code_t,
	instruction => instruction_t,
	reg_dst => reg_dst_t,
	bne => bne_t,
	jump => jump_t,
	jr => jr_t,
	branch => branch_t,
	LUI => LUI_t,
	alu_op => alu_op_t,
	alu_src => alu_src_t,
	mem_r => mem_r_t,
	mem_w => mem_w_t,
	reg_w => reg_w_t,
	mem_reg => mem_reg_t
	);

control_test : process
begin
--R type test
op_code_t <= "000000";
instruction_t <= "100010";

REPORT "---------------Testing R-type instruction---------------";

ASSERT(reg_w_t = '1')
REPORT "reg_w_t is wrong"	SEVERITY ERROR;

ASSERT(reg_dst_t = '1')
REPORT "reg_dst is wrong"	SEVERITY ERROR;

ASSERT(mem_reg_t = '0')
REPORT "mem_reg is wrong"	SEVERITY ERROR;

ASSERT(alu_op_t = "00000")
REPORT "alu_op_t is wrong"	SEVERITY ERROR;


WAIT;

end process control_test;
end test;