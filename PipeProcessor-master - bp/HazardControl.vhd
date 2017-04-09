library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HazardControl is 
	PORT (
		ID_rr1	:	in std_logic_vector(4 downto 0);
		ID_rr2	:	in std_logic_vector(4 downto 0);
		EX_rr2	: 	in std_logic_vector(4 downto 0);
		--processor state
		stall   : out std_logic;
		--hazard control state
		isStall : out std_logic
		);
end HazardControl;

architecture behaviour of HazardControl is

signal isStall_t : std_logic ;

BEGIN

isStall <= isStall_t;

with isStall_t select stall <=
	'1' when '1',
	'0' when others;

	case isStall_t is
		--insert one cycle delay
		when '0' =>
			if (((EX_rr2 = ID_rr1) or (EX_rr2 = ID_rr2)) and EX_rr2 /= "UUUUU" and (ID_rr1 /= "UUUUU" or ID_rr2 /= "UUUUU")) then
				isStall_t <= '1';
			end if;
			
		when '1' =>
			isStall_t <= '1';

		--reset to default
		when others =>
			isStall_t <= 0;

	end case;

END behaviour;



