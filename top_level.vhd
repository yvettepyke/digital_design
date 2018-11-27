library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;


entity top_level is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              n : natural := 5; --width of matrix B
              h : natural := 4; --height of matrix A  
              datasize : natural := 5);  
    Port ( clk : in std_logic;
           rst : in std_logic; --signal from reset button
           nxt : in std_logic; --signal from next button
           output : out std_logic_vector (datasize*2 + m-2 downto 0));
            --coefficient of matrix C at a position
end top_level;

architecture Behavioral of top_level is
    signal deb_rst, deb_nxt : std_logic;
     --debounced signals from reset and next buttons
    signal Aadrsint : UNSIGNED (log2(h*m)-1 downto 0);
     --address for coefficient at position h,m in matrix A
    signal Badrsint : UNSIGNED (log2(m*n)-1 downto 0);
     --address for coefficient at position m,n in matrix B
    signal RAMadrsint : UNSIGNED (log2(h*n)-1 downto 0);
     --address for coefficient at position h,n in matrix C
    signal enMacc : std_logic;   --MACC enable signal
    signal rstMacc : std_logic;  --reset MACC
    signal write_en : std_logic; --RAM write enable
begin

reset_debouncer : entity work.debouncer
port map (
    clk => clk,
    sig => rst,
    deb_sig => deb_rst);
    
next_debouncer : entity work.debouncer
port map (
    clk => clk,
    sig => nxt,
    deb_sig => deb_nxt);
    
control_logic : entity work.control_logic
generic map (
    m => m,
    n => n,
    h => h)
port map (
    clk => clk,
    nxt => deb_nxt,
    rst => deb_rst,
    Aadrs => Aadrsint,
    Badrs => Badrsint,
    Cadrs => RAMadrsint,
    enMacc => enMacc,
    rstMacc => rstMacc,
    write_en => write_en);

datapath : entity work.datapath
generic map (
    m => m,
    n => n,
    h => h,
    datasize => datasize)
port map (
    clk => clk,
    Aadrs => Aadrsint,
    Badrs => Badrsint,
    RAMadrs => RAMadrsint,
    enMacc => enMacc,
    rstMacc => rstMacc,
    write_en => write_en,
    output => output);

end Behavioral;
