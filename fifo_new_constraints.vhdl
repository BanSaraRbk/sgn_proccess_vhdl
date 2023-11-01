
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.std_logic_signed.all
use std.textio.all;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fifoo is
--  Port ( );

  generic (
   DATA_WIDTH   : integer := 14;
   DATA_WIDTH_DEPTH   : integer := 4096
  );
  port (
    adc_clk_p_i : in std_logic;
    adc_clk_n_i : in std_logic;
    led_o      :out std_logic_vector(8 downto 0);
    adc_dat_a_i   : in  std_logic_vector( DATA_WIDTH-1 downto 0);
--    adc_dat_b_i   : in  std_logic_vector( DATA_WIDTH-1 downto 0);
    dac_dat_o        :out std_logic_vector(DATA_WIDTH-1 downto 0);
    dac_wrt_o: out  std_logic ;
    dac_rst_o:out  std_logic ;
    dac_clk_o: out std_logic ;
   
    dac_sel_o:out  std_logic;
    moove        :out std_logic_vector(DATA_WIDTH-1 downto 0) 
   );
  
end fifoo;

architecture Behavioral of fifoo is
    signal rst        :  std_logic;
    signal clk:std_logic;
    signal empty        :std_logic;
    signal full :  std_logic;
    signal fifo_data: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal  cnt: integer:=0;
    signal wr_en:std_logic;
    signal rd_en:std_logic;
    signal adc_clk_in :std_logic;
 
        signal moving_avg_good: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);

    type parameter is array (1 to 12) of integer;
    signal param : parameter := (1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12);

 
COMPONENT fifo_generator_0
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
--    almost_empty : OUT STD_LOGIC
  );
END COMPONENT;
begin

fifo1 :fifo_generator_0
  PORT MAP (
    clk => clk,
    srst => rst,
    din => adc_dat_a_i,
    dout => fifo_data,
    full=>full,
    empty=>empty,
    wr_en=>wr_en,
    rd_en=>rd_en

   
  );
ex :IBUFDS port map (  I  => adc_clk_p_i, IB => adc_clk_n_i,O  => clk);

buf:  BUFG port map( O=>  clk, I=> adc_clk_in);
             
SRL16E_inst : SRL16
generic map (
   INIT => X"1111")
port map ( Q => rst,   A0 => '0',   A1 => '1',  A2 => '0',  A3 => '0',   CLK => clk,    D => '0' );



clk_oddr : ODDR  port map(Q => dac_clk_o, D1 => '0', D2 => '1', C => clk, CE => '1', R => '0', S => '0');
sel_oddr : ODDR  port map(Q => dac_sel_o, D1 => '0', D2 => '1', C => clk, CE => '1', R => '0', S => '0');
wrt_oddr : ODDR port map (Q => dac_wrt_o, D1 => '1', D2 => '1', C => clk, CE => '1', R => '0', S => '0');
rst_oddr : ODDR port map (Q => dac_rst_o, D1 => '0', D2 => '0', C => clk, CE => '1', R => '0', S => '0');






GEN:
    for j in 0 to 13 generate
      DAC_DAT_inst : ODDR
      port map (
        Q => dac_dat_o(j),
        D1 => moving_avg_good(j),
        D2 => adc_dat_a_i(j),
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
  end generate GEN;
 
  
--  clk<=adc_clk_p_i and adc_clk_n_i;
  
   process (clk,rst) is
   
    variable sum: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable moving_avg: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
--    variable moving_avg_good: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    begin

            if (rst='1') then
--                data_out<=(others =>'0');
                sum:=(others =>'0');
                 wr_en<='0';
                rd_en<='0';
--                dac_dat_o<=(others=>'0');
                moving_avg:=(others=>'0');
                moving_avg_good<=(others=>'0');
                moove<=(others=>'0');
                
               cnt <= 2 ** param(3) - 2;
--                cnt <=6;
                  
            elsif rising_edge(clk) then
            
--     
            
            
             
                wr_en<='1';
           
                sum := std_logic_vector(signed(sum) + signed(adc_dat_a_i) - signed(fifo_data));
--                        sum <= std_logic_vector( unsigned(data_in));
        
--               data_out<=(others =>'0'); 
                if(cnt>0) then 
                rd_en<='0';
                cnt<=cnt-1;
                else 
                rd_en<='1';
                    
                 end if;   
             
          
           moving_avg := std_logic_vector(shift_right (signed (sum), param(3)));
           moving_avg_good <=moving_avg(13 downto 0);
           moove<=moving_avg_good;
          
      
            
                      end if;
     
                    
           end process;
             

  
  
        


end Behavioral;

