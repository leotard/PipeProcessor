library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extender is
port(
	input : in std_logic_vector(15 downto 0);
	sign_extend : out std_logic_vector(31 downto 0)
);

end sign_extender;

architecture arch of sign_extender is
signal temp : std_logic_vector(31 downto 0);

begin
  
sign_extend(15 downto 0) <= input;
sign_extend(31 downto 16) <= "1111111111111111" when input(15) ='1' else
                        "0000000000000000";
  

--temp(15 downto 0) <= input;
--sign_extend <= temp;

end arch;