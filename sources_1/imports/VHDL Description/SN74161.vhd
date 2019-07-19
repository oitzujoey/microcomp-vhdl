--74161 synchronous 4-bit counters
--
--component SN74161 is
--	port(
--	clk:	in std_logic;
--	d:		in std_logic_vector(3 downto 0);
--	et:		in std_logic;
--	ep:		in std_logic;
--	nload:	in std_logic;
--	nclr:	in std_logic;
--	
--	q:		out std_logic_vector(3 downto 0);
--	rco:	out std_logic);
--end component SN74161;

--u161: SN74161 port map (
--	clk => CLK,
--	d => D,
--	et => ET,
--	ep => EP,
--	nload => NLOAD,
--	nclr => NCLR,
--	
--	q => Q,
--	rco => RCO
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity SN74161 is
	port(
	clk:	in std_logic;
	d:		in std_logic_vector(3 downto 0);
	et:		in std_logic;
	ep:		in std_logic;
	nload:	in std_logic;
	nclr:	in std_logic;
	
	q:		out std_logic_vector(3 downto 0);
	rco:	out std_logic);
end SN74161;

architecture chip of SN74161 is

signal notquiteq:	std_logic_vector(3 downto 0);

begin

q <= notquiteq;
rco <= not(not(notquiteq(3)) or not(notquiteq(2)) or not(notquiteq(1)) or not(notquiteq(0)) or not(et));

cnt: process (clk, nclr) is begin
	if (nclr = '0') then
		notquiteq <= "0000";
	elsif rising_edge(clk) then
		if (nload = '0') then
			notquiteq <= d;
		elsif ((ep = '1') and (et = '1')) then
			notquiteq <= notquiteq + 1;
		end if;
	end if;
end process cnt;

end chip;