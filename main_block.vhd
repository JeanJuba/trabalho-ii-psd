library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_block is
    Port ( reset : in  STD_LOGIC;
			  start : in STD_LOGIC;
           clock : in  STD_LOGIC);
end main_block;

architecture Behavioral of main_block is
	
	component sync_ram is 
	port(
		clock : in std_logic;
		we: in std_logic;
		address : in std_logic_vector (4 downto 0);
		datain: in std_logic_vector (15 downto 0);
		dataout: out std_logic_vector (15 downto 0));
	end component;
	
	component control_block is
	Port (
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		start : in STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(15 downto 0);
		address : out STD_LOGIC_VECTOR(4 downto 0);
		store_value : out STD_LOGIC_VECTOR(15 downto 0);
		write_value : out STD_LOGIC);
	end component;
	
	signal sg_instruction, sg_store_value : STD_LOGIC_VECTOR(15 downto 0);
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0);
	signal sg_write_value : STD_LOGIC;
	
begin
	
	ctrl : control_block port map(clock, reset, start, sg_instruction, sg_address, sg_store_value, sg_write_value);
	mem : sync_ram port map(clock, sg_write_value, sg_address, sg_store_value, sg_instruction);

end Behavioral;

