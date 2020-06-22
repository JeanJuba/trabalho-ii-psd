library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_block is
    Port (clock : in  STD_LOGIC;
			 reset : in  STD_LOGIC;
			 start : in STD_LOGIC;
			 inputval : in STD_LOGIC_VECTOR(15 downto 0);
			 nxtval : out STD_LOGIC;
			 incoming : in STD_LOGIC);
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
		file_instruction : in STD_LOGIC_VECTOR(15 downto 0);
		incoming : in STD_LOGIC;
		nxtval : out STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(15 downto 0);
		address : out STD_LOGIC_VECTOR(4 downto 0);
		store_value : out STD_LOGIC_VECTOR(15 downto 0);
		write_value : out STD_LOGIC;
		a : out STD_LOGIC_VECTOR(15 downto 0);
		b : out STD_LOGIC_VECTOR(15 downto 0);
		op_code : out STD_LOGIC_VECTOR(3 downto 0);
		result : in STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	component op_block is
	port (
		clock : in STD_LOGIC;
		a : in STD_LOGIC_VECTOR(15 downto 0);
		b : in STD_LOGIC_VECTOR(15 downto 0);
		op_code : in STD_LOGIC_VECTOR(3 downto 0);
		result : out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	signal sg_instruction, sg_store_value, sg_a, sg_b, sg_result : STD_LOGIC_VECTOR(15 downto 0);
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0);
	signal sg_op_code : STD_LOGIC_VECTOR(3 downto 0);
	signal sg_write_value : STD_LOGIC;
	
begin
	
	ctrl : control_block port map(clock, reset, start, inputval, incoming, nxtval, sg_instruction, sg_address, sg_store_value, sg_write_value, sg_a, sg_b, sg_op_code, sg_result);
	mem : sync_ram port map(clock, sg_write_value, sg_address, sg_store_value, sg_instruction);
	op : op_block port map(clock, sg_a, sg_b, sg_op_code, sg_result);

end Behavioral;

