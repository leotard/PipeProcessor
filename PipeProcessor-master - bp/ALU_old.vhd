library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port(
	clock : in std_logic;
	A : in std_logic_vector (31 downto 0);
	B : in std_logic_vector (31 downto 0);
	control : in std_logic_vector (4 downto 0);
	output : out std_logic_vector (31 downto 0);
	zero : out std_logic
);

end ALU;

architecture arch of ALU is

begin

process (clock)

variable mult_temp: std_logic_vector(63 downto 0);

begin
	if(rising_edge(clock)) then
		if(control = "00000") then --ADD
			output <= std_logic_vector(signed(A) + signed(B));
			zero <= '0';
		elsif(control = "00001") then --SUB
			output <= std_logic_vector(signed(A) - signed(B));
			zero <= '0';
		elsif(control = "00010") then --MULT
			mult_temp := std_logic_vector(signed(A) * signed(B));
			output <= mult_temp(31 downto 0);
			zero <= '0';
		elsif(control = "00011") then --DIV
			output <= std_logic_vector(signed(A) / signed(B));
			zero <= '0';
		elsif(control = "00100" or control = "01111") then -- AND ANDI
			output <= A and B;
			zero <= '0';
		elsif(control = "00101" or control = "10000") then -- OR ORI
			output <= A or B;
			zero <= '0';
		elsif(control = "00110") then -- NOR
			output <= A nor B;
			zero <= '0';
		elsif(control = "00111" or control = "10001") then --XOR XORI
			output <= A xor B;
			zero <= '0';
		elsif(control = "01000") then --shift left
			output <= to_stdlogicvector(to_bitvector(A) sll to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "01001") then --shift right
			output <= to_stdlogicvector(to_bitvector(A) srl to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "01010") then --shift arith
			output <= to_stdlogicvector(to_bitvector(A) sra to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "01011") then -- branch on equal
			if(std_logic_vector(signed(A) - signed(B)) = "00000000000000000000000000000000") then
				zero <= '1';
			else
				zero <= '0';
			end if;
		elsif(control = "01100") then -- branch on not equal
			if(std_logic_vector(signed(A) - signed(B)) = "00000000000000000000000000000000") then
				zero <= '0';
			else
				zero <= '1'; 
			end if;
		elsif(control = "01101" or control = "01110") then --set on less than
			if(signed(A) < signed(B)) then
				zero <= '0';
				output <= "00000000000000000000000000000001";
			else
				zero <= '0';
				output <= "00000000000000000000000000000000";
			end if;
		end if;
	end if;
end process;

end arch;
