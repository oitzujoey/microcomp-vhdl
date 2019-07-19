--74260 Dual 5-Input NOR Gate
--
--component SN74260 is
--	port(
--	d0:		in std_logic_vector(4 downto 0);
--	d1:		in std_logic_vector(4 downto 0);
--	
--	y0:		out std_logic;
--	y1:		out std_logic);
--end component SN74260;

--u260: SN74260 port map (
--	d0 => D0,
--	d1 => D1,
--
--	Y0 => Y0,
--	y1 => Y1
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74260 is
	port(
	d0:		in std_logic_vector(4 downto 0);
	d1:		in std_logic_vector(4 downto 0);
	
	y0:		out std_logic;
	y1:		out std_logic);
end SN74260;

architecture chip of SN74260 is

begin

y0 <= not(d0(0) or d0(1) or d0(2) or d0(3) or d0(4));
y1 <= not(d1(0) or d1(1) or d1(2) or d1(3) or d1(4));

end chip;