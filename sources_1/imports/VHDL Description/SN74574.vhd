--74574 octal d-type flip-flop with 3-state outputs
--
--component SN74574 is
--	port(
--	clk:	in std_logic;
--	d:		in std_logic_vector(7 downto 0);
--	noe:	in std_logic;
--	
--	q:		out std_logic_vector(7 downto 0));
--end component SN74574;

--u574: SN74574 port map (
--	clk => CLK,
--	d => D,
--	noe => NOE,
--
--	q => Q
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74574 is
	port(
	clk:	in std_logic;
	d:		in std_logic_vector(7 downto 0);
	noe:	in std_logic;
	
	q:		out std_logic_vector(7 downto 0));
end SN74574;

architecture chip of SN74574 is

signal notquiteq:	std_logic_vector(7 downto 0);

begin

q <= notquiteq when (noe = '0') else "ZZZZZZZZ";

reg: process (clk) is begin
	if rising_edge(clk) then
		notquiteq <= d;
	end if;
end process reg;

end chip;