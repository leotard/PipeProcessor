library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
	port (
		--input op code
		op_code : in std_logic_vector (5 downto 0);

		reg_dst_o : out std_logic;
		br_o : out std_logic;
		j_o : out std_logic;
		mem_read_o : out std_logic;
		mem_write_o : out std_logic;

		--ALU control
		alu_op_o : out std_logic_vector(4 downto 0);
		alu_src_o : out std_logic;

		reg_write_o : out std_logic;

		clk : std_logic
	);
end control_unit;

architecture behavioral of control_unit is
begin
	op := ("00"&op_code);
	case op is
		--ADD
		when 'X"00"' => reg_dst_o <= '1';
					br_o <= '0';
					j_o <= '0';
					mem_read_o <= '0';
					mem_write_o <= '0';
					alu_op_o <= "00001";
					alu_src_o <= '0';
					reg_write_o <= '1';

		--SUB		
		when '2' => reg_dst_o <= '1';
					br_o <= '0';
					j_o <= '0';
					mem_read_o <= '0';
					mem_write_o <= '0';
					alu_op_o <= "00010";
					alu_src_o <= '0';
					reg_write_o <= '1';

		--ADDI
		when '3' => reg_dst_o <= '1';
					br_o <= '0';
					j_o <= '0';
					mem_read_o <= '0';
					mem_write_o <= '0';
					alu_op_o <= "00010";
					alu_src_o <= '0';
					reg_write_o <= '1';

		--MULTI

		--DIV

		--SLT

		--SLTI

		--AND

		--OR

		--NOR

		--XOR

		--ANDI

		--ORI

		--XORI

		--MFHI

		--MFLO

		--LUI

		--SLL

		--SRL

		--SRA

		--LW

		--SW

		--BEQ

		--BNE

		--J

		--JR

		--JAL
					

	end case;
	end process;
end behavioral;
