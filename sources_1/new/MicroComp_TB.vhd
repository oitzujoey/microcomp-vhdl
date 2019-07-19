----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2018 11:12:10 PM
-- Design Name: 
-- Module Name: MicroComp_TB - Behavioral
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
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MicroComp_TB is
--  Port ( );
end MicroComp_TB;

architecture Behavioral of MicroComp_TB is
    component MicroComp
        port(
        sw:     in std_logic_vector(15 downto 0);
        clk:    in std_logic;
        btnC:   in std_logic;
        
        led:    out std_logic_vector(15 downto 0);
        an:     out std_logic_vector(3 downto 0));
    end component;
    
    constant clk_period:    time := 1ns;
    
    signal sw:      std_logic_vector(15 downto 0) := "1010101001010101";
    signal clk:     std_logic := '0';
    signal reset:   std_logic := '1';
    signal led:     std_logic_vector(15 downto 0);
    signal an:      std_logic_vector(3 downto 0);
begin

process begin
    wait for 10*clk_period;
    reset <= '0';
end process;

process begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

u1: MicroComp port map(
    sw => sw,
    clk => clk,
    btnC => reset,
    
    led => led,
    an => an
);

end Behavioral;
