library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.all; 

entity control_logic_tb is
end control_logic_tb;

architecture Behavioral of control_logic_tb is
    
    constant n : natural := 5;
    constant h : natural := 4;
    constant m : natural := 3;
    constant clk_period : time := 10ns;
    signal nxt, rst, clk : std_logic;
    signal Aadrs : UNSIGNED (log2(h*m)-1 downto 0);
    signal Badrs : UNSIGNED (log2(m*n)-1 downto 0);
    signal Cadrs : UNSIGNED (log2(h*n)-1 downto 0);
    signal enMACC, rstMACC, write_en : std_logic;

begin

--unit under test
UUT : entity work.control_logic
generic map (
    m => m,
    n => n,
    h=> h)
port map (
    nxt => nxt,
    rst => rst,
    clk => clk,
    Aadrs => Aadrs,
    Badrs => Badrs,
    Cadrs => Cadrs,
    enMacc => enMacc,
    rstMacc => rstMacc,
    write_en => write_en);
    
-- Clock process
clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

--TEST
TEST : process
begin
    wait for 100ns;
    
    wait until falling_edge(clk);
    rst <= '1';
    wait for clk_period*2;
    rst <= '0';
    nxt <= '1';
    wait for clk_period*200;
    nxt <= '0';
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period*8;
    
    wait;
end process;


end Behavioral;
