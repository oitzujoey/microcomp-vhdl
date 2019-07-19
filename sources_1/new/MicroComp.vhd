----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2018 02:37:32 PM
-- Design Name: 
-- Module Name: MicroComp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Executed first instructions on 7/19/2018.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MicroComp is
    Port (
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        clk : in STD_LOGIC;
        btnC: in std_logic;
        
        led : out STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0));
end MicroComp;

architecture Behavioral of MicroComp is
    component SN7402
    	port(
    	a:	in std_logic_vector(3 downto 0);
    	b:	in std_logic_vector(3 downto 0);
    	
    	y:	out std_logic_vector(3 downto 0));
    end component;
    
    component SN7404
        port(
        a:    in std_logic_vector(5 downto 0);
        
        y:    out std_logic_vector(5 downto 0));
    end component;
    
    component SN74245 is
        port(
        dir:    in std_logic;
        noe:    in std_logic;
        
        a:        inout std_logic_vector(7 downto 0);
        b:        inout std_logic_vector(7 downto 0));
    end component SN74245;
    
    component SN74574 is
        port(
        clk:    in std_logic;
        d:        in std_logic_vector(7 downto 0);
        noe:    in std_logic;
        
        q:        out std_logic_vector(7 downto 0));
    end component SN74574;

    component MicroComp_Processor
        port(
        clk:        in std_logic;
        nreset:     in std_logic;
        
        progData:   inout std_logic_vector(7 downto 0);
        data:       inout std_logic_vector(7 downto 0);
        
        progAddr:   out std_logic_vector(15 downto 0);
        dataAddr:   out std_logic_vector(15 downto 0);
        nrdp:       out std_logic;
        nrdd:       out std_logic;
        nwrp:       out std_logic;
        nwrd:       out std_logic);
    end component;
    
    type mem_type is array(255 downto 0) of std_logic_vector(7 downto 0);
    
    --Initialize ROM
    impure function load_mem(fileName: in string) return mem_type is
        file mem_file:       text is in fileName;
        variable file_line: line;
        variable mem: mem_type;
    begin
        for i in mem_type'range loop
            readline(mem_file, file_line);
            hread(file_line, mem(mem_type'length-i-1));
        end loop;
        return mem;
    end function;
    
    signal datap:   std_logic_vector(7 downto 0);   --Program memory data bus
    signal datad:   std_logic_vector(7 downto 0);   --Data memory data bus
    signal addrd:   std_logic_vector(15 downto 0);  --Data memory address bus
    signal addrp:   std_logic_vector(15 downto 0);  --Program memory address bus
    signal nrdp:    std_logic;                      --!Read program memory
    signal nrdd:    std_logic;                      --!Read data memory
    signal nwrp:    std_logic;                      --!Write program memory
    signal nwrd:    std_logic;                      --!Write data memory
    signal u29a:    std_logic_vector(5 downto 0);   --Random signals
    signal u29y:    std_logic_vector(5 downto 0);
    signal u28a:    std_logic_vector(3 downto 0);
    signal u28b:    std_logic_vector(3 downto 0);
    signal u28y:    std_logic_vector(3 downto 0);
    signal input:   std_logic_vector(7 downto 0);
    signal output:  std_logic_vector(7 downto 0);
    signal nreset:  std_logic;                      --CPU reset
    
    signal RAMD:    mem_type;
    signal RAMP:    mem_type;
    signal ROMP:    mem_type := load_mem("Test_1.mem");
begin

an <= "1111";
led(15 downto 8) <= sw(15 downto 8);

--Reset
nreset <= not(btnC);

--Program ROM
datap <= ROMP(to_integer(unsigned(addrp(7 downto 0)))) when ((nrdp = '0') and (addrp(15) = '0')) else "ZZZZZZZZ";

--Program RAM
datap <= RAMP(to_integer(unsigned(addrp(7 downto 0)))) when ((nrdp = '0') and (u29y(0) = '0')) else "ZZZZZZZZ";

process (nwrp) is begin
    if rising_edge(nwrp) then
        if (addrp(15) = '0') then
            RAMP(to_integer(unsigned(addrp(7 downto 0)))) <= datap;
        end if;
    end if;
end process;

--Data RAM
datad <= RAMD(to_integer(unsigned(addrd(7 downto 0)))) when ((nrdd = '0') and (addrd(15) = '0')) else "ZZZZZZZZ";

process (nwrd) is begin
    if rising_edge(nwrd) then
        if (addrd(15) = '0') then
            RAMD(to_integer(unsigned(addrd(7 downto 0)))) <= datad;
        end if;
    end if;
end process;

--CPU
u0: MicroComp_Processor port map(
    clk => clk,
    nreset => nreset,
    
    progData => datap,
    data => datad,
    
    progAddr => addrp,
    dataAddr => addrd,
    nrdp => nrdp,
    nrdd => nrdd,
    nwrp => nwrp,
    nwrd => nwrd
);



--Output
led(7 downto 0) <= output;

u31: SN74574 port map(
    clk => u28y(1),
    d => datad,
    noe => '0',
    
    q => output
);

--Input
input <= sw(7 downto 0);

u27: SN74245 port map(
    dir => '0',
    noe => u28y(2),
    
    a => input(7 downto 0),
    b => datad
);

--I/O select
u28a <= addrd(15) & u28y(0) & u28y(3) & u28y(3);
u28b <= addrd(15) & u28y(0) & nwrd & nrdd;

u28: SN7402 port map(
    a => u28a,
    b => u28b,
    
    y => u28y
);

--Program RAM select
u29a <= "11111" & addrp(15);

u29: SN7404 port map(
    a => u29a,
    
    y => u29y
);

end Behavioral;
