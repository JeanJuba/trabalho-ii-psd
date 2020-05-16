library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_block is
	Port (
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(15 downto 0);
		address : out STD_LOGIC_VECTOR(4 downto 0);
		store_value : out STD_LOGIC_VECTOR(15 downto 0);
		write_value : out STD_LOGIC);
end control_block;

architecture Behavioral of control_block is

	type state is (START, CONFIGURATE, STORE, INCREMENT, IDLE, RESET_STATE);
	type mem is array(2 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	
	signal current_state : state;
	
	signal memory_values : mem := ("1111111111111111", "0000000000110100", "0000110000001111");
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal sg_counter : STD_LOGIC_VECTOR(memory_values'range) := "000";
	signal sg_store_value : STD_LOGIC_VECTOR(15 downto 0);
	
	signal ir : STD_LOGIC_VECTOR(31 downto 0); --instruction register
	signal pc : STD_LOGIC_VECTOR(15 downto 0); --program counter
	signal op_code : STD_LOGIC_VECTOR(7 downto 0); --operation code
	signal first_operand : STD_LOGIC_VECTOR(15 downto 0);
	signal second_operand : STD_LOGIC_VECTOR(15 downto 0);
	
begin
	process(clock, reset)
	begin
	
		if reset = '1' then
			current_state <= RESET_STATE;
		
		elsif clock'Event and clock = '1' then
			
			case(current_state) is
				
				when START =>
				current_state <= CONFIGURATE;
				
				when CONFIGURATE =>
					if sg_store_value = "1111111111111111" then
						current_state <= IDLE;
					else
						current_state <= STORE;
					end if;
					
				when STORE =>
					current_state <= INCREMENT;
				
				when INCREMENT =>
					current_state <= CONFIGURATE;
				
				when IDLE =>
					current_state <= IDLE;
				
				when RESET_STATE =>
				
				
			end case;
		
		end if;
	
	end process;
	
	process(current_state)
	begin
		
		case(current_state) is
		
			when START =>
				write_value <= '0';
				store_value <= "0000000000000000";
				write_value <= '0';
		
			when CONFIGURATE =>
				address <= sg_address;
				sg_store_value <= memory_values(to_integer(unsigned(sg_counter)));
				store_value <= "0000000000000000";
				write_value <= '0';
			
			when STORE =>
				store_value <= sg_store_value;
				write_value <= '1';
			
			when INCREMENT =>
				sg_counter <= std_logic_vector( unsigned(sg_counter) + 1 );
				sg_address <= std_logic_vector(unsigned(sg_address) + 1);
				write_value <= '0';
			
			when IDLE =>
				sg_address <= "00000";
				address <= "00000";
				write_value <= '0';
				store_value <= "0000000000000000";
				write_value <= '0';
			
			when RESET_STATE =>
				
		
		end case;
		
	end process;

end Behavioral;

