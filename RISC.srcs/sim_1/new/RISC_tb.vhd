----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2020 09:35:58 PM
-- Design Name: 
-- Module Name: RISC_tb - Behavioral
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

entity RISC_tb is
--  Port ( );
end RISC_tb;

architecture Behavioral of RISC_tb is

signal Clk, Rst, ZF, CF: std_logic := '0';
signal AdrInstr, Instr, Data, RA, RB, F: std_logic_vector(31 downto 0) := x"00000000";

constant CLK_PERIOD : TIME := 20 ns;

begin

clk_gen: process
begin
    Clk <= '0';
    wait for (clk_period/2);
    Clk <= '1';
    wait for (clk_period/2);
end process;

sim: process
begin
    wait for (clk_period);
    Rst <= '1';
    wait for (clk_period);
    Rst <= '0';
    wait for (clk_period);
    wait;
end process;

procesor: entity WORK.proc_RISC port map(Clk => Clk, Rst => Rst, AdrInstr => AdrInstr, Instr => Instr, Data => Data, RA => RA, RB => RB, F => F, ZF => ZF, CF => CF);

end Behavioral;