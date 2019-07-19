--74257 Quadruple 2-Line-to-1-Line Data Selectors/Multiplexers with 3-State Outputs
--
--component SN74257 is
--	port(
--	noc:	in std_logic;
--	a:		in std_logic_vector(3 downto 0);
--	b:		in std_logic_vector(3 downto 0);
--	sel:	in std_logic;
--	
--	y:		out std_logic_vector(3 downto 0));
--end component SN74257;

--u257: SN74257 port map (
--	noc => NOC,
--	a => A,
--	b => B,
--	sel => SEL,
--
--	Y => Y
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74257 is
	port(
	noc:	in std_logic;
	a:		in std_logic_vector(3 downto 0);
	b:		in std_logic_vector(3 downto 0);
	sel:	in std_logic;
	
	y:		out std_logic_vector(3 downto 0));
end SN74257;

architecture chip of SN74257 is

signal notquitey:	std_logic_vector(3 downto 0);

begin

notquitey <= a when (sel = '0') else b;
y <= notquitey when (noc = '0') else "ZZZZ";

end chip;