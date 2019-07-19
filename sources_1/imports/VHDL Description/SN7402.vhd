--7402 quadruple 2-input positive-nor gates
--
--component SN7402 is
--	port(
--	a:	in std_logic_vector(3 downto 0);
--	b:	in std_logic_vector(3 downto 0);
--	
--	y:	out std_logic_vector(3 downto 0));
--end component SN7402;

--u2: SN7402 port map(
--	a => A,
--	b => B,
--	
--	y => Y);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7402 is
	port(
	a:	in std_logic_vector(3 downto 0);
	b:	in std_logic_vector(3 downto 0);
	
	y:	out std_logic_vector(3 downto 0));
end SN7402;

architecture chip of SN7402 is
	
begin

y <= not (a or b);

end chip;