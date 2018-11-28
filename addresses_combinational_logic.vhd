library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.all; -- Library required for log2 function


--combinational logic block to determine addresses for the ROMs
-- that are storing the coefficients of the matrices and the RAM
-- that stores the product of these coefficients by way of the 
-- m,n,and h counters.
entity addresses_combinational_logic is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              n : natural := 5; --width of matrix B
              h : natural := 4);--height of matrix A
    Port ( mcnt : in UNSIGNED (size(m)-1 downto 0); --position within m
           ncnt : in UNSIGNED (size(n)-1 downto 0); --position within n
           hcnt : in UNSIGNED (size(h)-1 downto 0); --position within h
           nxt : in std_logic;
           rst : in std_logic;
           Aadrs : out UNSIGNED (log2(h*m)-1 downto 0);
            --address for coefficient at position h,m in matrix A
           Badrs : out UNSIGNED (log2(m*n)-1 downto 0);
            --address for coefficient at position m,n in matrix B
           Cadrs : inout UNSIGNED (log2(h*n)-1 downto 0));
            --address for coefficient at position h,n in matrix C
           
end addresses_combinational_logic;

architecture Behavioral of addresses_combinational_logic is

begin

Aadrs <= resize(m*resize(hcnt, size(m)) + mcnt, log2(h*m));
Badrs <= resize(resize(mcnt, size(n))*n + ncnt, log2(m*n));
Cadrs <= resize(n*resize(hcnt, size(n)) + ncnt, log2(h*n)) when nxt = '1' else
         (others => '0') when rst = '1' else
         Cadrs; --does not advance C address 
                -- until the "next" button is pressed
 

end Behavioral;
