library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port(
	clock : in std_logic;
	A : in std_logic_vector (31 downto 0);
	B : in std_logic_vector (31 downto 0);
	control : in std_logic_vector (3 downto 0);
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
		if(control = "0000") then --ADD
			output <= std_logic_vector(signed(A) + signed(B));
			zero <= '0';
		elsif(control = "0001") then --SUB
			output <= std_logic_vector(signed(A) - signed(B));
			zero <= '0';
		elsif(control = "0010") then --MULT
			mult_temp := std_logic_vector(signed(A) * signed(B));
			output <= mult_temp(31 downto 0);
			zero <= '0';
		elsif(control = "0011") then --DIV
			output <= std_logic_vector(signed(A) / signed(B));
			zero <= '0';
		elsif(control = "0100") then -- AND
			output <= A and B;
			zero <= '0';
		elsif(control = "0101") then -- OR 
			output <= A or B;
			zero <= '0';
		elsif(control = "0110") then -- NOR
			output <= A nor B;
			zero <= '0';
		elsif(control = "0111") then --XOR
			output <= A xor B;
			zero <= '0';
		elsif(control = "1000") then --shift left
			output <= to_stdlogicvector(to_bitvector(A) sll to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "1001") then --shift right
			output <= to_stdlogicvector(to_bitvector(A) srl to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "1010") then --shift arith
			output <= to_stdlogicvector(to_bitvector(A) sra to_integer(unsigned(B)));
			zero <= '0';
		elsif(control = "1011") then -- branch on equal
			if(std_logic_vector(signed(A) - signed(B)) = "00000000000000000000000000000000") then
				zero <= '1';
			else
				zero <= '0';
			end if;
		elsif(control = "1100") then -- branch on not equal
			if(std_logic_vector(signed(A) - signed(B)) = "00000000000000000000000000000000") then
				zero <= '0';
			else
				zero <= '1'; 
			end if;
		elsif(control = "1101" or control = "1110") then --set on less than
			if(signed(A) < signed(B)) then
				output <= "00000000000000000000000000000001";
			else
				output <= "00000000000000000000000000000000";
			end if;
		end if;
	end if;
end process;

end arch;