library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity sync_ram is 
port(
	clock : in std_logic;
	we: in std_logic;
	address : in std_logic_vector (7 downto 0);
	datain: in std_logic_vector (31 downto 0);
	dataout: out std_logic_vector (31 downto 0)
);
end SyncRAM;

architecture Behavioral of sync_ram is

	-- Define o tamanho da memória
	type ram_type is array (0 to 2**(address'length)-1) of std_logic_vector(datain'range);
	signal ram: ram_type;
	signal read_address : std_logic_vector(address'range);

begin 

	RamProc: process(clock)
	begin
	-- Caracteriza a memória como síncrona
		if clock'Event and clock = '1' then
			if we = '1' then
				ram(to_integer(unsigned(address))) <= datain;
			end if;
			read_address<=address;
		end if;
	end process RamProc;
	
	-- Saída assíncrona , sempre dreando valores na saída
	dataout<= ram(to_integer(unsigned(address)));

end Behavioral;
