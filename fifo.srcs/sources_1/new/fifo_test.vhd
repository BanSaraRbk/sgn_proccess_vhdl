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

library ieee;
use ieee.std_logic_1164.all;
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

--  generic (
--   DATA_WIDTH   : integer := 14;
--   DATA_WIDTH_DEPTH   : integer := 2
--  );
  port (
   rst        :in std_logic;
   in_clk     :in std_logic;
   wr_en      : in std_logic;
   rd_en        : in std_logic;
   data_in   : in  std_logic_vector(13 downto 0);
   data_out    : out  std_logic_vector(13 downto 0); 
   full :       out  std_logic;
   empty        :out   std_logic );
  
end fifoo;

architecture Behavioral of fifoo is

--signal r_acc: signed (DATA_WIDTH + DATA_WIDTH_DEPTH-1 downto 0);  -- average accumulator


COMPONENT fifo
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
--    almost_empty : OUT STD_LOGIC
  );
END COMPONENT;
begin

fifo1 : fifo
  PORT MAP (
    clk => in_clk,
    srst => rst,
    din => data_in,
    dout => data_out,
    full=>full,
    empty=>empty,
    wr_en=>wr_en,
    rd_en=>rd_en

   
  );
  
  
--   process (in_clk) is
--            begin 
--                if(rising_edge (in_clk)) then
--                    if full='1' then 
--                        r_acc<=  signed(data_in)- data_in'length-1;
                    
                    
                    
--                    else
--                    end if;
--                 end if;
--             end process;
             

  
  



end Behavioral;
