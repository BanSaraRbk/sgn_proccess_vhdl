library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fifoo_tb is
end fifoo_tb;

architecture sim of fifoo_tb is
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
   data_out    : out  std_logic_vector(DATA_WIDTH-1 downto 0); 
   full :       out  std_logic;
   empty        :out   std_logic;
    moove        :out std_logic_vector(DATA_WIDTH-1 downto 0) );

  end component;

  signal rst_tb     : std_logic := '0';
  signal in_clk_tb  : std_logic := '0';
--  signal wr_en_tb   : std_logic := '0';
--  signal rd_en_tb   : std_logic := '0';
  signal data_in_tb : std_logic_vector(13 downto 0) := (others => '0');
  signal data_out_tb: std_logic_vector(13 downto 0);
  signal full_tb    : std_logic;
  signal empty_tb   : std_logic;
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
      data_out   => data_out_tb,
      full       => full_tb,
      empty      => empty_tb,
      moove      => moove_tb

    );

  -- Clock process (10 ns period)
  process
  begin
    while now < 1500 ns loop 
      in_clk_tb <= '0';
      wait for CLOCK_PERIOD / 2;
      in_clk_tb <= '1';
      wait for CLOCK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Testbench stimulus process
  process
  begin
    -- Initialize signals
    rst_tb <= '1';
    data_in_tb <= (others => '0');


    wait for 10 ns;
    rst_tb <= '0';


-- data_in_tb<= "00000001";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000010";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000011";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000100";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000101";  -- Input data
--wait for 10 ns;

-- data_in_tb<= "00000001";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000010";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000011";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000100";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000101";  -- Input data
--wait for 10 ns;

-- data_in_tb<= "00000001";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000010";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000011";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000100";  -- Input data
--wait for 10 ns;
-- data_in_tb<= "00000101";  -- Input data
wait for 10 ns;
--     data_in_tb<= "00000111";  -- Input data
--wait for 10 ns;  
--     data_in_tb<= "00001000";  -- Input data
--    data_in_tb <= "1000";
--    wait for 10 ns;
--    data_in_tb <= "1001";
--    wait for 10 ns;
--    data_in_tb <= "1010";
--    wait for 10 ns;
--    data_in_tb <= "1011";
--    wait for 10 ns;
--    data_in_tb <= "1100";
--    wait for 10 ns;
--    data_in_tb <= "1101";
--    wait for 10 ns;
--    data_in_tb <= "1110";
----    wait for 10 ns;
----    data_in_tb <= "1111";
data_in_tb <= "00000000000001"; -- -613
  wait for 10 ns;
data_in_tb <= "00000000000101"; -- -525
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -581
  wait for 10 ns;
data_in_tb <= "00000000000111"; -- -633
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -597
  wait for 10 ns;
data_in_tb <= "00000000000100"; -- -601
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -569
  wait for 10 ns;
data_in_tb <= "00000000000111"; -- -633
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -589
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -613
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -617
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -621
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -617
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -597
  wait for 10 ns;
data_in_tb <= "00000000000111"; -- -633
  wait for 10 ns;
data_in_tb <= "00000000000100"; -- -601
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -617
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -589
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -565
  wait for 10 ns;
data_in_tb <= "00000000000101"; -- -605
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -597
  wait for 10 ns;
data_in_tb <= "00000000000011"; -- -581
  wait for 10 ns;
data_in_tb <= "00000000000001"; -- -549
  wait for 10 ns;

    

    
    
    wait for 3000 ns;
    wait;
  end process;

end sim;
