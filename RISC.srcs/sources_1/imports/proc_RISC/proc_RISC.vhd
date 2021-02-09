----------------------------------------------------------------------------------
-- Company:         UTCN
-- Engineer: 
-- 
-- Create Date:     15:57:46 04/11/2015 
-- Design Name:     proc_RISC
-- Module Name:     proc_RISC - Behavioral 
-- Project Name:    proc_RISC
-- Target Devices: 
-- Tool versions:   Vivado 2016.4
-- Description:     Modul principal al procesorului RISC
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity proc_RISC is
    Generic (DIM_MI : INTEGER := 256;           -- dimensiunea memoriei de instructiuni (cuvinte)
             DIM_MD : INTEGER := 256);          -- dimensiunea memoriei de date (cuvinte)
    Port ( Clk      : in  STD_LOGIC;
           Rst      : in  STD_LOGIC;
           AdrInstr : out STD_LOGIC_VECTOR (31 downto 0);
           Instr    : out STD_LOGIC_VECTOR (31 downto 0);
           Data     : out STD_LOGIC_VECTOR (31 downto 0);
           RA       : out STD_LOGIC_VECTOR (31 downto 0);
           RB       : out STD_LOGIC_VECTOR (31 downto 0);
           F        : out STD_LOGIC_VECTOR (31 downto 0);
           ZF       : out STD_LOGIC;
           CF       : out STD_LOGIC);
end proc_RISC;

