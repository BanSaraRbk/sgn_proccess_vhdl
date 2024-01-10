library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MovingAverageFilter is
    Port (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        i_data: in STD_LOGIC_VECTOR(7 downto 0);  -- Input data (8-bit, adjust as needed)
        o_moving_average: out STD_LOGIC_VECTOR(7 downto 0)  -- Output moving average
    );
end MovingAverageFilter;

architecture Behavioral of MovingAverageFilter is
    constant FIFO_DEPTH: integer := 4;  -- Adjust depth as needed
    signal fifo_data: STD_LOGIC_VECTOR(7 downto 0);
    signal sum: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Initialize the FIFO buffer and sum to zero
            fifo_data <= (others => '0');
            sum <= (others => '0');
        elsif rising_edge(clk) then
            -- Shift data into the FIFO
            fifo_data <= i_data & fifo_data(FIFO_DEPTH-1 downto 1);

            -- Calculate the moving average
            sum <= sum + i_data - fifo_data(FIFO_DEPTH-1);

            -- Output the moving average
            o_moving_average <= sum;
        end if;
    end process;
end Behavioral