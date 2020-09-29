library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.stype.all;

entity DataMemory is port (
	A: in std_logic_vector(31 downto 0);
	WD: in std_logic_vector(31 downto 0);
	WE: in std_logic;   --Write Enable
	ukey: in std_logic_vector(127 downto 0);
	din: in std_logic_vector(63 downto 0);
	CLK: in std_logic;
	state:in ss_type;
	RD: out std_logic_vector(31 downto 0)
	);
end DataMemory;
architecture RTL of DataMemory is
	type RAM is array (0 to 123) of STD_LOGIC_VECTOR (15 downto 0);
        SIGNAL Mem: RAM := RAM'(
      X"0000", X"0000", X"0000", X"0000",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"5163", X"b7e1",X"cb1c",
      X"5618", X"44d5", X"f450", X"be8e",X"9287",
      X"3847", X"30bf", X"b200", X"cef6",X"2bb9", 
      X"6d2e", X"a572", X"0b65", X"1f2b",X"a99d",
      X"98e4", X"47d4", X"129d", X"e60c",X"8c56",
      X"8443", X"060f", X"227b", X"7fc8",X"c0b2",
      X"f981", X"5ee9", X"733a", X"fd21",X"ecf3", 
      X"9b58", X"66ac", X"3990", X"e065",X"d7c7",
      X"5a1e", X"75ff", X"d3d7", X"1436",X"4d90",
      X"b26e", X"c749", X"50a5", X"4102",X"eedd",
      X"babb", X"8d14", X"3474", X"2b4c",X"0000", 
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000",X"0000",
      X"0000", X"0000", X"0000", X"0000"
      );
      
Begin
	Process(clk)
	Begin
        if (clk'event and clk ='0' ) then
            if (state = Res) then
                   Mem <= RAM'(
                  X"0000", X"0000", X"0000", X"0000",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000", X"0000", X"0000",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000", X"0000", X"0000",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000", X"0000", X"0000",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000", X"0000", X"0000",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000", X"5163", X"b7e1",X"cb1c",
                  X"5618", X"44d5", X"f450", X"be8e",X"9287",
                  X"3847", X"30bf", X"b200", X"cef6",X"2bb9", 
                  X"6d2e", X"a572", X"0b65", X"1f2b",X"a99d",
                  X"98e4", X"47d4", X"129d", X"e60c",X"8c56",
                  X"8443", X"060f", X"227b", X"7fc8",X"c0b2",
                  X"f981", X"5ee9", X"733a", X"fd21",X"ecf3", 
                  X"9b58", X"66ac", X"3990", X"e065",X"d7c7",
                  X"5a1e", X"75ff", X"d3d7", X"1436",X"4d90",
                  X"b26e", X"c749", X"50a5", X"4102",X"eedd",
                  X"babb", X"8d14", X"3474", X"2b4c",X"0000", 
                  X"0000", X"0000", X"0000", X"0000",X"0000",
                  X"0000", X"0000",ukey(111 downto 96),ukey(127 downto 112),ukey(79 downto 64),--114
                 ukey(95 downto 80), ukey(47 downto 32),ukey(63 downto 48), ukey(15 downto 0),ukey(31 downto 16),
                  din(47 downto 32), din(63 downto 48), din(15 downto 0), din(31 downto 16)
                  );
            elsif (WE = '1' and state = rwMem and A < 62) then
                Mem(CONV_INTEGER(A+A)) <= WD(15 DOWNTO 0);
                Mem(CONV_INTEGER(A + A + '1')) <= WD(31 DOWNTO 16);
            elsif(WE = '0' and state = rwMem and A < 62) then
                RD(15 DOWNTO 0) <= Mem(CONV_INTEGER(A+A)) ;
                RD(31 DOWNTO 16) <= Mem(CONV_INTEGER(A + A + '1'));
            end if;            
        end if;
	end Process;
	end RTL;
