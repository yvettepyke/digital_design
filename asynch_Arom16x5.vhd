library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--NON PARAMETERIZABLE ROM FOR MATRIX A (4x3)
--Asynchronous read
entity asynch_Arom16x5 is
    Port ( Address : in UNSIGNED (3 downto 0);
           DataOut : out STD_LOGIC_VECTOR (4 downto 0));
end asynch_Arom16x5;

architecture Behavioral of asynch_Arom16x5 is

type ROM_ARRAY is array (0 to 15) of STD_LOGIC_VECTOR (4 downto 0);
    constant Content: ROM_ARRAY := (
        0 => B"00000", -- value: 0; position: 0,0
        1 => B"00000", -- value: 0; position: 0,1
        2 => B"00000", -- value: 0; position: 0,2
        3 => B"00001", -- value: 1; position: 1,0
        4 => B"00001", -- value: 1; position: 1,1
        5 => B"00001", -- value: 1; position: 1,2
        6 => B"11111", -- value: -1; position: 2,0
        7 => B"11111", -- value: -1; position: 2,1
        8 => B"11111", -- value: -1; position: 2,2
        9 => B"01111", --  value: f; position: 3,0
        10 => B"01111", -- value: f; position: 3,1
        11 => B"01111", -- value: f; position: 3,2
        others => B"00000");

begin

DataOut <= Content(to_integer(Address));

end Behavioral;
