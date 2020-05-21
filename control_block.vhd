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

	type state is (START_STATE, CONFIGURATE, WRITE_MEM, INCREMENT, IDLE, DECODE, LOAD, LOAD_P1, STORE, STORE_P1, COUNTER_UP, RESET_STATE, HALT);
	type mem is array(3 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type register_structure is array(3 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	
	signal current_state : state;
	
	signal memory_values : mem := ("1111111111111111", --end of program
											 "0001000000000000", --store reg 0 in pos 0
											 "1010000000000111", --7
											 "0000000000000001");--load to register 00 value at memopry position 00001
											 
	signal registers : register_structure;
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal sg_counter : STD_LOGIC_VECTOR(memory_values'range) := "0000";
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
						current_state <= WRITE_MEM;
					end if;
					
				when WRITE_MEM =>
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
							current_state <= STORE;
						
						when "0010" => --MOVE
					
						when "0011" => --ADD
						
						when "0100" => --SUB
						
						when "0101" => --AND
						
						when "0110" => --OR
						
						when "0111" => --BRANCH
						
						when "1000" => --BZERO
						
						when "1001" => --BNEG
						
						when "1010" => --NOP
							current_state <= COUNTER_UP;
						
						when "1011" => --HALT
						
						when others => --UNDEFINED
							current_state <= HALT;
							
					end case;
					
				when LOAD =>
					current_state <= LOAD_P1;
					
				when LOAD_P1 =>
					current_state <= COUNTER_UP;
					
				when STORE =>
					current_state <= STORE_P1;
				
				WHEN STORE_P1 =>
					current_state <= COUNTER_UP;
				
				when COUNTER_UP =>
					current_state <= DECODE;
				
				when RESET_STATE =>
				
				when HALT =>
				
				
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
			
			when WRITE_MEM =>
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
				address <= ir(4 downto 0);
				
			when LOAD_P1 =>
				registers(to_integer(unsigned(ir(11 downto 5)))) <= "0000" & instruction(11 downto 0);
				
			when STORE =>
				address <= ir(10 downto 5);
				store_value <= "1010" & registers(to_integer(unsigned(ir(4 downto 0))))(11 downto 0);
				write_value <= '1';
				
			when STORE_P1 =>
				write_value <= '0';
			
			when COUNTER_UP =>
				pc <= std_logic_vector(unsigned(pc) + 1);
				address <= std_logic_vector(unsigned(pc) + 1);
				
			when RESET_STATE =>
			
			when HALT =>
				
		
		end case;
		
	end process;

end Behavioral;

