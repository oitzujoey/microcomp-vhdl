--7486 quadruple 2-input positive-xor gates
--
--component SN7486 is
--	port(
--	a:	in std_logic_vector(3 downto 0);
--	b:	in std_logic_vector(3 downto 0);
--	
--	y:	out std_logic_vector(3 downto 0));
--end component SN7486;

--u32: SN7486 port map(
--	a => A,
--	b => B,
--	
--	y => Y);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7486 is
	port(
	a:	in std_logic_vector(3 downto 0);
	b:	in std_logic_vector(3 downto 0);
	
	y:	out std_logic_vector(3 downto 0));
end SN7486;

architecture chip of SN7486 is
	
begin

y <= a xor b;

end chip;