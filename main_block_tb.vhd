  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use STD.textio.all;
  use ieee.std_logic_textio.all;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

         component main_block is
			Port (clock : in  STD_LOGIC;
					reset : in  STD_LOGIC;
					start : in STD_LOGIC;
					inputval : in STD_LOGIC_VECTOR(15 downto 0);
					nxtval : out STD_LOGIC;
					incoming : in STD_LOGIC);
			end component;
			
			SIGNAL sg_clock : std_logic;
         SIGNAL sg_reset : std_logic;
			SIGNAL sg_start : std_logic;
         SIGNAL sg_inputval : std_logic_vector(15 downto 0);
			SIGNAL sg_nxtval : std_logic;
         SIGNAL sg_incoming : std_logic := '0';
			 
			constant clock_period : time := 10 ns;

  BEGIN

		uut : main_block 
		port map (
		   clock => sg_clock,
			reset => sg_reset,
			start => sg_start,
			inputval => sg_inputval,
			nxtval => sg_nxtval,
			incoming => sg_incoming
		);

	clock_process :process
		begin
			sg_clock <= '0';
			wait for clock_period/2;
			sg_clock <= '1';
			wait for clock_period/2;
		end process;

   stimulus: process
	
		variable val: std_logic_vector(15 downto 0);
		file testcase: text;
		variable v_line: line;
		
		begin
			file_open(testcase,".\instructions.txt",read_mode);
			
			readline(testcase, v_line);
			while not endfile(testcase)
				loop	
					read(v_line, val);
					sg_inputval <= val;
					sg_incoming <= '1';
					wait until rising_edge(sg_nxtval);
					readline(testcase, v_line);
				end loop;
			sg_incoming <= '0';
			file_close(testcase);
			wait for 4*clock_period;
			wait;
	end process;

  END;
