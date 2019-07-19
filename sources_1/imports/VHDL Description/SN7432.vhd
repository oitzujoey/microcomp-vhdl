--7432 quadruple 2-input positive-or gates
--
--component SN7432 is
--	port(
--	a:	in std_logic_vector(3 downto 0);
--	b:	in std_logic_vector(3 downto 0);
--	
--	y:	out std_logic_vector(3 downto 0));
--end component SN7432;

--u32: SN7432 port map(
--	a => A,
--	b => B,
--	
--	y => Y);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7432 is
	port(
	a:	in std_logic_vector(3 downto 0);
	b:	in std_logic_vector(3 downto 0);
	
	y:	out std_logic_vector(3 downto 0));
end SN7432;

architecture chip of SN7432 is
	
begin

y <= a or b;

end chip;