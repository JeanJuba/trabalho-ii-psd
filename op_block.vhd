library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity op_block is
port (
	clock : in STD_LOGIC;
	a : in STD_LOGIC_VECTOR(15 downto 0);
	b : in STD_LOGIC_VECTOR(15 downto 0);
	op_code : in STD_LOGIC_VECTOR(3 downto 0);
	result : out STD_LOGIC_VECTOR(15 downto 0));
end op_block;

architecture Behavioral of op_block is

begin
	
	process(clock)
	begin
	
		case op_code is
		
			when "0011" => --ADD
				result <= a + b;
				
			when "0100" => --SUB
				result <= a - b;
			
			when "0101" => --AND
				result <= a AND b;
				
			when "0110" => --OR
				result <= a OR b;
				
			when others =>
				result <= "0000000000000000";
			
		end case;
		
	end process;
	
end Behavioral;

