--74151 data selectors/multiplexors
--
--component SN74151 is
--	port(
--	d:		in std_logic_vector(7 downto 0);
--	strobe:	in std_logic;
--	sel:	in std_logic_vector(2 downto 0);
--	
--	y:		out std_logic;
--	w:		out std_logic);
--end component SN74151;

--u151: SN74151 port map (
--	d => D,
--	strobe => STROBE,
--	sel => SEL,
--	
--	y => Y,
--	w => W
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SN74151 is
	port(
	d:		in std_logic_vector(7 downto 0);
	strobe:	in std_logic;
	sel:	in std_logic_vector(2 downto 0);
	
	y:		out std_logic;
	w:		out std_logic);
end SN74151;

architecture chip of SN74151 is
	signal nsel:	      std_logic_vector(2 downto 0);
	signal notReallyY:     std_logic;
begin

notReallyY <= d(to_integer(unsigned(sel))) when (strobe = '0') else '1';
y <= notReallyY;
w <= not(notReallyY);

end chip;