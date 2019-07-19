--74280 9-bit odd/even parity generators/checkers
--
--component SN74280 is
--	port(
--	d:		in std_logic_vector(8 downto 0);
--	
--	even:	out std_logic;
--	odd:	out std_logic);
--end component SN74280;

--u280: SN74280 port map (
--	d => D,
--	
--	even => EVEN,
--	odd => ODD
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74280 is
	port(
	d:		in std_logic_vector(8 downto 0);
	
	even:	out std_logic;
	odd:	out std_logic);
end SN74280;

architecture chip of SN74280 is
	signal par:		std_logic;
begin

par <= d(0) xor d(1) xor d(2) xor d(3) xor d(4) xor d(5) xor d(6) xor d(7) xor d(8);
odd <= par;
even <= not(par);

end chip;