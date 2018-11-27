
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
    wait for 100ns;
    wait until falling_edge(clk);
    rst <= '0';
    wait for clk_period*4;   
    rst <= '1';
    wait for clk_period*4;
    rst <= '0';
    
    for n in 0 to 799 loop
        nxt <= '1';
        wait for clk_period*4;
        nxt <= '0';
        wait for clk_period*4;
    end loop;
    
    rst <= '1';
    wait;
end process;

end Behavioral;
