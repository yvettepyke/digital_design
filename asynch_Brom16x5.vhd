library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--NON PARAMETERIZABLE ROM FOR MATRIX B (3x5)
--Asynchronous read
entity asynch_Brom16x5 is
    Port ( Address : in UNSIGNED (3 downto 0);
           DataOut : out STD_LOGIC_VECTOR (4 downto 0));
end asynch_Brom16x5;

architecture Behavioral of asynch_Brom16x5 is

type ROM_Array is array (0 to 15) of std_logic_vector(4 downto 0);
    constant Content: ROM_Array := (
        0 => B"01111", --value: f; position: 0,0
        1 => B"01111", --value: f; position: 0,1
        2 => B"10000", --value: -10; position: 0,2
        3 => B"01111", --value: f; position: 0,3
        4 => B"01010", --value: a; position: 0,4
        5 => B"00000", --value: 0; position: 1,0
        6 => B"01111", --value: f; positoin: 1,1
        7 => B"10000", --value: -10; position: 1,2
        8 => B"10000", --value: -10; position: 1,3
        9 => B"01011", --value: b; position: 1,4
        10 => B"10001", --value: -f; position: 2,0
        11 => B"01111", --value: f; position: 2,1
        12 => B"10000", --value: -10; position 2,2
        13 => B"00010", --value: 2; position 2,3
        14 => B"00011", --value: 3; position: 2,4
        others => B"00000");
        

begin

DataOut <= Content(to_integer(Address));

end Behavioral;
