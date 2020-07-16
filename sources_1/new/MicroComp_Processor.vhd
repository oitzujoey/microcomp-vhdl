----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joey Herguth
-- 
-- Create Date: 05/06/2018 02:37:32 PM
-- Design Name: 
-- Module Name: MicroComp_Processor - Behavioral
-- Project Name: MicroComp
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: A simulation of of the MicroComp TTL processor architecture.
-- 
-- Dependencies: The VHDL 7400 series library
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: The transparent latch (IC43) had to be changed to an edge-
--  triggered register to prevent a logic loop.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_misc.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MicroComp_Processor is
    Port (
        clk : in STD_LOGIC;
        nreset: in STD_LOGIC;
        
        progData : inout STD_LOGIC_VECTOR (7 downto 0);
        data : inout STD_LOGIC_VECTOR (7 downto 0);
           
        progAddr : out STD_LOGIC_VECTOR (15 downto 0);
        dataAddr : out STD_LOGIC_VECTOR (15 downto 0);
        nrdp : out STD_LOGIC;
        nrdd : out STD_LOGIC;
        nwrp : out STD_LOGIC;
        nwrd : out STD_LOGIC);
end MicroComp_Processor;

architecture Behavioral of MicroComp_Processor is
    component SN74574
        port(
        clk:	in std_logic;
        d:      in std_logic_vector(7 downto 0);
        noe:    in std_logic;
        
        q:      out std_logic_vector(7 downto 0));
    end component;
    
    component SN74163
        port(
        clk:        in std_logic;
        d:          in std_logic_vector(3 downto 0);
        et:         in std_logic;
        ep:         in std_logic;
        nload:      in std_logic;
        nclr:       in std_logic;
        
        q:          out std_logic_vector(3 downto 0);
        rco:        out std_logic);
    end component;
    
    component SN7486
        port(
        a:    in std_logic_vector(3 downto 0);
        b:    in std_logic_vector(3 downto 0);
        
        y:    out std_logic_vector(3 downto 0));
    end component;
    
    component SN74381
        port(
        a:      in std_logic_vector(3 downto 0);
        b:      in std_logic_vector(3 downto 0);
        s:      in std_logic_vector(2 downto 0);
        Cn:     in std_logic;
        
        nG:     out std_logic;
        nP:     out std_logic;
        f:      out std_logic_vector(3 downto 0));
    end component;
    
    component SN74244
        port(
        a1:         in std_logic_vector(3 downto 0);
        a2:         in std_logic_vector(3 downto 0);
        noc1:       in std_logic;
        noc2:       in std_logic;
        
        y1:         out std_logic_vector(3 downto 0);
        y2:         out std_logic_vector(3 downto 0));
    end component;
    
    component SN7432
        port(
        a:    in std_logic_vector(3 downto 0);
        b:    in std_logic_vector(3 downto 0);
        
        y:    out std_logic_vector(3 downto 0));
    end component;
    
    component SN74151
        port(
        d:          in std_logic_vector(7 downto 0);
        strobe:     in std_logic;
        sel:        in std_logic_vector(2 downto 0);
        
        y:          out std_logic;
        w:          out std_logic);
    end component;
    
    component SN74280
    	port(
        d:          in std_logic_vector(8 downto 0);
        
        even:       out std_logic;
        odd:        out std_logic);
    end component;
    
    component SN74182
        port(
        gi:     in std_logic_vector(3 downto 0);
        pi:     in std_logic_vector(3 downto 0);
        cni:    in std_logic;
        
        po:     out std_logic;
        go:     out std_logic;
        cno:    out std_logic_vector(2 downto 0));
    end component;
    
    component SN74257
        port(
        noc:    in std_logic;
        a:      in std_logic_vector(3 downto 0);
        b:      in std_logic_vector(3 downto 0);
        sel:    in std_logic;
        
        y:        out std_logic_vector(3 downto 0));
    end component;
    
    component SN74133
        port(
        d:        in std_logic_vector(12 downto 0);
        
        y:        out std_logic);
    end component;
    
    component SN74373
        port(
        cp:        in std_logic;
        d:        in std_logic_vector(7 downto 0);
        noe:    in std_logic;
        
        q:        out std_logic_vector(7 downto 0));
    end component;
    
    component SN74161
        port(
        clk:        in std_logic;
        d:          in std_logic_vector(3 downto 0);
        et:         in std_logic;
        ep:         in std_logic;
        nload:      in std_logic;
        nclr:       in std_logic;
        
        q:          out std_logic_vector(3 downto 0);
        rco:        out std_logic);
    end component;
    
    component SN74374
        port(
        clk:    in std_logic;
        d:        in std_logic_vector(7 downto 0);
        noe:    in std_logic;
        
        q:        out std_logic_vector(7 downto 0));
    end component;
    
    component SN74260
        port(
        d0:        in std_logic_vector(4 downto 0);
        d1:        in std_logic_vector(4 downto 0);
        
        y0:        out std_logic;
        y1:        out std_logic);
    end component;
    
    component SN74245
        port(
        dir:    in std_logic;
        noe:    in std_logic;
        
        a:        inout std_logic_vector(7 downto 0);
        b:        inout std_logic_vector(7 downto 0));
    end component;
    
    type microcode_type is array(1023 downto 0) of std_logic_vector(7 downto 0);
    
    --Initialize microcode
    impure function load_microcode(fileName: in string) return microcode_type is
        file mc_file:       text is in fileName;
        variable file_line: line;
        variable microcode: microcode_type;
    begin
        for i in microcode_type'range loop
            readline(mc_file, file_line);
            hread(file_line, microcode(microcode_type'length-i-1));
        end loop;
        return microcode;
    end function;
    
    signal nupcrst:     std_logic;                      --!Microprogram Counter Reset
    signal upc:         std_logic_vector(3 downto 0);   --Microprogram Counter
    signal irld:        std_logic;                      --Instruction Register Load
    signal ir:          std_logic_vector(7 downto 0);   --Instruction Register
    signal irldCalcBuf: std_logic_vector(4 downto 0);   --Instruction Register Load Calculation Buffer
    signal microAddr:   std_logic_vector(9 downto 0);   --Microcode ROM address bus
    signal naoe:        std_logic;                      --A register output enable
    signal nashoe:      std_logic;                      --A register right-shift output enable
    signal fsors:       std_logic;                      --Flag source select
    signal flck:        std_logic;                      --Flag register clock
    signal naluoe:      std_logic;                      --ALU output enable
    signal aclk:        std_logic;                      --A register clock
    signal sel:         std_logic_vector(2 downto 0);   --ALU function select
    signal bclk:        std_logic;                      --B register clock
    signal nboe:        std_logic;                      --B register output enable
    signal nfoe:        std_logic;                      --Flag register output enable
    signal njmp:        std_logic;                      --Jump
    signal npcoe:       std_logic;                      --Program counter output enable
    signal ndtoe:       std_logic;                      --Data bus transciever output enable
    signal ddir:        std_logic;                      --Data bus transciever direction control
    signal pcck:        std_logic;                      --Program counter clock
    signal cclk:        std_logic;                      --C register clock
    signal nbcoe:       std_logic;                      --BC register pair address output enable
    signal microcode1:  microcode_type := load_microcode("../imports/v1.1.1/microcode-v1.1.1-1.mem");    --Microcode ROM 1
    signal microcode2:  microcode_type := load_microcode("../imports/v1.1.1/microcode-v1.1.1-2.mem");    --Microcode ROM 2
    signal microcode3:  microcode_type := load_microcode("../imports/v1.1.1/microcode-v1.1.1-3.mem");    --Microcode ROM 3
    signal aluZeroBuf:  std_logic_vector(12 downto 0);  --ALU data bus concatenated to "00000"
    signal aluf:        std_logic_vector(7 downto 0);   --ALU output
    signal nzero:       std_logic;                      --Zero flag
    signal even:        std_logic;                      --Even parity flag
    signal odd:         std_logic;                      --Odd parity. Not used.
    signal ovr:         std_logic;                      --Overflow flag
    signal sign:        std_logic;                      --Sign flag
    signal u9a:         std_logic_vector(3 downto 0);   --u9 a input
    signal u9b:         std_logic_vector(3 downto 0);   --u9 b input
    signal u12y:        std_logic;                      --More random signals
    signal b:           std_logic_vector(7 downto 0);   --B register
    signal u30y:        std_logic_vector(3 downto 0);
    signal u9y:         std_logic_vector(3 downto 0);
    signal u18a:        std_logic_vector(3 downto 0);
    signal u18b:        std_logic_vector(3 downto 0);
    signal u18y:        std_logic_vector(3 downto 0);
    signal acc:         std_logic_vector(7 downto 0);   --A register
    signal u30a:        std_logic_vector(3 downto 0);
    signal u30b:        std_logic_vector(3 downto 0);
    signal c:           std_logic_vector(7 downto 0);   --The evil C register
    signal rco:         std_logic;                      --Program counter carry output. Not used.
    signal pc:          std_logic_vector(15 downto 0);  --Program counter
    signal npcld:       std_logic;                      --Program counter load
    signal npce1:       std_logic;                      --Program counter enable 1. Not used.
    signal u35rco:      std_logic;
    signal u34rco:      std_logic;
    signal u33rco:      std_logic;
    signal npce2:       std_logic;                      --Program counter enable 2. Not used.
    signal u5ng:        std_logic;
    signal u5np:        std_logic;
    signal fl:          std_logic_vector(7 downto 0);   --Flag register
    signal u6ng:        std_logic;
    signal u6np:        std_logic;
    signal u8gi:        std_logic_vector(3 downto 0);
    signal u8pi:        std_logic_vector(3 downto 0);
    signal u8cno:       std_logic_vector(2 downto 0);
    signal u11a2:       std_logic_vector(3 downto 0);
    signal u4b:         std_logic_vector(3 downto 0);
    signal u7d:         std_logic_vector(7 downto 0);
    signal u3b:         std_logic_vector(3 downto 0);
    signal u12d:        std_logic_vector(7 downto 0);
    signal ncoe:        std_logic;
    signal test:        std_logic;
begin

--Data address bus
dataAddr <= c & b;

--Flag select multiplexer
u12d <= '1' & fl(6 downto 0);

u12_f_sel: SN74151 port map(
    d => u12d,
    strobe => '0',
    sel => ir(2 downto 0),
    
    w => u12y
);

--Flag register 3-state
u13_f_3_state: SN74244 port map(
    a1 => fl(3 downto 0),
    a2 => fl(7 downto 4),
    noc1 => nfoe,
    noc2 => nfoe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--Flag register
u7_f: SN74574 port map(
    clk => flck,
    d => u7d,
    noe => '0',
    
    q => fl
);

--Flag register low multiplexer
u3b <= nzero & ovr & sign & u8cno(1);

u3_f_mux_l: SN74257 port map(
    noc => '0',
    a => data(3 downto 0),
    b => u3b,
    sel => fsors,
    
    y => u7d(3 downto 0)
);

--Flag register high multiplexer
u4b <= '1' & acc(0) & even & u8cno(0);

u4_f_mux_h: SN74257 port map(
    noc => '0',
    a => data(7 downto 4),
    b => u4b,
    sel => fsors,
    
    y => u7d(7 downto 4)
);

--A register shift 3-state
u11a2 <= fl(6) & acc(7 downto 5);

u11_a_shr: SN74244 port map(
    a1 => acc(4 downto 1),
    a2 => u11a2,
    noc1 => nashoe,
    noc2 => nashoe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--A register 3-state
u10_a_3_state: SN74244 port map(
    a1 => acc(3 downto 0),
    a2 => acc(7 downto 4),
    noc1 => naoe,
    noc2 => naoe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--B register 3-state
u15_b_3_state: SN74244 port map(
    a1 => b(3 downto 0),
    a2 => b(7 downto 4),
    noc1 => nboe,
    noc2 => nboe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--ALU 3-state
u14_alu_3_state: SN74244 port map(
    a1 => aluf(3 downto 0),
    a2 => aluf(7 downto 4),
    noc1 => naluoe,
    noc2 => naluoe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--Carry generator
u8gi <= "11" & u6ng & u5ng;
u8pi <= "11" & u6np & u5np;

u8_carry_gen: SN74182 port map(
    gi => u8gi,
    pi => u8pi,
    cni => fl(0),
    
    cno => u8cno
);

sel <= ir(2 downto 0);

--ALU low
u5_alu_l: SN74381 port map(
    a => acc(3 downto 0),
    b => b(3 downto 0),
    s => sel,
    Cn => fl(0),
    
    nG => u5ng,
    nP => u5np,
    f => aluf(3 downto 0)
);

--ALU high
u6_alu_h: SN74381 port map(
    a => acc(7 downto 4),
    b => b(7 downto 4),
    s => sel,
    Cn => u8cno(0),
    
    nG => u6ng,
    nP => u6np,
    f => aluf(7 downto 4)
);

--A register
u1_a: SN74574 port map(
    clk => aclk,
    noe => '0',
    d => data,
    
    q => acc
);

--B register
u2_b: SN74574 port map(
    clk => bclk,
    noe => '0',
    d => data,
    
    q => b
);

--Program counter low 3-state
u37_pc_l_3_state: SN74244 port map(
    a1 => pc(3 downto 0),
    a2 => pc(7 downto 4),
    noc1 => npcoe,
    noc2 => npcoe,
    
    y1 => progAddr(3 downto 0),
    y2 => progAddr(7 downto 4)
);

--Program counter high 3-state
u38_pc_h_3_state: SN74244 port map(
    a1 => pc(11 downto 8),
    a2 => pc(15 downto 12),
    noc1 => npcoe,
    noc2 => npcoe,
    
    y1 => progAddr(11 downto 8),
    y2 => progAddr(15 downto 12)
);

--Program counter enables
npce1 <= '1';
npce2 <= '1';
npcld <= u30y(0);

--Program counter 3:0
u33_pc_3_0: SN74161 port map(
    clk => pcck,
    d => b(3 downto 0),
    et => npce2,
    ep => npce1,
    nload => npcld,
    nclr => nreset,
    
    q => pc(3 downto 0),
    rco => u33rco
);

--Program counter 7:4
u34_pc_7_4: SN74161 port map(
    clk => pcck,
    d => b(7 downto 4),
    et => u33rco,
    ep => npce1,
    nload => npcld,
    nclr => nreset,
    
    q => pc(7 downto 4),
    rco => u34rco
);

--Program counter 11:8
u35_pc_11_8: SN74161 port map(
    clk => pcck,
    d => c(3 downto 0),
    et => u34rco,
    ep => npce1,
    nload => npcld,
    nclr => nreset,
    
    q => pc(11 downto 8),
    rco => u35rco
);

--Program counter 15:12
u36_pc_15_12: SN74161 port map(
    clk => pcck,
    d => c(7 downto 4),
    et => u35rco,
    ep => npce1,
    nload => npcld,
    nclr => nreset,
    
    q => pc(15 downto 12),
    rco => rco
);

--B register address 3-state output
u39_b_addr_3_state: SN74244 port map(
    a1 => b(3 downto 0),
    a2 => b(7 downto 4),
    noc1 => nbcoe,
    noc2 => nbcoe,
    
    y1 => progAddr(3 downto 0),
    y2 => progAddr(7 downto 4)
);

--C register address 3-state output
u40_c_addr_3_state: SN74244 port map(
    a1 => c(3 downto 0),
    a2 => c(7 downto 4),
    noc1 => nbcoe,
    noc2 => nbcoe,
    
    y1 => progAddr(11 downto 8),
    y2 => progAddr(15 downto 12)
);

--C register
u41_c: SN74574 port map(
    clk => cclk,
    d => data,
    noe => '0',
    
    q => c
);

--C register data 3-state output
u42_c_3_state: SN74244 port map(
    a1 => c(3 downto 0),
    a2 => c(7 downto 4),
    noc1 => ncoe,
    noc2 => ncoe,
    
    y1 => data(3 downto 0),
    y2 => data(7 downto 4)
);

--Data bus transciever
u32_bus_trans: SN74245 port map(
    dir => ddir,
    noe => ndtoe,
    
    a => data,
    b => progData
);

--Jump, sign, and overflow OR
u30a <= u18y(1) & "11" & u9y(0);
u30b <= u18y(3) & "11" & njmp;

u30: SN7432 port map(
    a => u30a,
    b => u30b,
    
    y => u30y
);

--Sign and overflow XOR
u18a <= u18y(2) & acc(7) & sel(1) & acc(7);
u18b <= u9y(2) & b(7) & u18y(0) & aluf(7);

u18: SN7486 port map(
    a => u18a,
    b => u18b,
    
    y => u18y
);

--Jump, sign, and overflow XOR
u9a <= '1' & sel(1) & ovr & u12y;
u9b <= u30y(3) & sel(0) & b(7) & ir(3);
ovr <= u9y(3);
sign <= u9y(1);

u9: SN7486 port map(
    a => u9a,
    b => u9b,
    
    y => u9y
);

--"Zero" detect. Is really 0xFF detect.
aluZeroBuf <= "11111" & aluf;

u19_zero: SN74133 port map(
    d => aluZeroBuf,
    
    y => nzero
);

--Even parity flag
u20_parity: SN74280 port map(
    d => aluZeroBuf(8 downto 0),
    
    even => odd,
    odd => even
);

--Microcode address bus
microAddr(3 downto 0) <= upc;
microAddr(9 downto 4) <= ir(7 downto 2);

--Microcode chip #1
nwrp <= microcode1(to_integer(unsigned(microAddr)))(0);
nrdp <= microcode1(to_integer(unsigned(microAddr)))(1);
naoe <= microcode1(to_integer(unsigned(microAddr)))(2);
nashoe <= microcode1(to_integer(unsigned(microAddr)))(3);
fsors <= microcode1(to_integer(unsigned(microAddr)))(4);
flck <= microcode1(to_integer(unsigned(microAddr)))(5);
naluoe <= microcode1(to_integer(unsigned(microAddr)))(6);
aclk <= microcode1(to_integer(unsigned(microAddr)))(7);

--Microcode chip #2
ncoe <= microcode2(to_integer(unsigned(microAddr)))(2);
bclk <= microcode2(to_integer(unsigned(microAddr)))(3);
nboe <= microcode2(to_integer(unsigned(microAddr)))(4);
nfoe <= microcode2(to_integer(unsigned(microAddr)))(5);
njmp <= microcode2(to_integer(unsigned(microAddr)))(6);
npcoe <= microcode2(to_integer(unsigned(microAddr)))(7);

--Microcode chip #3
ndtoe <= microcode3(to_integer(unsigned(microAddr)))(0);
ddir <= microcode3(to_integer(unsigned(microAddr)))(1);
pcck <= microcode3(to_integer(unsigned(microAddr)))(2);
cclk <= microcode3(to_integer(unsigned(microAddr)))(3);
nbcoe <= microcode3(to_integer(unsigned(microAddr)))(4);
nwrd <= microcode3(to_integer(unsigned(microAddr)))(5);
nrdd <= microcode3(to_integer(unsigned(microAddr)))(6);
nupcrst <= microcode3(to_integer(unsigned(microAddr)))(7);



--Concatenate '0' to the microprogram counter.
irldCalcBuf <= (upc & '0');

--Loads the instruction register when the program counter is zero. This operation was pulled out of microcode in order to get rid of an extra ROM.
--u17: SN74260 port map(
--    d0  => irldCalcBuf,
--    d1  => "11111",
    
--    y0  => irld
--);
--Same workaround as below.
irld <= or_reduce(upc);

--Remove--
--ir <= "00000000";

--Instruction register (Previously 74373 - 7/19/2018)
u43_ir: SN74574 port map(
    clk  => irld,
    d   => progData,
    noe => '0',
    
    q   => ir
);

--Microprogram counter
u16_upc: SN74163 port map(
    clk     => clk,
    d       => "0000",
    et      => '1',
    ep      => '1',
    nload   => nupcrst,
    nclr    => nreset,
    
    q       => upc
);

end Behavioral;
