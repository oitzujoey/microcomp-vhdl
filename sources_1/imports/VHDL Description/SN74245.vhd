--74245 Octal Bus Transceivers With 3-State Outputs
--
--component SN74245 is
--	port(
--	dir:	in std_logic;
--	noe:	in std_logic;
--	
--	a:		inout std_logic_vector(7 downto 0);
--	b:		inout std_logic_vector(7 downto 0));
--end component SN74245;

--u245: SN74245 port map (
--	dir => DIR,
--	noe => NOE,
--
--	a => A,
--	b => B
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74245 is
	port(
	dir:	in std_logic;
	noe:	in std_logic;
	
	a:		inout std_logic_vector(7 downto 0);
	b:		inout std_logic_vector(7 downto 0));
end SN74245;

architecture chip of SN74245 is

signal notquiteq:	std_logic_vector(7 downto 0);

begin

a <= b when ((noe = '0') and (dir = '0')) else "ZZZZZZZZ";
b <= a when ((noe = '0') and (dir = '1')) else "ZZZZZZZZ";

end chip;