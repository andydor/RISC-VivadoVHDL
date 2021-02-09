----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2020 07:06:26 PM
-- Design Name: 
-- Module Name: CONST - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONST is
  Port ( intrare: in std_logic_vector(15 downto 0);
         SelC: in std_logic;
         iesire: out std_logic_vector(31 downto 0));
end CONST;

architecture Behavioral of CONST is

signal sign: std_logic_vector(15 downto 0);

begin

sign <= (others => intrare(15));

iesire <= x"0000" & intrare when SelC = '0' else 
          sign & intrare;
          
end Behavioral;