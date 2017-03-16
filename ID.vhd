LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity instruction_decode is
	port(
		instruction : in std_logic_vector(31 downto 0);

		pc_old : in std_logic_vector(31 downto 0);
		pc_out : out std_logic_vector(31 downto 0)

		writeEnable : in std_logic;
		clock : in std_logic;
		reset : in std_logic;

		--control unit
		alu_src_out : out std_logic;
		alu_op_out : out std_logic;
		reg_dst_out : out std_logic;

		mem_r_out : out std_logic;
		mem_w_out : out std_logic;

		reg_w_out : out std_logic;
		mem_reg_out : out std_logic;
		branch : out std_logic

		--registers
		wr : in std_logic_vector(4 downto 0);
		wd : in std_logic_vector(31 downto 0);
		rd1 : out std_logic_vector(31 downto 0);
        rd2 : out std_logic_vector(31 downto 0);
        rr1 : out std_logic_vector(4 downto 0);
        rr2 : out std_logic_vector(4 downto 0);
        sign_extend_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavior of instruction_decode is

component registers
	port(
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

component control
	port(
		op_code : in std_logic_vector (5 downto 0);
		instruction	: in std_logic_vector(5 downto 0);

		reg_dst : out std_logic;
		bne : out std_logic;
		jump : out std_logic;
		jr : out std_logic;
		branch : out std_logic;
		LUI : out std_logic;
		alu_lh_w : out std_logic;
		--set 00 to return, 01 to low, 10 to high
		alu_lh_r : out std_logic_vector(1 downto 0);
		alu_op : out std_logic_vector(4 downto 0);
		alu_src : out std_logic;
		mem_r : out std_logic;
		mem_w : out std_logic;
		reg_w : out std_logic;
		mem_reg : out std_logic;
		clock : in std_logic
	);
end component;

component sign_extender
	port(
		sign_extend_in : in std_logic_vector(15 downto 0);
		sign_extend_out : out std_logic_vector(31 downto 0)
	);
end component;

