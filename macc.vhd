library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--MULTIPLY ACCUMULATE UNIT
--Takes subsequent values of A*B and adds them together
entity macc is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              datasize : natural := 5);
    Port ( A : in STD_LOGIC_VECTOR (datasize-1 downto 0);
            --input from ROM for matrix A
           B : in STD_LOGIC_VECTOR (datasize-1 downto 0);
            --input from ROM for matrix B
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
            --reset signal
           en : in STD_LOGIC;
            --enable signal
           P : out STD_LOGIC_VECTOR (datasize*2 + m-2 downto 0));
            --output
end macc;

architecture Behavioral of macc is
    signal Aint, Bint : SIGNED (datasize-1 downto 0);
     --internal signals of A and B
    signal Cint, Pint : SIGNED (datasize*2 + m-2 downto 0);
     --Cint is Aint*Bint, Pint is the internal signal for P
begin

Aint <= signed(A);
Bint <= signed(B);

Pint <= Aint*Bint + Cint when en = '1' else
        to_signed(0, datasize*2 + m-1) when rst = '1' else
        Cint;

REG: process (clk) 
begin
    if (rising_edge(clk)) then
        if (rst = '1') then
            Cint <= (others => '0');
        elsif (en = '1') then
            Cint <= Pint;
        end if;
    end if;
end process REG;
        
P <= std_logic_vector(Pint);

end Behavioral;
