--7400 quadruple 2-input positive-nand gates
--
--component SN7400 is
--	port(
--	a:	in std_logic_vector(3 downto 0);
--	b:	in std_logic_vector(3 downto 0);
--	
--	y:	out std_logic_vector(3 downto 0));
--end component SN7400;

--u0: SN7400 port map (
--	a => A,
--	b => B,
--	
--	y => Y
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN7400 is
	port(
	a:	in std_logic_vector(3 downto 0);
	b:	in std_logic_vector(3 downto 0);
	
	y:	out std_logic_vector(3 downto 0));
end SN7400;

architecture chip of SN7400 is
	
begin

y <= not (a and b);

end chip;