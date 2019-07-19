--7404 Hex Inverters
--
--component SN7404 is
--	port(
--	a:	in std_logic_vector(5 downto 0);
--	
--	y:	out std_logic_vector(5 downto 0));
--end component SN7404;

--u4: SN7404 port map(
--	a => A,
--	
--	y => Y);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7404 is
	port(
	a:	in std_logic_vector(5 downto 0);
	
	y:	out std_logic_vector(5 downto 0));
end SN7404;

architecture chip of SN7404 is
	
begin

y <= not a;

end chip;