----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2023 09:15:38 AM
-- Design Name: 
-- Module Name: dac_test - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;
--use IEEE.std_logic_signed.all
use ieee.numeric_std.all;
entity dac_test is
 Port (
 
   
    dac_dat_o :out std_logic_vector(13 downto  0);
    adc_clk_p_i : in std_logic;
    adc_clk_n_i : in std_logic;
    adc_dat_a_i :in std_logic_vector(13 downto  0);
    adc_dat_b_i :in std_logic_vector(13 downto  0);
    dac_clk_o: out std_logic ;
    dac_wrt_o: out  std_logic ;
    dac_sel_o:out  std_logic;
     led_o      :out std_logic_vector(8 downto 0);
    dac_rst_o:out  std_logic 
 
 
  );
end dac_test;

architecture Behavioral of dac_test is

signal clk: std_logic;

signal cnt: unsigned(13 downto 0);
--signal dac_wrt_o: std_logic ;
--signal dac_sel_o: std_logic ;
----signal dac_clk_o: std_logic ;
--signal dac_rst_o: std_logic ;
signal j : integer;

begin
ex :IBUFDS
port map (
  I  => adc_clk_p_i,
  IB => adc_clk_n_i,
  O  => clk
);

--process 
--variable i:integer ;
-- begin
  clk_oddr : ODDR
      port map (
        Q => dac_clk_o,
        D1 =>'0',
        D2 => '1',
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
    sel_oddr : ODDR
      port map (
        Q => dac_sel_o,
        D1 =>'0',
        D2 => '1',
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
  wrt_oddr : ODDR
      port map (
        Q => dac_wrt_o,
        D1 =>'1',
        D2 => '1',
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
     rst_oddr : ODDR
      port map (
        Q => dac_rst_o,
        D1 =>'0',
        D2 => '0',
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
GEN:
    for j in 0 to 13 generate
      DAC_DAT_inst : ODDR
      port map (
        Q => dac_dat_o(j),
        D1 =>  cnt(j),
        D2 => adc_dat_a_i(j),
        C => clk,
        CE => '1',
        R => '0',
        S => '0'
      );
 
  end generate GEN;
 
-- end process;
 
process (clk)
begin
    if rising_edge(clk) then
    cnt<=cnt+1;
            led_o(1)<=adc_dat_a_i(1);
            led_o(2)<=adc_dat_a_i(2);
            led_o(3)<=adc_dat_a_i(3);
             
            led_o(4)<=adc_dat_b_i(4);
            led_o(5)<=adc_dat_b_i(5);
            led_o(6)<=adc_dat_b_i(6);
            led_o(7)<=adc_dat_b_i(7);
            
    
    
    end if;
 
 end process;
 
 
end Behavioral;
