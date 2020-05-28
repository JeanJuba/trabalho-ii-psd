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
		write_value : out STD_LOGIC;
		a : out STD_LOGIC_VECTOR(15 downto 0);
		b : out STD_LOGIC_VECTOR(15 downto 0);
		op_code : out STD_LOGIC_VECTOR(3 downto 0);
		result : in STD_LOGIC_VECTOR(15 downto 0));
end control_block;

architecture Behavioral of control_block is

	type state is (START_STATE, CHECK_COUNTER, CONFIGURATE, WRITE_MEM, INCREMENT,
						IDLE, DECODE, LOAD, LOAD_P1, STORE, STORE_P1, MOVE, OPERATION, OPERATION_P1,
						BRANCH, BZERO_CHECK, BNEG_CHECK,
						COUNTER_UP, RESET_STATE, HALT);
	type mem is array(8 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type register_structure is array(3 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	
	signal current_state : state;
	
	signal memory_values : mem := ("0000000000000111", --7
											 "0000000000000111",
											 "1111111111111111", --end of program
											 "0010000000000011",
											 "1000000000000110", --branch check
											 "0100000000010010", --sub reg0 and reg1 storing result at reg2
											 "0011000000010010", --add reg0 and reg1 storing result at reg2
											 "0000000001001000", 
											 "0000000000000111");
											 
	signal registers : register_structure;
	signal sg_address : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal sg_counter : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	signal sg_store_value : STD_LOGIC_VECTOR(15 downto 0);
	
	signal ir : STD_LOGIC_VECTOR(15 downto 0);     --instruction register
	signal pc : STD_LOGIC_VECTOR(4 downto 0) := "00000";     --program counter
	signal sg_op_code : STD_LOGIC_VECTOR(3 downto 0); --operation code
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
					current_state <= CHECK_COUNTER;
					
				when CHECK_COUNTER => 
					if memory_values'length = 0 then
						current_state <= HALT;
					elsif to_integer(unsigned(sg_counter)) = (memory_values'length) then
						current_state <= IDLE;
					else
						current_state <= CONFIGURATE;
					end if;
					
				when CONFIGURATE =>	
					current_state <= WRITE_MEM;
					
				when WRITE_MEM =>
					current_state <= INCREMENT;
				
				when INCREMENT =>
					current_state <= CHECK_COUNTER;
				
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
							current_state <= MOVE;
					
						when "0011" => --ADD
							current_state <= OPERATION;
							
						when "0100" => --SUB
							current_state <= OPERATION;
						
						when "0101" => --AND
							current_state <= OPERATION;
						
						when "0110" => --OR
							current_state <= OPERATION;
						
						when "0111" => --BRANCH
							current_state <= BRANCH;
						
						when "1000" => --BZERO
							current_state <= BZERO_CHECK;
						
						when "1001" => --BNEG
							current_state <= BNEG_CHECK;
						
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
				
				when STORE_P1 =>
					current_state <= COUNTER_UP;
										
				when MOVE =>
					current_state <= COUNTER_UP;
					
				when OPERATION =>
					current_state <= OPERATION_P1;
					
				when OPERATION_P1 =>
					current_state <= COUNTER_UP;
					
				when BRANCH =>
					current_state <= DECODE; --doesn't increment program counter
				
				when BZERO_CHECK =>
					if to_integer(unsigned(registers(3))) = 0 then --tests if result register equals zero
						current_state <= BRANCH;
					else
						current_state <= COUNTER_UP;
					end if;
				
				when BNEG_CHECK =>
					if to_integer(signed(registers(3))) < 0 then --tests if result register equals zero
						current_state <= BRANCH;
					else
						current_state <= COUNTER_UP;
					end if;
				
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
		
			when CHECK_COUNTER =>
		
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
				sg_op_code <= instruction(15 downto 12);	
				
			when LOAD =>
				address <= ir(4 downto 0); --bit 5 is not used because memory ony has 32 positions so 2^5 is enough
				
			when LOAD_P1 =>
				registers(to_integer(unsigned(ir(11 downto 6)))) <= instruction;
				
			when STORE =>
				address <= ir(9 downto 5);
				store_value <= "1010" & registers(to_integer(unsigned(ir(4 downto 0))))(11 downto 0);
				write_value <= '1';
				
			when STORE_P1 =>
				write_value <= '0';
				
			when MOVE =>
				registers(to_integer(unsigned(ir(4 downto 0)))) <= registers(to_integer(unsigned(ir(11 downto 5))));
				
			when OPERATION =>
				a <= registers(to_integer(unsigned(ir(11 downto 8))));
				b <= registers(to_integer(unsigned(ir(7 downto 4))));
				op_code <= sg_op_code;
			
			when OPERATION_P1 =>
				registers(to_integer(unsigned(ir(3 downto 0)))) <= result;
				registers(3) <= result; --stores ALU result at the special register
			
			when COUNTER_UP =>
				pc <= std_logic_vector(unsigned(pc) + 1);
				address <= std_logic_vector(unsigned(pc) + 1);
				
			when BRANCH => --all branch states use this if the check is true because they follow the same pattern
				pc <= ir(4 downto 0);
				address <= ir(4 downto 0);
				
			when BZERO_CHECK =>
			
			when BNEG_CHECK =>
			
			when RESET_STATE =>
			
			when HALT =>
				
		end case;
		
	end process;

end Behavioral;

