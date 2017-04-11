

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all; 
use ieee.std_logic_textio.all;
library work;
use work.pkg.all;

entity processor_tb is
end processor_tb;

architecture behavior of processor_tb is

component processor is
port(
	clock : in std_logic;
	register_array : out registers(0 to 33);
	memory_array : out registers(0 to 32767)
	
);
end component;

signal success: integer;
signal success_mem: integer;

impure function WrittenRegFile(FileName : STRING; reg : in registers(0 to 33)) Return integer is
	file FileHandle       : TEXT open WRITE_MODE is FileName;
  	variable CurrentLine  : LINE;
	variable counter      : integer := 0;
	variable TempWord     : std_logic_vector(31 downto 0);


begin 
	for counter in 0 to 33 loop --till the end of file is reached continue.
		TempWord := reg(counter);
		write (CurrentLine,TempWord);
		writeline (FileHandle,CurrentLine);  --Read the whole line from the file
		   --Read the contents of the line from  the file into a variable.
	end loop;
	
return 1;
	
end function;

impure function WrittenMemFile(FileName : STRING; reg : in registers(0 to 32767)) Return integer is
	file FileHandle       : TEXT open WRITE_MODE is FileName;
  	variable CurrentLine  : LINE;
	variable counter      : integer := 0;
	variable TempWord     : std_logic_vector(31 downto 0);


begin 
	for counter in 0 to 32767 loop --till the end of file is reached continue.
		TempWord := reg(counter);
		write (CurrentLine,TempWord);
		writeline (FileHandle,CurrentLine);  --Read the whole line from the file
		   --Read the contents of the line from  the file into a variable.
	end loop;
	
return 1;
	
end function;


	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;

signal registers_out : registers(0 to 33);
signal memory_out : registers(0 to 32767);

begin

-- Connect the components which we instantiated above to their
-- respective signals.
dut: processor 
port map(
	clk,registers_out, memory_out
);


				

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;



test_process : process

--variable WrittenReg: registers(0 to 33);

begin
	--add
	--wait for clk_period/2;
	

	wait for 10*clk_period;
	
	
	success <= WrittenRegFile("register_file.txt", registers_out);
	success_mem <= WrittenMemFile("memory.txt", memory_out);
	

	
wait;
end process;
	
--reset <= wait_signal_1;

end;