architecture Behavioral of proc_RISC is

    signal iCCEX        : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal sRID         : STD_LOGIC_VECTOR (21 downto 0) := (others => '0');
    signal iRID         : STD_LOGIC_VECTOR (21 downto 0) := (others => '0');
    signal iREX         : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    signal sREX         : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    signal sRI          : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal iConst       : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal sConst       : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

    -- Semnale pentru interconectarea modulelor
    signal sMUXA        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMUXB        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMUXC        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMUXD        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sPC          : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal PCplus       : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMI          : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sPCIF        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sPCID        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sPCEX        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sRCONST      : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sRDoutA      : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sRDoutB      : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal AdrSalt      : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sUAL         : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMD          : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sFEX         : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sMDEX        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sCCEX        : STD_LOGIC_VECTOR (1  downto 0) := (others => '0');
    signal sSGTE        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal sSLT         : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal NxorV        : STD_LOGIC := '0';
    signal NxnorV       : STD_LOGIC := '0';
    signal V            : STD_LOGIC := '0';
    signal C            : STD_LOGIC := '0';
    signal N            : STD_LOGIC := '0';
    signal Z            : STD_LOGIC := '0';

    -- Semnale de comanda
    signal RegWr        : STD_LOGIC := '0';
    signal MemWr        : STD_LOGIC := '0';
    signal RegWr_inter  : STD_LOGIC := '0';
    signal MemWr_inter  : STD_LOGIC := '0';
    signal OpUAL        : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal OpUAL_inter  : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal Sh           : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal MxA          : STD_LOGIC := '0';
    signal MxB          : STD_LOGIC := '0';
    signal MxA_inter    : STD_LOGIC := '0';
    signal MxB_inter    : STD_LOGIC := '0';
    signal MxC          : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal MxD          : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal MxD_inter    : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal AdrSA        : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal AdrSB        : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal AdrD         : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal AdrD_inter   : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    signal SSalt        : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal CSalt        : STD_LOGIC := '0';
    signal SSalt_inter  : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal CSalt_inter  : STD_LOGIC := '0';
    signal SelC         : STD_LOGIC := '0';
    
    signal EnInstr      : STD_LOGIC := '0';
    signal Q            : STD_LOGIC := '1';
    signal S1, S2       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    -- Semnale pentru eliminarea hazardului de control prin predictia salturilor
    signal sMI_hazard   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    MI:         entity WORK.mem_instr   port map (Clk => Clk, Rst => Rst, Adr => sPC (7 downto 0), Data => sMI);
    R:          entity WORK.set_reg     port map (Clk => Clk, Rst => Rst, WE => RegWr, AdrA => AdrSA, AdrB => AdrSB,
                                                  AdrD => AdrD, Din => sMUXD, DoutA => sRDoutA, DoutB => sRDoutB);
    UAL:        entity WORK.unit_aritm  port map (X => sMUXA, Y => sMUXB, Sel => OpUAL, Sh => Sh, F => sUAL, V => V, C => C, N => N, Z => Z);
    MD:         entity WORK.mem_date    port map (Clk => Clk, Rst => Rst, WE => MemWr, Adr => sMUXA (7 downto 0), Din => sMUXB, Dout => sMD);
    
    PC:         entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sMuxC, Rst => Rst, CE => '1', Q => sPC);
                                
    PCIF:       entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sPC, Rst => Rst, CE => '1', Q => sPCIF);
                                
    PCID:       entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sPCIF, Rst => Rst, CE => '1', Q => sPCID);
                                
    PCEX:       entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sPCID, Rst => Rst, CE => '1', Q => sPCEX);
                                
    MDEX:       entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sMD, Rst => Rst, CE => '1', Q => sMDEX);
                                
    FEX:        entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sUAL, Rst => Rst, CE => '1', Q => sFEX);
                                
    CCEX:       entity WORK.FDN generic map (n => 2)
                                port map (Clk => Clk, D => iCCEX, Rst => Rst, CE => '1', Q => sCCEX);
                                
    REX:        entity WORK.FDN generic map (n => 7)
                                port map (Clk => Clk, D => iREX, Rst => Rst, CE => '1', Q => sREX);
                                
    RI:         entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => sMI_hazard, Rst => Rst, CE => '1', Q => sRI);
                                
    CONST:      entity WORK.CONST port map (intrare => iConst , SelC => SelC, iesire => SConst);
                                
    RCONST:     entity WORK.FDN generic map (n => 32)
                                port map (Clk => Clk, D => SConst , Rst => Rst, CE => '1', Q => sRConst);
                                
    DCDI:       entity WORK.DCDI port map (Op => sRI, RegWr => RegWr_inter, AdrD => AdrD_inter, MxD => MxD_inter, SSalt => SSalt_inter, CSalt => CSalt_inter, MemWr => MemWr_inter, OpUAL => OpUAL_inter, MxA => MxA_inter, MxB => MxB_inter, AdrSA => AdrSA, AdrSB => AdrSB, SelC => SelC);
                                                           
    RID:        entity WORK.FDN generic map (n => 22)
                                port map (Clk => Clk, D => iRID, Rst => Rst, CE => '1', Q => sRID);
                                
    iRID <= (EnInstr and RegWr_inter) & AdrD_inter & MxD_inter & ((EnInstr & EnInstr) and SSalt_inter) & CSalt_inter & (EnInstr and MemWr_inter) & OpUAL_inter & MxA_inter & MxB_inter & sRI(4 downto 0);
                                
    MemWr <= sRID(11);
    OpUAL <= sRID (10 downto 7);
    MxA <= sRID(6);
    MxB <= sRID(5);
    Sh <= sRID(4 downto 0);
                                   
    SELMUXC:    entity WORK.SELMUXC port map (SSalt => sRID(14 downto 13), CSalt => sRID(12), Z => Z, MxC => MxC);
    
    iREX <= sRID(21 downto 15);
    iCCEX <= NxnorV & NxorV;
    iConst <= sRI(15 downto 0);
    
    NxorV  <= N xor V;
    NxnorV <= not NxorV;
    sSLT   <= x"0000_000" & b"000" & sCCEX(0);
    sSGTE  <= x"0000_000" & b"000" & sCCEX(1);
    
    EnInstr <= not (MxC(1) or MxC(0));
    S1 <= (others => EnInstr);
    S2 <= (others => Q);
    
    sMI_hazard <= S1 and sMI and S2;
    
    bistabil: process(Clk)
              begin
                    if rising_edge(Clk) then
                        if Rst = '1' then
                            Q <= '1';
                        else
                            Q <= EnInstr;
                        end if;
                    end if;
              end process;

    INCPC:      PCplus <= sPC + 1;
    ADDPC:      AdrSalt <= sPCID + sMUXB;
    MUXA:       sMUXA <= sRDoutA when MxA = '0' else sPCID;
    MUXB:       sMUXB <= sRDoutB when MxB = '0' else sRCONST;
    MUXC:       with MxC select
                    sMUXC <= PCplus when "00", AdrSalt when "01", sMUXA when "10", sPCEX when others;
    MUXD:       with MxD select
                    sMUXD <= sFEX when "00", sMDEX when "01", sSGTE when "10", sSLT when others;

    -- Conectarea semnalelor la porturile de iesire
    AdrInstr <= sPCIF;
    Instr    <= sMI_hazard;
    Data     <= sMD;
    RA       <= sMUXA;
    RB       <= sMUXB;
    F        <= sUAL;
    ZF       <= Z;
    CF       <= C;
    
    RegWr <= sREX(6);
    AdrD <= sREX(5 downto 2);
    MxD <= sREX(1 downto 0);

end Behavioral;