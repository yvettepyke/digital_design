
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_level_tb is
--  Port ( );
end top_level_tb;

architecture Behavioral of top_level_tb is
    constant clk_period : time := 10ns;
    constant m : natural := 3;
    constant n : natural := 5;
    constant h : natural := 4;
    constant datasize : natural := 5;
    signal nxt, rst, clk: std_logic;
    signal output : std_logic_vector (datasize*2 + m-2 downto 0);
    type test_vector_array is array (natural range <>) of integer;
    constant test_vectors : test_vector_array := (
        (0), (0), (0), (0), (0),
        (0), (45), (-48), (1), (24),
        (0), (-45), (48), (-1), (-24),
        (0), (675), (-720), (15), (360));
        --this is representative of the output Matrix
begin

--UNIT UNDER TEST
UUT : entity work.top_level
generic map (
    m => m,
    n => n,
    h => h,
    datasize => datasize)
port map (
    nxt => nxt,
    rst => rst,
    clk => clk,
    output => output);
    
-- Clock process
clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

--TEST PROCESS
TEST : process
begin
    --wait 100ns for global reset to finish
    wait for 100ns;
    wait until falling_edge(clk);
    
    --intialisation
    rst <= '0';
    nxt <= '0';
    wait for clk_period*4;   
    rst <= '1';
    wait for clk_period*4;
    rst <= '0';
    assert output = "000000000000"
    report "initialisation failed"
    severity failure;
    
    --test calculation
    for i in 0 to 19 loop
        nxt <= '1';
        wait for clk_period*4;
        nxt <= '0';
        wait for clk_period*4;
        assert to_integer(signed(output)) = test_vectors(i)
        report "incorrect coefficient of output matrix"
        severity error; 
        
        report "expected value = " &
        integer'image(test_vectors(i)) & ", actual value = " &
        integer'image(to_integer(signed(output))) & 
        " at position " & integer'image(i) & "."
        severity note;
    end loop;
    
    --test freezing
    for i in 0 to 3 loop
        nxt <= '1';
        wait for clk_period*4;
        nxt <= '0';
        wait for clk_period*4;       
        assert to_integer(signed(output)) = test_vectors(19)
        report "failed to freeze after output matrix was fully calculated"
        severity failure;
    end loop;
    report "succeeded at freezing after output matrix was fully calculated"
    severity note;
    
    --test reset
    rst <= '1';
    wait for clk_period*4;
    rst <= '0';
    assert output = "000000000000"
    report "reset failed"
    severity failure;
    report "successful reset"
    severity note;
    
    --test restart after reset
    for i in 0 to 19 loop
        nxt <= '1';
        wait for clk_period*4;
        nxt <= '0';
        wait for clk_period*4;
        assert to_integer(signed(output)) = test_vectors(i)
        report "incorrect coefficient of output matrix. expected value = " &
        integer'image(test_vectors(i)) & ", actual value = " &
        integer'image(to_integer(signed(output))) & 
        " at position " & integer'image(i) & "."
        severity failure;
    end loop;
    report "restart after reset successful"
    severity note;
    
    wait;
end process;

end Behavioral;
