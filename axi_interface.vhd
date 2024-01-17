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



entity fifoo is
  -- Port ( );

  generic (
    DATA_WIDTH      : integer := 14;
    DATA_WIDTH_DEPTH: integer := 4096
  );
  port (
    rst     : in std_logic;
     Number_samples : in  std_logic_vector(3 downto 0):= (others => '0');

    -- maxis slave interface (input)
    clk_i  : in std_logic;
    ms_axis_tready : out std_logic;
    ms_axis_tdata : in std_logic_vector(DATA_WIDTH-1 downto 0);
    ms_axis_tvalid : in std_logic;

    -- maxis master interface (output)
    mm_axis_tready : in std_logic;
    mm_axis_tdata   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    mm_axis_tvalid : out std_logic   
    
  );
end fifoo;

architecture Behavioral of fifoo is
  signal empty      : std_logic;
  signal full       : std_logic;
  signal fifo_data  : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal cnt        : integer := 0;
  signal wr_en      : std_logic;
  signal rd_en      : std_logic;
  signal moove : std_logic_vector(DATA_WIDTH - 1 downto 0);

  signal samples: integer;

  --type parameter is array (1 to 12) of integer;
 -- signal param: parameter := (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);

  COMPONENT fifo_generator_0
    PORT (
      clk     : IN STD_LOGIC;
      srst    : IN STD_LOGIC;
      din     : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
      wr_en   : IN STD_LOGIC;
      rd_en   : IN STD_LOGIC;
      dout    : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
      full    : OUT STD_LOGIC;
      empty   : OUT STD_LOGIC
      -- almost_empty : OUT STD_LOGIC
    );
  END COMPONENT;

begin
  fifo1: fifo_generator_0
    PORT MAP (
      clk   => clk_i,
      srst  => rst,
      din   => ms_axis_tdata,
      dout  => fifo_data,
      full  => full,
      empty => empty,
      wr_en => wr_en,
      rd_en => rd_en
    );

  process (clk_i, rst, ms_axis_tvalid,Number_samples) is
    variable sum            : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable moving_avg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    variable moving_avg_good: STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => '0');
  begin
 
    if (rst = '0') then
      sum          := (others => '0');
      wr_en        <= '0';
      rd_en        <= '0';
      moove        <= (others => '0');
      moving_avg   := (others => '0');
      cnt          <=2**TO_INTEGER (unsigned(Number_samples)) - 2;
      ms_axis_tready <= '0';
      mm_axis_tvalid <= '0';  
    elsif rising_edge(clk_i) then
      if ms_axis_tvalid = '1' then
        ms_axis_tready <= '1';
        
        wr_en <= '1';
        sum   := std_logic_vector(signed(sum) + signed(ms_axis_tdata) - signed(fifo_data));

        if (cnt > 0) then
          rd_en <= '0';
          cnt   <= cnt - 1;
        else
          rd_en <= '1';
        end if;

        moving_avg        := std_logic_vector(shift_right(signed(sum),TO_INTEGER (unsigned(Number_samples))));
        moving_avg_good   := moving_avg(13 downto 0);
        moove             <= moving_avg_good;
        mm_axis_tvalid <= '1';
      else
        wr_en <= '0';
      end if; 
    end if;
  end process;

  mm_axis_tdata<= moove when mm_axis_tready = '1' else (others=>'0');
end Behavioral;
