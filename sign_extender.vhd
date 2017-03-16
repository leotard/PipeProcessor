library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extender is
port(
	sign_extend_in : in std_logic_vector(15 downto 0);
	sign_extend_out : out std_logic_vector(31 downto 0)
);

end sign_extender;

architecture arch of sign_extender is
signal temp : std_logic_vector(31 downto 0);

begin
  
 
temp(31 downto 16) <= "1111111111111111" when sign_extend_in(15) ='1' else
                        "0000000000000000";
  

temp(15 downto 0) <= sign_extend_in;
sign_extend_out <= temp;

end arch;