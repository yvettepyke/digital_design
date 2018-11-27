library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.ALL; 

--single port ram for matrix C
--synchronous write, asynchronous read
--width: datasize*2 + m-1 bits
--depth: h*n bits
entity single_port_RAM is
    Generic ( m : natural := 3; --height of matrix B and width of matrix A
              h : natural := 4; --height of matrix A
              n : natural := 5; --width of matrix B
              datasize : natural := 5);
    Port ( clk : in STD_LOGIC;
           write_en : in STD_LOGIC; --write enable signal
           data_in : in STD_LOGIC_VECTOR (datasize*2 + m-2 downto 0);
            --data in from the MACC
           address : in UNSIGNED (log2(h*n)-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (datasize*2 + m-2 downto 0));
            --coefficient of matrix c at a given position
end single_port_RAM;

architecture Behavioral of single_port_RAM is
    type ram_type is ---cont on next line
        array (0 to h*n-1) of std_logic_vector(datasize*2 + m-2 downto 0);
    signal my_ram: ram_type := ( others => (others => '0'));
begin

--asynchronous read
data_out <= my_ram(to_integer(address));

--synchronous write
process (clk)
begin
    if (rising_edge(clk)) then
        if (write_en = '1') then
            my_ram(to_integer(address)) <= data_in;
        end if;
    end if;
end process;

end Behavioral;
