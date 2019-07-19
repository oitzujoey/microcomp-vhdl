--7408 quadruple 2-input positive-and gates
--
--component SN7408 is
--	port(
--	a:	in std_logic_vector(3 downto 0);
--	b:	in std_logic_vector(3 downto 0);
--	
--	y:	out std_logic_vector(3 downto 0));
--end component SN7408;

--u8: SN7408 port map(
--	a => A,
--	b => B,
--	
--	y => Y);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7408 is
	port(
	a:	in std_logic_vector(3 downto 0);
	b:	in std_logic_vector(3 downto 0);
	
	y:	out std_logic_vector(3 downto 0));
end SN7408;

architecture chip of SN7408 is
	
begin

y <= a and b;

end chip;