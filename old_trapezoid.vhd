library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trapezoidal_filter is
    generic (
        DATA_WIDTH : integer := 14;
        LENGTH : integer := 800;
        L : integer := 10;
        G : integer := 0
    );
    port (
        clk : in std_logic;
        wave : in std_logic_vector(DATA_WIDTH-1 downto 0);
        trapezoid : out std_logic_vector(DATA_WIDTH-1 downto 0);
        trigger_in : in std_logic
    );
end trapezoidal_filter;

architecture Behavioral of trapezoidal_filter is
    signal wave_int : integer;
    signal result : integer := 0;
    type memory_array is array (0 to LENGTH-1) of integer;
    signal wave_mem : memory_array;


    type try_std_logic is array (0 to LENGTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal wave_mare : try_std_logic := (others => (others => '0'));

    signal number : integer := 0;
    signal sum_pos_out : integer := 0;
    signal sum_neg_out : integer := 0;
    signal wavee : integer := 0;
    signal test_k : integer := 0;
    signal test_j : integer := 0;

    signal j : integer := 0;
    -- signal k : integer := 0;
    signal index : integer := 0;
    signal try:integer:=0;
    --  signal sum_pos : integer := 0;
    -- signal sum_neg : integer := 0;

begin

    process(clk)
       variable sum_pos : integer := 0;
        variable sum_neg : integer := 0;
        variable tmp : integer := 0;
        variable k : integer := 0;
        variable k_count : integer := 0;
    begin
       
        wave_int <= to_integer(unsigned(wave));
        wave_mem(index) <= wave_int;
    
        if rising_edge(clk) then
            number <= 2 * L + G;
            wave_mare(index) <= wave;

            if trigger_in = '1'  then
               
                sum_neg := sum_neg - wave_mem(j + k);
                sum_pos := sum_pos + wave_mem(k + j + G + L);
                sum_pos_out <= sum_pos;
                sum_neg_out <= sum_neg;
                try<=k;
                if k < 9 then
                   
                    k := k + 1;
                else
                    k := 0;
                    sum_neg := 0;
                    sum_pos := 0;
            
                    if j < LENGTH - number - 1 then
                        j <= j + 1;
                    else
                        j <= 0;
                    end if;
                end if;
              
             
                test_k <= wave_mem(k);
                test_j <= wave_mem(j);
            
                   
                    
                    tmp := sum_neg + sum_pos;
                    wavee<=tmp;
                    trapezoid <= std_logic_vector(to_signed(tmp, DATA_WIDTH));
  
            end if;
        
        if index < LENGTH *2 then
            index <= index + 1;
        else
            index <= 0;
        end if;
        end if;
       

    end process;

end Behavioral;
