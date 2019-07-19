--74382 4-Bit Arithmetic Logic Unit
--
--component SN74382 is
--	port(
--	a:		in std_logic_vector(3 downto 0);
--	b:		in std_logic_vector(3 downto 0);
--	s:		in std_logic_vector(2 downto 0);
--	Cn:		in std_logic;
--	
--	Cn4:	out std_logic;
--	ovr:	out std_logic;
--	f:		out std_logic_vector(3 downto 0));
--end component SN74381;

--u382: SN74382 port map(
--	a => A,
--	b => B,
--	s => S,
--	Cn => CN,
--	
--	Cn4 => CN4,
--	ovr => OVR,
--	f => F);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74382 is
	port(
	a:		in std_logic_vector(3 downto 0);
	b:		in std_logic_vector(3 downto 0);
	s:		in std_logic_vector(2 downto 0);
	Cn:		in std_logic;
	
	Cn4:	out std_logic;
	ovr:	out std_logic;
	f:		out std_logic_vector(3 downto 0));
end SN74382;

architecture chip of SN74382 is

signal subfa:	std_logic_vector(3 downto 0);
signal subfb:	std_logic_vector(3 downto 0);
signal pref:	std_logic_vector(4 downto 0);
signal unknown:	std_logic;
signal nG:		std_logic;
	
begin

unknown <= not(((not s(1)) and (not s(0))) or s(2));

pref(0) <= not(((not s(0)) and s(2)) or (s(2) and (not s(1))));
pref(1) <= not(s(0) and s(1) and (not s(2)));
pref(2) <= not((not s(0)) and s(1));
pref(3) <= not((not s(1)) and (not s(2)));
pref(4) <= not((not s(0)) and (not s(1)));

SUB:
for i in 0 to 3 generate
	subfa(i) <= not(((not a(i)) and (not b(i)) and (pref(2)) and (pref(3))) or ((pref(4)) and (pref(2)) and (pref(1)) and (not b(i)) and a(i)) or ((pref(3)) and (pref(1)) and b(i) and (not a(i))));
	subfb(i) <= not(((not a(i)) and (not b(i)) and (pref(4)) and (pref(1)) and (pref(0))) or ((pref(3)) and (pref(2)) and (not b(i)) and a(i)) or ((pref(3)) and (pref(2)) and b(i) and (not a(i))) or ((pref(4)) and (pref(1)) and b(i) and a(i)));
end generate SUB;

f(0) <= not(Cn and unknown) xor subfb(0);
f(1) <= not((Cn and subfa(0) and unknown) or (subfa(0) and subfb(0) and unknown)) xor subfb(1);
f(2) <= not((Cn and subfa(0) and subfa(1) and unknown) or (subfa(0) and subfa(1) and subfb(0) and unknown) or (subfa(1) and subfb(1) and unknown)) xor subfb(2);
f(3) <= not((Cn and subfa(0) and subfa(1) and subfa(2) and unknown) or (subfa(0) and subfa(1) and subfa(2) and subfb(0) and unknown) or (subfa(1) and subfa(2) and subfb(1) and unknown) or (subfa(2) and subfb(2) and unknown)) xor subfb(3);

nG <= not((subfa(0) and subfa(1) and subfa(2) and subfa(3) and subfb(0)) or  (subfa(1) and subfa(2) and subfa(3) and subfb(1)) or (subfa(2) and subfa(3) and subfb(2)) or (subfa(3) and subfb(3)));

ovr <= not((Cn and subfa(0) and subfa(1) and subfa(2) and unknown) or (subfa(0) and subfa(1) and subfa(2) and subfb(0) and unknown) or (subfa(1) and subfa(2) and subfb(1) and unknown) or (subfa(2) and subfb(2) and unknown)) xor (nG and not(Cn and subfa(0) and subfa(1) and subfa(2) and subfa(3)));
Cn4 <= not(nG and not(Cn and subfa(0) and subfa(1) and subfa(2) and subfa(3)));

end chip;