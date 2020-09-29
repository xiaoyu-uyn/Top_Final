-- Name: Xiaoyu Qiao
-- N number: N18302199
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use WORK.stype.all;

entity Registera is port (
	A1: in std_logic_vector(4 downto 0);
	A2: in std_logic_vector(4 downto 0);
	A3: in std_logic_vector(4 downto 0);
	WD3: in std_logic_vector(31 downto 0);
	CLK: in std_logic;
	state:in ss_type;
	WE3: in std_logic;
	RD1: out std_logic_vector(31 downto 0);
	display:out std_logic_vector(63 downto 0);--
	RD2: out std_logic_vector(31 downto 0)
	);
end Registera;
architecture RTL of Registera is
	TYPE RAM is ARRAY (0 to 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Rec: RAM := RAM'(X"00000000", X"00000000", 
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --6
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --11
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --16
      X"00000000", X"00000000", X"00000007", X"00000001", X"00000019", --21
      X"00000003", X"0000004D", X"00000000", X"00000000", X"00000000", --26
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000" --31
      );
	begin	
		Process(CLK)
		Begin
		    display <= Rec(1) & Rec(2);
			if (CLK'event and CLK ='0' ) then ----changed 0,1
                if (state = Res) then
                      Rec <= RAM'(X"00000000", X"00000000", 
                              X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --6
                              X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --11
                              X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --16
                              X"00000000", X"00000000", X"00000007", X"00000001", X"00000019", --21
                              X"00000003", X"0000004D", X"00000000", X"00000000", X"00000000", --26
                              X"00000000", X"00000000", X"00000000", X"00000000", X"00000000" --31
                              );
                elsif (state = ReadReg) then
                    case A2 is
                        when "00001" => RD2 <= Rec(1);
                        when "00010" => RD2 <= Rec(2);
                        when "00011" => RD2 <= Rec(3);
                        when "00100" => RD2 <= Rec(4);
                        when "00101" => RD2 <= Rec(5);
                        when "00110" => RD2 <= Rec(6);
                        when "00111" => RD2 <= Rec(7);
                        when "01000" => RD2 <= Rec(8);
                        when "01001" => RD2 <= Rec(9);
                        when "01010" => RD2 <= Rec(10);
                        when "01011" => RD2 <= Rec(11);
                        when "01100" => RD2 <= Rec(12);
                        when "01101" => RD2 <= Rec(13);
                        when "01110" => RD2 <= Rec(14);
                        when "01111" => RD2 <= Rec(15);
                        when "10000" => RD2 <= Rec(16);
                        when "10001" => RD2 <= Rec(17);
                        when "10010" => RD2 <= Rec(18);
                        when "10011" => RD2 <= Rec(19);
                        when "10100" => RD2 <= Rec(20);
                        when "10101" => RD2 <= Rec(21);
                        when "10110" => RD2 <= Rec(22);
                        when "10111" => RD2 <= Rec(23);
                        when "11000" => RD2 <= Rec(24);
                        when "11001" => RD2 <= Rec(25);
                        when "11010" => RD2 <= Rec(26);
                        when "11011" => RD2 <= Rec(27);
                        when "11100" => RD2 <= Rec(28);
                        when "11101" => RD2 <= Rec(29);
                        when "11110" => RD2 <= Rec(30);
                        when "11111" => RD2 <= Rec(31);
                        when others => RD2 <= Rec(0);
                    end case;
                    case A1 is
                        when "00001" => RD1 <= Rec(1);
                        when "00010" => RD1 <= Rec(2);
                        when "00011" => RD1 <= Rec(3);
                        when "00100" => RD1 <= Rec(4);
                        when "00101" => RD1 <= Rec(5);
                        when "00110" => RD1 <= Rec(6);
                        when "00111" => RD1 <= Rec(7);
                        when "01000" => RD1 <= Rec(8);
                        when "01001" => RD1 <= Rec(9);
                        when "01010" => RD1 <= Rec(10);
                        when "01011" => RD1 <= Rec(11);
                        when "01100" => RD1 <= Rec(12);
                        when "01101" => RD1 <= Rec(13);
                        when "01110" => RD1 <= Rec(14);
                        when "01111" => RD1 <= Rec(15);
                        when "10000" => RD1 <= Rec(16);
                        when "10001" => RD1 <= Rec(17);
                        when "10010" => RD1 <= Rec(18);
                        when "10011" => RD1 <= Rec(19);
                        when "10100" => RD1 <= Rec(20);
                        when "10101" => RD1 <= Rec(21);
                        when "10110" => RD1 <= Rec(22);
                        when "10111" => RD1 <= Rec(23);
                        when "11000" => RD1 <= Rec(24);
                        when "11001" => RD1 <= Rec(25);
                        when "11010" => RD1 <= Rec(26);
                        when "11011" => RD1 <= Rec(27);
                        when "11100" => RD1 <= Rec(28);
                        when "11101" => RD1 <= Rec(29);
                        when "11110" => RD1 <= Rec(30);
                        when "11111" => RD1 <= Rec(31);
                        when others => RD1 <= Rec(0);
                    end case;
                    elsif(state = WriteReg) then
                        if (WE3 = '1') then
                            case A3 is
                                when "00001" =>  Rec(1) <= WD3;
                                when "00010" =>  Rec(2) <= WD3;
                                when "00011" =>  Rec(3) <= WD3;
                                when "00100" =>  Rec(4) <= WD3;
                                when "00101" =>  Rec(5) <= WD3;
                                when "00110" =>  Rec(6) <= WD3;
                                when "00111" =>  Rec(7) <= WD3;
                                when "01000" =>  Rec(8) <= WD3;
                                when "01001" =>  Rec(9) <= WD3;
                                when "01010" =>  Rec(10) <= WD3;
                                when "01011" =>  Rec(11) <= WD3;
                                when "01100" =>  Rec(12) <= WD3;
                                when "01101" =>  Rec(13) <= WD3;
                                when "01110" =>  Rec(14) <= WD3;
                                when "01111" =>  Rec(15) <= WD3;
                                when "10000" =>  Rec(16) <= WD3;
                                when "10001" =>  Rec(17) <= WD3;
                                when "10010" =>  Rec(18) <= WD3;
                                when "10011" =>  Rec(19) <= WD3;
                                when "10100" =>  Rec(20) <= WD3;
                                when "10101" =>  Rec(21) <= WD3;
                                when "10110" =>  Rec(22) <= WD3;
                                when "10111" =>  Rec(23) <= WD3;
                                when "11000" =>  Rec(24) <= WD3;
                                when "11001" =>  Rec(25) <= WD3;
                                when "11010" =>  Rec(26) <= WD3;
                                when "11011" =>  Rec(27) <= WD3;
                                when "11100" =>  Rec(28) <= WD3;
                                when "11101" =>  Rec(29) <= WD3;
                                when "11110" =>  Rec(30) <= WD3;
                                when "11111" =>  Rec(31) <= WD3;
                                when others => null;
                            end case;
                            end if;
				end if;
			end if;
		end Process;
	end RTL;