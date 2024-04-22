library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use ieee.numeric_std.all;

--architecture
---declarations
--components
 -- Testbench stimulus process

  constant CLOCK_PERIOD: time := 10 ns;
  process
       variable ch1 : integer;
        file dataFile : text;
        variable dataLine : line;
        variable  i : integer := 0;
  begin
    -- Initialize signals
    resetn <= '1';
    dIn <= (others => '0');

    wait for 10 ns;
    resetn <= '0';

    file_open(dataFile, "data.txt", read_mode);
         while not endfile(dataFile) loop
                readline(dataFile, dataLine);
                read(dataLine, ch1);
                dIn <= std_logic_vector(to_unsigned(ch1, 14));
                clk <= '0';
                wait for CLOCK_PERIOD / 2;
                clk <= '1';
                wait for CLOCK_PERIOD / 2;  
    end loop;

    file_close(dataFile);

    wait for 6000 ns;
    wait;
  end process;
