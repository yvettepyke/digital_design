library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL;

--datapath for the matrix multiplier. contains 2 ROMs, a multiply
-- accumulate unit, and a single port RAM.
entity datapath is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              n : natural := 5; --width of matrix B
              h : natural := 4; --height of matrix A  
              datasize : natural := 5);  
    Port ( clk : in std_logic;
           Aadrs : in UNSIGNED (log2(h*m)-1 downto 0);
            --address for coefficient at position h,m in matrix A
           Badrs : in UNSIGNED (log2(m*n)-1 downto 0);
            --address for coefficient at position m,n in matrix B
           RAMadrs : in UNSIGNED (log2(h*n)-1 downto 0);
            --address for coefficient at position h,n in matrix C
           enMacc : in std_logic;    --MACC enable signal
           rstMacc : in std_logic;   --reset MACC
           write_en : in std_logic; --RAM write enable
           output : out std_logic_vector (datasize*2 + m-2 downto 0));
            --coefficient of matrix C at a position                      
end datapath;

architecture Behavioral of datapath is
    signal A, B : std_logic_vector (datasize-1 downto 0);
     --outputs of the ROMs for matrices A and B
    signal P : std_logic_vector (datasize*2 + m-2 downto 0);
     --output of the MACC
begin

--NON PARAMETERIZABLE ROM FOR MATRIX A (4x3)
ROM_A : entity work.asynch_Arom16x5
port map (
    Address => Aadrs,
    DataOut => A );

--NON PARAMETERIZABLE ROM FOR MATRIX B (3x5)
ROM_B : entity work.asynch_Brom16x5
port map (
    Address => Badrs,
    DataOut => B );
    
--MULTIPLY ACCUMULATE UNIT
MACC : entity work.macc
generic map (
    m => m, --height of matrix B and width of matrix A
    datasize => datasize)
port map (
    clk => clk,
    rst => rstMacc,
    en => enMacc,
    A => A,
    B => B,
    P => P);

--single port ram for matrix C
RAM : entity work.single_port_RAM
generic map (
    m => m,
    n => n,
    h => h,
    datasize => datasize)
port map (
    clk => clk,
    write_en => write_en,
    data_in => P,
    address => RAMadrs,
    data_out => output);

end Behavioral;