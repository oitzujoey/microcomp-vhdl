--74133 13-Input Positive-NAND Gates
--
--component SN74133 is
--	port(
--	d:		in std_logic_vector(12 downto 0);
--	
--	y:		out std_logic);
--end component SN74133;

--u133: SN74133 port map (
--	d => D,
--
--	Y => Y
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74133 is
	port(
	d:		in std_logic_vector(12 downto 0);
	
	y:		out std_logic);
end SN74133;

architecture chip of SN74133 is

begin

y <= not(d(0) and d(1) and d(2) and d(3) and d(4) and d(5) and d(6) and d(7) and d(8) and d(9) and d(10) and d(11) and d(12));

end chip;