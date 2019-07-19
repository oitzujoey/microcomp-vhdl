--74182 look-ahead carry generators
--
--component SN74182 is
--	port(
--	gi:		in std_logic_vector(3 downto 0);
--	pi:		in std_logic_vector(3 downto 0);
--	cni:	in std_logic;
--	
--	po:		out std_logic;
--	go: 	out std_logic;
--	cno:	out std_logic_vector(2 downto 0));
--end component SN74280;

--u182: SN74182 port map (
--	gi => GI,
--	pi => PI,
--	cni => CNI,
--	
--	po => PO,
--	go => GO,
--	cno => CNO
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SN74182 is
	port(
	gi:		in std_logic_vector(3 downto 0);
	pi:		in std_logic_vector(3 downto 0);
	cni:	in std_logic;
	
	po:		out std_logic;
	go: 	out std_logic;
	cno:	out std_logic_vector(2 downto 0));
end SN74182;

architecture chip of SN74182 is
begin

po <= pi(0) or pi(1) or pi(2) or pi(3);
go <= (gi(3) and gi(2) and gi(1) and gi(0)) or (pi(1) and gi(3) and gi(2) and gi(1)) or (pi(2) and gi(3) and gi(2)) or (pi(3) and gi(3));

cno(0) <= not((not(cni) and gi(0)) or (pi(0) and gi(0)));
cno(1) <= not((gi(1) and gi(0) and not(cni)) or (pi(0) and gi(1) and gi(0)) or (pi(1) and gi(1)));
cno(2) <= not((gi(2) and gi(1) and gi(0) and not(cni)) or (pi(0) and gi(2) and gi(1) and gi(0)) or (pi(1) and gi(2) and gi(1)) or (pi(2) and gi(2)));

end chip;