--74373 Octal Transparent Latch With 3-State Outputs
--
--component SN74373 is
--	port(
--	cp:		in std_logic;
--	d:		in std_logic_vector(7 downto 0);
--	noe:	in std_logic;
--	
--	q:		out std_logic_vector(7 downto 0));
--end component SN74373;

--u373: SN74373 port map (
--	cp => CP,
--	d => D,
--	noe => NOE,
--
--	q => Q
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74373 is
	port(
	cp:		in std_logic;
	d:		in std_logic_vector(7 downto 0);
	noe:	in std_logic;
	
	q:		out std_logic_vector(7 downto 0));
end SN74373;

architecture chip of SN74373 is

signal notquiteq:	std_logic_vector(7 downto 0);

begin

q <= notquiteq when (noe = '0') else "ZZZZZZZZ";

reg: process (cp, d) is begin
	if (cp = '1') then
		notquiteq <= d;
	end if;
end process reg;

end chip;