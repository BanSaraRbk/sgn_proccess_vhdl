
   output_write_process : process(clk_0)
   file my_output_file : text open write_mode is "output_normilzed_signal.txt";

   variable output_line : line;
      begin
       
         integerr<=to_integer(signed(signal_normalize_0));
      if(rising_edge(clk_0))then
        
            write(output_line,integerr);
            writeline(my_output_file, output_line);
            report "this is a message"; 

         end if;
end process;
