library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_block is
	Port (
		clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		start : in STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(15 downto 0);
		address : out STD_LOGIC_VECTOR(4 downto 0);
		store_value : out STD_LOGIC_VECTOR(15 downto 0);
		write_value : out STD_LOGIC);
end control_block;

architecture Behavioral of control_block is

	type state is (START_STATE, CONFIGURATE, STORE, INCREMENT, IDLE, DECODE, LOAD, RESET_STATE);
	type mem is array(2 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type register_structure is array(3 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	
	signal current_state : state;
	
	signal memory_values : mem := ("1111111111111111", --end of program
											 "0000000000000111", --7
											 "0000000000000001");--load to register 00 value at memopry position 00001
											 
	signal registers : register_structure;
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal sg_counter : STD_LOGIC_VECTOR(memory_values'range) := "000";
	signal sg_store_value : STD_LOGIC_VECTOR(15 downto 0);
	
	signal ir : STD_LOGIC_VECTOR(15 downto 0);     --instruction register
	signal pc : STD_LOGIC_VECTOR(4 downto 0) := "00000";     --program counter
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
				
				when START_STATE =>
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
					if start = '1' then 
						current_state <= DECODE;
					else
						current_state <= IDLE;
					end if;
					
				when DECODE =>
					case instruction(15 downto 12) is
						
						when "0000" => --LOAD
							current_state <= LOAD;
						
						when "0001" => --STORE
						
						when "0010" => --MOVE
					
						when "0011" => --ADD
						
						when "0100" => --SUB
						
						when "0101" => --AND
						
						when "0110" => --OR
						
						when "0111" => --BRANCH
						
						when "1000" => --BZERO
						
						when "1001" => --BNEG
						
						when "1010" => --NOP
						
						when "1011" => --HALT
						
						when others => --UNDEFINED
							
					end case;
					
				when LOAD =>
					op_code <= instruction(15 downto 12);
				
				when RESET_STATE =>
				
				
			end case;
		
		end if;
	
	end process;
	
	process(current_state)
	begin
		
		case(current_state) is
		
			when START_STATE =>
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
				sg_counter <= std_logic_vector(unsigned(sg_counter) + 1);
				sg_address <= std_logic_vector(unsigned(sg_address) + 1);
				write_value <= '0';
			
			when IDLE =>
				sg_address <= "00000";
				address <= pc;
				write_value <= '0';
				store_value <= "0000000000000000";
				write_value <= '0';
				
			when DECODE =>
			   ir <= instruction;
				op_code <= instruction(15 downto 12);	
				
				
			when LOAD =>
				
				
			
			
			when RESET_STATE =>
				
		
		end case;
		
	end process;

end Behavioral;

