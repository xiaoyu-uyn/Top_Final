library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.stype.all;


ENTITY CPU_top IS
   PORT
   (
        CLK100MHZ   : IN     STD_LOGIC;
        BTNL   : in std_logic;  -- reset to encrption (default)
        BTND: in STD_LOGIC;     -- reset to decrption
        BTNU : in STD_LOGIC;
        BTNR : in STD_LOGIC;
        L1   : out std_logic;
        LED0 : out std_logic;
--        BTNC : in STD_LOGIC;
        SW   : in STD_LOGIC_VECTOR (15 downto 0);
        seg 		: out  STD_LOGIC_VECTOR (7 downto 0);
        an 		: out  STD_LOGIC_VECTOR (3 downto 0)
   );
END CPU_top;

ARCHITECTURE struct OF CPU_top IS  -- Structural description
     signal Instr: STD_LOGIC_vector(31 downto 0):=x"30000000";
     signal PC: STD_LOGIC_vector(31 downto 0):=x"00000000";
     signal PC_next: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal PC_next_inter: STD_LOGIC_vector(31 downto 0):=x"00000000";--
     signal A3: STD_LOGIC_vector(4 downto 0):="00000"; --
     signal WD3: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal MemtoReg: STD_LOGIC:= '0';
     signal MemWrite: STD_LOGIC:= '0';
     signal Branch: STD_LOGIC:= '0';
     signal ALUSrc: STD_LOGIC:= '0';
     signal RegDst: STD_LOGIC:= '0';
     signal Regwrite: STD_LOGIC:= '0';
     signal ALUControl: STD_LOGIC_vector(2 downto 0):= "000";
     signal RD1: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal RD2: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal SrcB:STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal Zero: STD_LOGIC:='0';
     signal ALUResult: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal ReadData: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal Result: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal PCPlus4: STD_LOGIC_vector(31 downto 0):=x"00000004";
     signal PCBranch: STD_LOGIC_vector(31 downto 0):=x"00000004"; --
     signal SignImm: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal Imm: STD_LOGIC_vector(31 downto 0):=x"00000000"; --
     signal PCSrc: STD_LOGIC:='0';
     signal JMP: std_logic:= '0';
     signal Reset: std_logic:= '0';
     signal display: std_logic_vector(63 downto 0);--
     signal display15: std_logic_vector(15 downto 0);
     signal CLK: std_logic;
--   type ss_type is ( ChangePC, ReadReg, rwMem, WriteReg, Res);
     signal state: ss_type:= ChangePC;
     signal nextstate: ss_type;
     signal ukey:std_logic_vector(127 downto 0):=x"00000000000000000000000000000000";
     signal din:std_logic_vector(63 downto 0):=x"0000000000000000";
     signal BTNL1:std_logic:='0';
     signal test:std_logic:='0';
     signal BTND1:std_logic:='0';
     signal CLK_sys:std_logic;
     
  attribute DONT_TOUCH : string;
  attribute DONT_TOUCH of  U4 : label is "TRUE";

  
COMPONENT  Control  
   PORT(
	Op: in std_logic_vector(5 downto 0);
	Funct: in std_logic_vector(5 downto 0);
	state:in ss_type;
	Reset:  out std_logic;
	MemtoReg: out std_logic;
	MemWrite: out std_logic;
	Branch: out std_logic;
	ALUControl: out std_logic_vector(2 downto 0);
	ALUSrc: out std_logic;
	RegDst: out std_logic;
	JMP: out std_logic;
	RegWrite: out std_logic
	);
END COMPONENT;

COMPONENT  Registera  
   PORT(
	A1: in std_logic_vector(4 downto 0);
	A2: in std_logic_vector(4 downto 0);
	A3: in std_logic_vector(4 downto 0);
	WD3: in std_logic_vector(31 downto 0);
	CLK: in std_logic;
    state:in ss_type;
	WE3: in std_logic;
	RD1: out std_logic_vector(31 downto 0);
	display: out std_logic_vector(63 downto 0);--
	RD2: out std_logic_vector(31 downto 0)
	);
END COMPONENT;

COMPONENT  ALU
port(
	rot_amt: in std_logic_vector(2 downto 0);
	Funct: in std_logic_vector(5 downto 0);
	SrcA: in std_logic_vector(31 downto 0);
	SrcB: in std_logic_vector(31 downto 0);
	ALUControl: in std_logic_vector(2 downto 0);
	Op: in std_logic_vector(5 downto 0);
	ALUResult: out std_logic_vector(31 downto 0);
	Zero: out std_logic);
