library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port (
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
end control;

architecture arch of control is
signal reg_r_t, reg_w_t, alu_src_t, mem_w_t, mem_r_t : std_logic := '0';
signal reg_dst_t, mem_reg_t: std_logic := 'X';
signal branch_t, bne_t : std_logic := '0';
signal jump_t, jr_t, LUI_t : std_logic := '0';
--signal alu_lh_w_t : std_logic := '0';
--signal alu_lh_r_t : std_logic_vector(1 downto 0) := "00";
signal alu_op_t : std_logic_vector(4 downto 0) := "XXXXX";


begin


reg_w <= reg_w_t;
alu_src <= alu_src_t;
alu_op <= alu_op_t;
reg_dst <= reg_dst_t;
branch <= branch_t;
bne <= bne_t;
jump <= jump_t;
jr <= jr_t;
LUI <= LUI_t;
--alu_lh_r <= alu_lh_r_t;
--alu_lh_w <= alu_lh_w_t;
mem_w <= mem_w_t;
mem_r <= mem_r_t;
mem_reg <= mem_reg_t;


	process(instruction)
	begin


		case op_code is
			--R type
			when "000000" =>
				reg_w_t <= '1';
				reg_dst_t <= '1';
				mem_reg_t <= '0';

				case instruction is
					--add
					when "100000" =>
						alu_op_t <= "00000";

					--sub
					when "100010" =>
						alu_op_t <= "00001";

					--mult
					when "011000" =>
						alu_op_t <= "00010";
						reg_w_t <= '0';
						--alu_lh_w_t <= '1';

					--div
					when "011010" =>
						reg_w_t <= '0';
						alu_op_t <= "00011";
						--alu_lh_w_t <= '1';

					--slt
					when "101010" =>
						alu_op_t <= "01101";

					--and
					when "100100" =>
						alu_op_t <= "00100";

					--or
					when "100101" =>
						alu_op_t <= "00101";

					--nor
					when "100111" =>
						alu_op_t <= "00110";

					--xor
					when "101000" =>
						alu_op_t <= "00111";

					--mfhi
					when "010000" =>
						alu_op_t <= "10000";
						--alu_lh_r_t <= "10";

					--mflo
					when "010010" =>
						alu_op_t <= "10001";
						--alu_lh_r_t <= "01";

					--sll
					when "000000" =>
						alu_op_t <= "01000";

					--srl
					when "000010" =>
						alu_op_t <= "01001";

					--sra
					when "000011" =>
						alu_op_t <= "01010";
						

					--jr
					when "001000" =>
						alu_op_t <= "XXXXX";
						jr_t <= '1';
						jump_t <= '1';

					when others => null;
				end case;

			--I type
			--addi
			when "001000" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "00000";
				reg_dst_t <= '0';
				mem_reg_t <= '0';

			--andi
			when "001100" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "00100";
				reg_dst_t <= '0';
				mem_reg_t <= '0';

			--ori
			when "001101" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "00101";
				reg_dst_t <= '0';
				mem_reg_t <= '0';

			--xori
			when "001110" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "00111";
				reg_dst_t <= '0';
				mem_reg_t <= '0';

			--lui
			when "001111" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "01111";
				reg_dst_t <= '0';
				LUI_t <= '1';
				mem_reg_t <= '0';

			--slti
			when "001010" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "01101";
				reg_dst_t <= '0';
				mem_reg_t <= '0';

			--lw
			when "100011" =>
				reg_w_t <= '1';
				alu_src_t <= '1';
				alu_op_t <= "00000";
				reg_dst_t <= '0';
				mem_r_t <= '1';
				mem_reg_t <= '1';

			--sw
			when "101011" =>
				alu_src_t <= '1';
				reg_w_t <= '0';
				alu_op_t <= "00000";
				mem_w_t <= '1';

			--beq
			when "000100" =>
				alu_op_t <= "01011";
				branch_t <= '1';
				alu_src_t <= '0';

			--bne
			when "000101" =>
				alu_op_t <= "01100";
				branch_t <= '1';
				bne <= '1';
				alu_src_t <= '0';

			--J type
			--j
			when "000010" =>
				alu_op_t <= "XXXXX";
				jump_t <= '1';

			--jal
			when "000011" =>
				reg_w_t <= '1';
				alu_op_t <= "XXXXX";
				jump_t <= '1';

			when others => null;

		end case;
		end process;
end arch;