LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ID_EX is
	port(
		clock : in std_logic;

		--Data
		address_in	: in std_logic_vector(31 downto 0);
		rd1_in		: in std_logic_vector(31 downto 0);
		rd2_in		: in std_logic_vector(31 downto 0);
		sign_extended_in : in std_logic_vector(31 downto 0);

		address_out	: out std_logic_vector(31 downto 0);
		rd1_out		: out std_logic_vector(31 downto 0);
		rd2_out		: out std_logic_vector(31 downto 0);
		sign_extended_out : out std_logic_vector(31 downto 0);

		--registers
		rr1_in : in std_logic_vector(4 downto 0);
		rr2_in : in std_logic_vector(4 downto 0);
		wr_in : in std_logic_vector(4 downto 0);

		rr1_out : out std_logic_vector(4 downto 0);
		rr2_out : out std_logic_vector(4 downto 0);
		wr_out : out std_logic_vector(4 downto 0);

		--control unit
		reg_dst_in : in std_logic;
		bne_in : in std_logic;
		jump_in : in std_logic;
		jr_in : in std_logic;
		branch_in : in std_logic;
		LUI_in : in std_logic;
		alu_lh_w_in : in std_logic;
		alu_lh_r_in : in std_logic_vector(1 downto 0);
		alu_op_in : in std_logic_vector(4 downto 0);
		alu_src_in : in std_logic;
		mem_r_in : in std_logic;
		mem_w_in : in std_logic;
		reg_w_in : in std_logic;
		mem_reg_in : in std_logic;


		reg_dst_out : out std_logic;
		bne_out : out std_logic;
		jump_out : out std_logic;
		jr_out : out std_logic;
		branch_out : out std_logic;
		LUI_out : out std_logic;
		alu_lh_w_out : out std_logic;
		alu_lh_r_out : out std_logic_vector(1 downto 0);
		alu_op_out : out std_logic_vector(4 downto 0);
		alu_src_out : out std_logic;
		mem_r_out : out std_logic;
		mem_w_out : out std_logic;
		reg_w_out : out std_logic;
		mem_reg_out : out std_logic
    );
end entity;

architecture behavior of ID_EX is

signal address_t	: std_logic_vector(31 downto 0);
signal rd1_t		: std_logic_vector(31 downto 0);
signal rd2_t		: std_logic_vector(31 downto 0);
signal sign_extended_t : std_logic_vector(31 downto 0);

signal rr1_t : std_logic_vector(4 downto 0);
signal rr2_t : std_logic_vector(4 downto 0);
signal wr_t : std_logic_vector(4 downto 0);

signal reg_dst_t : std_logic;
signal bne_t : std_logic;
signal jump_t : std_logic;
signal jr_t : std_logic;
signal branch_t : std_logic;
signal LUI_t : std_logic;
signal alu_lh_w_t : std_logic;
signal alu_lh_r_t : std_logic_vector(1 downto 0);
signal alu_op_t : std_logic_vector(4 downto 0);
signal alu_src_t : std_logic;
signal mem_r_t : std_logic;
signal mem_w_t : std_logic;
signal reg_w_t : std_logic;
signal mem_reg_t : std_logic;

BEGIN
--forward
	address_t <= address_in;
	rd1_t <= rd1_in;
	rd2_t <= rd2_in;
	sign_extended_t <= sign_extended_in;

	rr1_t <= rr1_in;
	rr2_t <= rr2_in;
	wr_t <= wr_in;

	reg_dst_t <= reg_dst_in;
	bne_t <= bne_in;
	jump_t <= jump_in;
	jr_t <= jr_in;
	branch_t <= branch_in;
	LUI_t <= LUI_in;
	alu_lh_w_t <= alu_lh_w_in;
	alu_lh_r_t <= alu_lh_r_in;
	alu_op_t <= alu_op_in;
	alu_src_t <= alu_src_in;
	mem_r_t <= mem_r_in;
	mem_w_t <= mem_w_in;
	reg_w_t <= reg_w_in;
	mem_reg_t <= mem_reg_in;

process (clock)
	begin

	if(clock'event and clock = '1') then
		address_out <= address_t;
		rd1_out <= rd1_t;
		rd2_out <= rd2_t;
		sign_extended_out <= sign_extended_t;

		rr1_out <= rr1_t;
		rr2_out <= rr2_t;
		wr_out <= wr_t;

		reg_dst_out <= reg_dst_t;
		bne_out <= bne_t;
		jump_out <= jump_t;
		jr_out <= jr_t;
		branch_out <= branch_t;
		LUI_out <= LUI_t;
		alu_lh_w_out <= alu_lh_w_t;
		alu_lh_r_out <= alu_lh_r_t;
		alu_op_out <= alu_op_t;
		alu_src_out <= alu_src_t;
		mem_r_out <= mem_r_t;
		mem_w_out <= mem_w_t;
		reg_w_out <= reg_w_t;
		mem_reg_out <= mem_reg_t;
	end if;
end process;

END behavior;