end component;


COMPONENT  DataMemory
port(
	A: in std_logic_vector(31 downto 0);
	WD: in std_logic_vector(31 downto 0);
	WE: in std_logic;   --Write Enable
	ukey: in std_logic_vector(127 downto 0);
	din: in std_logic_vector(63 downto 0);
	CLK: in std_logic;
	state:in ss_type;
	RD: out std_logic_vector(31 downto 0)
	);
end component;


COMPONENT  InstructionMemory
port(
	A: in std_logic_vector(31 downto 0);
	RD: out std_logic_vector(31 downto 0)
	);
end component;

component SevenSeg_Top port(
    CLK 	: in  STD_LOGIC;
           input    : in   STD_LOGIC_VECTOR (15 downto 0);
           seg 		: out  STD_LOGIC_VECTOR (7 downto 0);
           an 		: out  STD_LOGIC_VECTOR (3 downto 0)
);
end component;

component debounce 
  GENERIC(
    counter_size  :  INTEGER := 6); --counter size (19 bits gives 10.5ms with 50MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
END component;

component clk_wiz_0 port(
  clk_out1 : out std_logic;
  clk_in1: in std_logic
 );
 end component;
 
begin
   U1:ALU PORT MAP(SrcA => RD1, SrcB => SrcB, Zero => Zero, ALUResult => ALUResult, rot_amt => Instr(10 downto 8),
                    Funct => Instr(5 downto 0),ALUControl => ALUControl, Op =>Instr(31 downto 26));
   U2:Control PORT MAP(Op => Instr(31 downto 26),Funct => Instr(5 downto 0),MemtoReg => MemtoReg,MemWrite => MemWrite,Branch => Branch,ALUControl(2 downto 0)=>ALUControl(2 downto 0),
                                        ALUSrc => ALUSrc, RegDst => RegDst, RegWrite => RegWrite, JMP => JMP,Reset=>Reset,state => state);
   U3:datamemory PORT MAP(CLK => CLK,state => state, A => ALUResult, WD => RD2, WE => MemWrite, RD =>ReadData, ukey=>ukey, din=>din);
   U4:Registera PORT MAP(CLK => CLK,state => state,A1 => Instr(25 downto 21), A2 => Instr(20 downto 16), A3 => A3,WD3 => Result, WE3 => RegWrite, RD1 => RD1, RD2 => RD2,display=>display);
   U5:InstructionMemory PORT MAP(A => PC, RD => Instr);  
   U6: SevenSeg_Top port map( CLK => CLK100MHZ,input => display15,seg => seg,an => an);
   U7: debounce port map(clk => CLK,button => BTNL,result => BTNL1);
   U8: debounce port map(clk => CLK,button => BTND,result => BTND1);
   U9: clk_wiz_0 port map(clk_out1 => CLK_sys, clk_in1 => CLK100MHZ);
   
   WITH SW(7) SELECT
   CLK <= CLK_sys when '0',
          SW(6) when others;
    
   
    LED0 <= test;
    stateFSM: process (CLK)
	begin
       if ( CLK'event and CLK ='1' ) then
           if(BTNL = '1' or BTND = '1') then  -- reduce debounce
                state <= Res;
                test <= '1';
           else
               state <= nextstate;
	       end if;
	   end if;
	end process stateFSM;

	stateC: process(state)
	begin
	   nextstate <= ChangePC;
	   case state is
	       when ChangePC   => nextstate <= ReadReg;
	       when ReadReg    => nextstate <= rwMem;
	       when rwMem      => nextstate <= WriteReg;
	       when WriteReg   => nextstate <= ChangePC;
	       when Res        => nextstate <= ChangePC;
	   end case;
    end process stateC;
	
	process(clk)
	begin
        if (clk = '1') then
            L1 <= instr(31) or instr(30) or instr(29) or instr(28) or instr(27) or instr(26) or instr(25) or instr(24) or instr(23) or instr(22) or instr(21) or instr(20) or instr(19) or instr(18) or instr(17) or instr(16) or instr(15) or instr(14) or instr(13) or instr(12) or instr(11) or instr(10) or instr(9) or instr(8) or instr(7) or instr(6) or instr(5) or instr(4) or instr(3) or instr(2) or instr(1) or instr(0); 
        else L1 <= '0';
    end if;
    end process;
    
    PCPlus4 <= PC + "100";
   
    WITH Instr(15) SELECT
    SignImm <= "1111111111111111" & Instr(15 downto 0) WHEN '1',
                "0000000000000000" & Instr(15 downto 0) WHEN OTHERS;
    
    Imm <= SignImm(29 downto 0) & "00";
    
    PCBranch <= Imm + PCPlus4;
    
    WITH PCSrc SELECT
    PC_next_inter <= PCPlus4 WHEN '0',
               PCBranch WHEN OTHERS;
    WITH JMP SELECT
    PC_next <= PC_next_inter WHEN '0',
               PCBranch WHEN OTHERS;
               
    PCSrc <= Branch and Zero;

    WITH RegDst SELECT
    A3 <= Instr(15 downto 11) WHEN '0',
          Instr(20 downto 16) WHEN OTHERS;
       
    WITH ALUSrc SELECT
    SrcB <= RD2 WHEN '0',
          SignImm WHEN OTHERS;
          
    WITH MemtoReg SELECT
    Result <= ALUResult WHEN '0',
              ReadData WHEN OTHERS;
   
    Process(BTNU,BTNR,state)
    begin
        if (state = Res) then
            display15 <= SW;
        else
            if(BTNU = '0' and BTNR = '0') then
                display15 <= display(63 downto 48);
            elsif(BTNU = '0' and BTNR = '1') then
                display15 <= display(47 downto 32);
            elsif(BTNU = '1' and BTNR = '0') then
                display15 <= display(31 downto 16);
            else
                display15 <= display(15 downto 0);
            end if;
        end if;
    end process;
    
    Process(clk)
    begin
        IF(CLK'EVENT AND CLK='1' and state = Res) THEN
            if(SW(5) = '1') then
                case SW(4 downto 0) is                                               --1~16 from high to low
                    when "00100" => ukey(127 downto 120)  <= SW(15 downto 8);    --4
                    when "00011" => ukey(119 downto 112)  <= SW(15 downto 8);    --3
                    when "00010" => ukey(111 downto 104)  <= SW(15 downto 8);    --2
                    when "00001" => ukey(103 downto 96)<= SW(15 downto 8);       --1
                    when "01000" => ukey(95 downto 88) <= SW(15 downto 8);       --8
                    when "00111" => ukey(87 downto 80) <= SW(15 downto 8);       --7
                    when "00110" => ukey(79 downto 72) <= SW(15 downto 8);       --6
                    when "00101" => ukey(71 downto 64) <= SW(15 downto 8);       --5
                    when "01100" => ukey(63 downto 56) <= SW(15 downto 8);       --12
                    when "01011" => ukey(55 downto 48) <= SW(15 downto 8);       --11
                    when "01010" => ukey(47 downto 40) <= SW(15 downto 8);       --10
                    when "01001" => ukey(39 downto 32) <= SW(15 downto 8);       --9
                    when "10000" => ukey(31 downto 24) <= SW(15 downto 8);       --16
                    when "01111" => ukey(23 downto 16) <= SW(15 downto 8);       --15
                    when "01110" => ukey(15 downto 8)  <= SW(15 downto 8);       --14
                    when "01101" => ukey(7 downto 0)   <= SW(15 downto 8);       --13
                    when others => null;                    
                end case;
            else
               case SW(4 downto 0) is 
                    when "00001" => din(63 downto 56) <= SW(15 downto 8);        --1
                    when "00010" => din(55 downto 48) <= SW(15 downto 8);        --2
                    when "00011" => din(47 downto 40) <= SW(15 downto 8);        --3
                    when "00100" => din(39 downto 32) <= SW(15 downto 8);        --4
                    when "00101" => din(31 downto 24) <= SW(15 downto 8);        --5
                    when "00110" => din(23 downto 16) <= SW(15 downto 8);        --6
                    when "00111" => din(15 downto 8)  <= SW(15 downto 8);        --7
                    when "01000" => din(7 downto 0)   <= SW(15 downto 8);        --8
                    when others => null;
                end case;
            end if;
        end if;
    end process;
                             
    Process(CLK)
    begin
        IF(CLK'EVENT AND CLK='0') THEN
            if(state = Res and BTNL = '1') then
                PC <= x"00000000";
            elsif(state = Res and BTND = '1') then
                PC <= x"000002BC";
            elsif(state = ChangePC) then
                if(Reset = '0') THEN
                    PC <= PC_next;
                else
                    PC <= PC;
                end if;
            end IF;
        end if;
    end Process;
END struct;
--2000000