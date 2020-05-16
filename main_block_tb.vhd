-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

         component main_block is
			Port ( reset : in  STD_LOGIC;
					 clock : in  STD_LOGIC);
			end component;

         SIGNAL reset :  std_logic;
         SIGNAL clock :  std_logic;
          
			constant clock_period : time := 10 ns;

  BEGIN

		uut : main_block 
		port map (
			reset => reset,
			clock => clock
		);

    clock_process :process
		begin
			clock <= '0';
			wait for clock_period/2;
			clock <= '1';
			wait for clock_period/2;
		end process;
		
		reset <= '0';

  END;
