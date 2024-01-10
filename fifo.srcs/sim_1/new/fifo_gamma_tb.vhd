library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use ieee.numeric_std.all;

entity fifo_gamma_tb is
end fifo_gamma_tb;
architecture sim of fifo_gamma_tb is
  constant CLOCK_PERIOD : time := 5 ns; -- Adjust for your clock period

  -- Component instantiation for fifoo module
  component fifoo
    generic (
      DATA_WIDTH       : integer := 14;
      DATA_WIDTH_DEPTH : integer := 4096
    );
    port (
    rst        :in std_logic;
   in_clk     :in std_logic;
--   wr_en      : in std_logic;
--   rd_en        : in std_logic;
   data_in   : in  std_logic_vector( DATA_WIDTH-1 downto 0);


    moove        :out std_logic_vector(DATA_WIDTH-1 downto 0) );

  end component;

  signal rst_tb     : std_logic := '0';
  signal in_clk_tb  : std_logic := '0';
--  signal wr_en_tb   : std_logic := '0';
--  signal rd_en_tb   : std_logic := '0';
  signal data_in_tb : std_logic_vector(13 downto 0) := (others => '0');
--  signal data_out_tb: std_logic_vector(13 downto 0);
   
--  signal empty_tb   : std_logic;
  signal moove_tb   : std_logic_vector(13 downto 0);

  
begin
  -- Instantiate the fifoo module
  uut: fifoo
    generic map (
      DATA_WIDTH       => 14,
      DATA_WIDTH_DEPTH => 4096
    )
    port map (
      rst        => rst_tb,
      in_clk     => in_clk_tb,
      data_in    => data_in_tb,
      moove      => moove_tb

    );

  -- Clock process (10 ns period)
  process
  
       variable ch1 : integer;
        file dataFile : text;
        variable dataLine : line;
        variable  i : integer := 0;
  
  begin
    -- Initialize signals
    rst_tb <= '1';
    data_in_tb <= (others => '0');


    wait for 10 ns;
    rst_tb <= '0';

    file_open(dataFile, "data.txt", read_mode);
                    while not endfile(dataFile) loop
                        readline(dataFile, dataLine);
                        read(dataLine, ch1);
                         data_in_tb <= std_logic_vector(to_unsigned(ch1, 14));
                         in_clk_tb <= '0';
                         wait for CLOCK_PERIOD / 2;
                          in_clk_tb <= '1';
                          wait for CLOCK_PERIOD / 2;  
                         end loop;
    
    
        file_close(dataFile);
                
    wait for 3000 ns;
    wait;
  end process;

end sim;
