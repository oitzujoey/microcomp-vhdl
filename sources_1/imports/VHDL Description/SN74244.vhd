--74244
--
--component SN74244 is
--	port(
--	a1:		in std_logic_vector(3 downto 0);
--	a2:		in std_logic_vector(3 downto 0);
--	noc1:	in std_logic;
--	noc2:	in std_logic;
--	
--	y1:		out std_logic_vector(3 downto 0));
--	y2:		out std_logic_vector(3 downto 0));
--end component SN74244;

--u244: SN74244 port map (
--	a1 => A1,
--	a2 => A2,
--	noc1 => NOC1,
--	noc2 => NOC2,
--
--	y1 => Y1
--	y2 => Y2
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74244 is
	port(
	a1:		in std_logic_vector(3 downto 0);
	a2:		in std_logic_vector(3 downto 0);
	noc1:	in std_logic;
	noc2:	in std_logic;
	
	y1:		out std_logic_vector(3 downto 0);
	y2:		out std_logic_vector(3 downto 0));
end SN74244;

architecture chip of SN74244 is
	
begin

y1 <= a1 when (noc1 = '0') else "ZZZZ";
y2 <= a2 when (noc2 = '0') else "ZZZZ";

end chip;