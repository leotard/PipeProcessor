library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTION is
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

end EXECUTION;

architecture arch of EXECUTION is

COMPONENT PC_adder_shifter is
	port(
		address : in std_logic_vector(31 downto 0);
		pc : in std_logic_vector(31 downto 0);
		new_pc : out std_logic_vector(31 downto 0)
	);
end component;


COMPONENT ALU is
	port(
		ALU_ready : std_logic;
		A : in std_logic_vector (31 downto 0);
		B : in std_logic_vector (31 downto 0);
		imm : in std_logic_vector (31 downto 0);
		shamt : in std_logic_vector(4 downto 0);
		control : in std_logic_vector (4 downto 0);
		ALU_MUX : in std_logic;
		output : out std_logic_vector (31 downto 0);
		zero : out std_logic
	);
end component;

COMPONENT DEST_MUX_comp is
	port(
		control : in std_logic;
		A : in std_logic_vector(4 downto 0);
		B : in std_logic_vector(4 downto 0);
		output : out std_logic_vector(4 downto 0)
	);
end component;

COMPONENT EX_MEM_REG is
	port(
		clock : in std_logic;
		PC_adder_shifter_new : in std_logic_vector(31 downto 0);
		ALU_zero_new : in std_logic;
		ALU_result_new : in std_logic_vector(31 downto 0);
		dest_reg_new : in std_logic_vector(4 downto 0);
		PC_adder_shifter_out : out std_logic_vector(31 downto 0);
		ALU_zero_out : out std_logic;
		ALU_result_out : out std_logic_vector(31 downto 0);
		dest_reg_out : out std_logic_vector(4 downto 0)
	);
end component;

signal dest_reg_selected : std_logic_vector(4 downto 0);
signal dest_reg1_new : std_logic_vector(4 downto 0);
signal dest_reg2_new : std_logic_vector(4 downto 0);
signal dest_reg_sel_new : std_logic;

signal ALU_input_2: std_logic_vector(31 downto 0);
signal read_data2_new: std_logic_vector(31 downto 0);
signal imm_new: std_logic_vector(31 downto 0);

signal EX_MEM_REG_PC, new_pc_new : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_ALU_zero, zero_out_new : std_logic := '0';
signal EX_MEM_REG_ALU_result, alu_output_new : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal EX_MEM_REG_dest_reg, selected_dest_new : std_logic_vector(4 downto 0) := "00000";
signal branch_EX_MEM, memRead_EX_MEM, memToReg_EX_MEM, memWrite_EX_MEM, regWrite_EX_MEM : std_logic := '0';

signal branch_in_ID_EX, memRead_in_ID_EX, memToReg_in_ID_EX, memWrite_in_ID_EX, reg_write_in_ID_EX : std_logic;
signal BNE_in_ID_EX, Jump_in_ID_EX, LUI_in_ID_EX, jr_in_ID_EX : std_logic;

signal EX_MEM_REG_read_data2: std_logic_vector(31 downto 0);

begin
  
  

REG_DEST: DEST_MUX_comp port map (dest_reg_sel, dest_reg1, dest_reg2, selected_dest_new);

ALU_COMP : ALU port map(ALU_ready, read_data1, read_data2, imm, shamt, alu_op, alu_src, alu_output_new, zero_out_new);

PC_ADDER_SHIFTER_COMP : PC_ADDER_SHIFTER port map(imm, pc, new_pc_new);
  
process(clock)

  
  begin
    
    if(rising_edge(clock)) then
        alu_output <= EX_MEM_REG_ALU_result;
        zero_out <= EX_MEM_REG_ALU_zero;
        new_pc_out <= EX_MEM_REG_PC;
        selected_dest_out <= EX_MEM_REG_dest_reg;
	read_data2_out <= EX_MEM_REG_read_data2;
        
        branch_out <= branch_in_ID_EX;
        memRead_out <= memRead_in_ID_EX;
        memToReg_out <= memToReg_in_ID_EX;
        memWrite_out <= memWrite_in_ID_EX; 
        reg_write_out <= reg_write_in_ID_EX;
	BNE_out <= BNE_in_ID_EX;
	Jump_out <= jump_in_ID_EX;
	LUI_out <= LUI_in_ID_EX;
	jr_out <= jr_in_ID_EX;
        
    elsif(falling_edge(clock)) then
        EX_MEM_REG_ALU_result <= alu_output_new;
        EX_MEM_REG_ALU_zero <= zero_out_new;
        EX_MEM_REG_PC <= new_pc_new;
	--IF MULT OR DIV
	if(alu_op = "00010" OR alu_op = "00011") then
		EX_MEM_REG_dest_reg <= "11111"; -- NEED to write to lo reg, signal 31
	else
		 EX_MEM_REG_dest_reg <= selected_dest_new;
	end if;
	EX_MEM_REG_read_data2 <= read_data2;
        branch_in_ID_EX <= branch_in;
        memRead_in_ID_EX <= memRead_in;
        memToReg_in_ID_EX <= memToReg_in;
        memWrite_in_ID_EX <= memWrite_in;
        reg_write_in_ID_EX <= reg_write_in;
	BNE_in_ID_EX <= BNE_in;
	jump_in_ID_EX <= jump_in;
	LUI_in_ID_EX <= LUI_in;
	jr_in_ID_EX <= jr_in;
    end if;
    
end process;


end arch;