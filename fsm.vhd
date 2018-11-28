library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.all; -- Library required for log2 function


--Mealy finite state machine
--synchronous write, asynchronous read
--this finite state machine goes through the matrices and calculates one
--coefficient of the output matrix when the next button is pressed. 
entity fsm is
    Generic (m : natural := 3; --height of matrix B and width of matrix A
             n : natural := 5; --width of matrix B
             h : natural := 4);--height of matrix A
    Port ( clk : in STD_LOGIC;
           nxt : in STD_LOGIC; --debounced next signal
           rst : in STD_LOGIC; --debounced reset signal
           mCnt : in UNSIGNED (size(m)-1 downto 0); --position within m
           nCnt : in UNSIGNED (size(n)-1 downto 0); --position within n
           hCnt : in UNSIGNED (size(h)-1 downto 0); --position within h
           Cadrs : in UNSIGNED (log2(h*n)-1 downto 0);
            --address for coefficient at position h,n in matrix C
            --used to determine when all the coefficients have been calculated
           enM : out STD_LOGIC; --m counter enable signal
           enN : out STD_LOGIC; --n counter enable signal
           enH : out STD_LOGIC; --h counter enable signal
           write_en : out STD_LOGIC; --RAM write enable
           enMACC : out STD_LOGIC; --MACC enable signal
           rstMACC : out STD_LOGIC); --reset MACC
end fsm;

--State Descriptions:
--PAUSE; In this state the MACC resets, everything else is set to 0
  --the fsm stays in this state until next is pressed, then it goes
  --to CALCCOEF. However, if the full output matrix has been calculated 
  --the fsm will freeze in this state.
--CALCCOEF; In this state the counter for m and the MACC are enabled
  --this goes through calculating the products of the currently
  --selected row and column of matrices A and B respectively and adding
  --them together. After the coefficient has been calculated (and mCnt 
  -- = M) the fsm goes to WRITE.
--WRITE; In this state write_en is set to '1' which takes the value
  --calculated by the MACC and writes it to the RAM. The state moves to
  --NEXTCOL unconditionally with the next clock cycle.
--NEXTCOL; In this state nCnt and the RAM address are incremented by 1
  --so that the next value in the output matrix can be calculated from
  --the row of matrix A that we're on and the next column of matrix B.
  --If we have finished calculating the current row of the output matrix
  --(and nCnt = N) then the state moves to NEXTROW, otherwise the state
  --moves to PAUSE.
--NEXTROW; In this state hCnt and nCnt are incremented by 1. This is so
  --that we move to the next row on matrix A and rollover to the first
  --column of matrix B. The state moves to PAUSE unconditionally with
  --the next clock cycle.
architecture Behavioral of fsm is
    type fsm_states is (pause, calcCoef, write, nextCol, nextRow);
    signal state, next_state: fsm_states;
    signal not_done : std_logic; --signal to tell fsm when to freeze
begin

state_Assignment: process(clk) is
begin
    if rising_edge(clk) then
        if (rst = '1') then
            state <= pause;
        else
            state <= next_state;
        end if;
    end if;
end process state_assignment;

transitions: process (state, nxt, mCnt, nCnt, hCnt) is
begin
    case state is
        when pause =>
            if nxt = '1' and not_done = '1' then
                next_state <= calcCoef;
            else
                next_state <= state;
            end if;
        when calcCoef =>
            if mCnt = m-1 then
                next_state <= write;
            else
                next_state <= state;
            end if;
        when write =>
            if not_done = '1' then
                next_state <= nextCol;
            else 
                next_state <= pause;
            end if;
        when nextCol =>
            if nCnt = n-1 then
                next_state <= nextRow;
            else
                next_state <= pause;
            end if;
        when nextRow =>
            next_state <= pause;
    end case;
end process transitions;


--output values for each of the fsm states
enM <= '0' when state = pause else
    '1' when state = calcCoef else
    '0' when state = write else
    '0' when state = nextCol else
    '0' when state = nextRow;

enN <= '0' when state = pause else
    '0' when state = calcCoef else
    '0' when state = write else
    '1' when state = nextCol else
    '0' when state = nextRow;
    
enH <= '0' when state = pause else
    '0' when state = calcCoef else
    '0' when state = write else
    '0' when state = nextCol else
    '1' when state = nextRow;

write_en <= '0' when state = pause else
    '0' when state = calcCoef else
    '1' when state = write else
    '0' when state = nextCol else
    '0' when state = nextRow;
    
enMACC <= '0' when state = pause else
    '1' when state = calcCoef else
    '0' when state = write else
    '0' when state = nextCol else 
    '0' when state = nextRow;     
    
rstMACC <= '1' when state = pause else
    '0' when state = calcCoef else
    '0' when state = write else
    '0' when state = nextCol else --Don't Care
    '0' when state = nextRow;     --Don't Care
    
not_done <= '0' when Cadrs >= h*n-1 else '1';

end Behavioral;
