library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.all; -- Library required for log2 function


--control logic for the matrix multiplier. contains a mealy finite state
-- machine, 3 parameterizable counters, and a combinational logic block
entity control_logic is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              n : natural := 5; --width of matrix B
              h : natural := 4);--height of matrix A
    Port ( clk : in std_logic;
           nxt : in std_logic; --debounced signal from nxt button
           rst : in std_logic; --debounced singal from rst button
           Aadrs : out UNSIGNED (log2(h*m)-1 downto 0);
            --address for coefficient at position h,m in matrix A
           Badrs : out UNSIGNED (log2(m*n)-1 downto 0);
            --address for coefficient at position m,n in matrix B
           Cadrs : out UNSIGNED (log2(h*n)-1 downto 0);
            --address for coefficient at position h,n in matrix C
           enMacc : out std_logic;    --MACC enable signal
           rstMacc : out std_logic;   --reset MACC
           write_en : out std_logic); --RAM write enable
           
end control_logic;

architecture Behavioral of control_logic is

    signal enM, enN, enH : std_logic; --internal enable signals for counters
    signal mCnt : UNSIGNED (size(m)-1 downto 0); --position within m
    signal nCnt : UNSIGNED (size(n)-1 downto 0); --position within n
    signal hCnt : UNSIGNED (size(h)-1 downto 0); --position within h
    signal Cint : UNSIGNED (log2(h*n)-1 downto 0);
     --internal signal for Cadrs

begin

--mealy finite state machine, synchronous write, asynchronous read
finite_state_machine : entity work.fsm
generic map (
    m => m, --height of matrix B and width of matrix A
    n => n,
    h => h)
port map (
    clk => clk,
    nxt => nxt,  --deboucned signal from nxt button
    rst => rst,  --debounced signal from rst button
    mcnt => mcnt,--position within m
    ncnt => ncnt,--position within n
    hcnt => hcnt,--position within h
    Cadrs => Cint,
     --address for coefficient at position h,n in matrix C
    enM => enM,  --m counter enable signal
    enN => enN,  --n counter enable signal
    enH => enH,  --h counter enable signal
    write_en => write_en,--write enable for RAM
    enMacc => enMacc,    --MACC enable signal
    rstMacc => rstMacc); --MACC reset signal

--parameterizable counter to determine mcnt
m_counter : entity work.Param_Counter
generic map (
    LIMIT => m) --height of matrix B and width of matrix A
port map (
    clk => clk,
    rst => rst, --debounced signal from reset button
    en => enM,  --m counter enable signal
    count_out => mcnt); --position within m

--parameterizable counter to determine ncnt
n_counter : entity work.Param_Counter
generic map (
    LIMIT => n) --width of matrix B
port map (
    clk => clk,
    rst => rst, --debounced signal from reset button
    en => enN,  --n counter enable signal
    count_out => ncnt); --position within n
    
--parameterizable counter to determine hcnt    
h_counter : entity work.Param_Counter
generic map (
    LIMIT => h) --height of matrix A
port map (
    clk => clk,
    rst => rst, --debounced signal from reset button
    en => enH,  --h counter enable signal
    count_out => hcnt); --position within h
    
--combinational logic block to output addresses to the ROMs and RAM    
combinational_logic_block : entity work.addresses_combinational_logic
generic map (
    m => m, --height of matrix B and width of matrix A
    n => n, --width of matrix B
    h => h) --height of matrix A
port map (
    mcnt => mcnt,
    ncnt => ncnt,
    hcnt => hcnt,
    Aadrs => Aadrs,
    Badrs => Badrs,
    Cadrs => Cint);
    
Cadrs <= Cint;

end Behavioral;