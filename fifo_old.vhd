----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2023 01:09:50 PM
-- Design Name: 
-- Module Name: fifoo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifoo is
--  Port ( );

  generic (
   DATA_WIDTH   : integer := 14;
   DATA_WIDTH_DEPTH   : integer := 4096
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
  
end fifoo;

architecture Behavioral of fifoo is
  
   signal fifo_data: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
   signal  cnt: integer:=0;
   signal wr_en:std_logic;
    signal rd_en:std_logic;
    
    signal gamma_signal : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    type parameter is array (1 to 12) of integer;
    signal param : parameter := (1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12);
    
--        type ch_vector is array (0 to 600) of integer;
--    signal index : ch_vector;
    
 
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
    clk => in_clk,
    srst => rst,
    din => data_in,
    dout => fifo_data,
    full=>full,
    empty=>empty,
    wr_en=>wr_en,
    rd_en=>rd_en

   
  );
  
  
   process (in_clk,rst) is
   
    variable sum: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable moving_avg: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable moving_avg_good: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');

    begin
            if (rst='1') then
                data_out<=(others =>'0');
                sum:=(others =>'0');
                 wr_en<='0';
                rd_en<='0';
                moove<=(others=>'0');
                moving_avg:=(others=>'0');
                
               cnt <= 2 ** param(3) - 2;
                
                  
            elsif rising_edge(in_clk) then
             
                wr_en<='1';
           
                sum := std_logic_vector(signed(sum) + signed(data_in) - signed(fifo_data));
--                        sum <= std_logic_vector( unsigned(data_in));
        
               data_out<=(others =>'0'); 
                if(cnt>0) then 
                rd_en<='0';
                cnt<=cnt-1;
                else 
                rd_en<='1';
                    
                 end if;   
             
          
           moving_avg := std_logic_vector(shift_right (signed (sum), param(3)));
           moving_avg_good :=moving_avg(13 downto 0);
            
                moove<=moving_avg_good;
            
            
      
            
                      
                
             end if;
                    
           end process;
             

  
  
        


end Behavioral;
