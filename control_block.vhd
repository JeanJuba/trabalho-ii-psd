library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_block is
	Port (
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(31 downto 0));
end control_block;

architecture Behavioral of control_block is

	type state is (CONFIGURATE, INCREMENT, IDLE);
	type mem is array(1 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	
	signal current_state : state;
	signal addr : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal memory_values : mem := ("00000010000000110000010000000011", "00000110000001000000011000000111", "11111111111111111111111111111111");
	signal counter : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin
	process(clock, reset)
	begin
	
		if reset = '1' then
		
		elsif clock'Event and clock = '1' then
			
			case(current_state) is
			
				when CONFIGURATE =>
					if instruction = "11111111111111111111111111111111" then
						estado <= IDLE;
					else
						estado <= INCREMENT;
					end if;
				
				when INCREMENT =>
					estado <= CONFIGURAR;
				
				when IDLE =>
				
				
			end case;
		
		end if;
	
	end process;
	
	process(current_state)
	begin
		
		case(current_state) is
		
			when CONFIGURATE =>
			
			when INCREMENT =>
			
			when IDLE =>
		
		end case;
	
	
	end process;

end Behavioral;

