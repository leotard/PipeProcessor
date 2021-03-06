

LIBRARY ieee;
library work;
use work.pkg.all;
USE ieee.std_logic_1164.all;
use STD.textio.all; 
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity mem_stage is 
port( 
	clock                  : in std_logic;
	addr                   : in std_logic_vector(31 downto 0);
	addr_out               : out std_logic_vector(31 downto 0);
	write_data             : in std_logic_vector(31 downto 0);
	mem_r                  : in std_logic;
	mem_w                  : in std_logic;
	mem_toReg              : in std_logic;
	zero                   : in std_logic;
	branch                 : in std_logic;
	mux_instrStage_control : out std_logic;
	mem_toReg_out          : out std_logic;
	selected_dest_mem      : in std_logic_vector(4 downto 0);
	selected_dest_mem_out  : out std_logic_vector(4 downto 0);	
	regWrite_mem           : in std_logic;
	regWrite_mem_out       : out std_logic;
	read_data              : out std_logic_vector(31 downto 0);
	memory_array : out registers(0 to 32767)
);
end mem_stage;

architecture behav of mem_stage is
	
COMPONENT memory IS
        GENERIC(
            ram_size : INTEGER := 32768
        );
        PORT (
            clock: IN STD_LOGIC;
            writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            address: IN INTEGER RANGE 0 TO ram_size-1;
            memwrite: IN STD_LOGIC := '0';
            memread: IN STD_LOGIC := '0';
            readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	memory_array : out registers(0 to ram_size -1)
            --waitrequest: OUT STD_LOGIC
        );
END COMPONENT;

signal memwrite, memread: integer;
signal m_addr : INTEGER RANGE 0 TO 32767;
signal mem_write, mem_read: std_logic;
signal REG_readdata, readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal REG_addrout: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal REG_mem_toRegout: std_logic;
signal REG_selected_dest_memout: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal REG_regWrite_memout: std_logic;


BEGIN

mux_instrStage_control <= (zero and branch);
m_addr <= to_integer(unsigned(addr));

mem: memory port map (clock, write_data, m_addr, mem_w, mem_r, readdata, memory_array);

process (clock)
begin
	 
		if (falling_edge(clock)) then
			if (mem_r='1') then
				REG_readdata <= readdata;
			end if;
			REG_addrout <= addr;
			REG_mem_toRegout <= mem_toReg;
			REG_selected_dest_memout <= selected_dest_mem;
			REG_regWrite_memout <= regWrite_mem;
		elsif(rising_edge(clock)) then
			if (mem_r='1') then
				read_data <= REG_readdata;
			end if;
			addr_out <= REG_addrout;
			mem_toReg_out <= REG_mem_toRegout;
			selected_dest_mem_out <= REG_selected_dest_memout;
			regWrite_mem_out <= REG_regWrite_memout;
		end if;
	
END PROCESS;

END behav;