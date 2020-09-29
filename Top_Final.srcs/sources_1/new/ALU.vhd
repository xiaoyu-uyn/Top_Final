library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unSIGNED.all;
use IEEE.NUMERIC_STD.ALL;


entity ALU is port (
	rot_amt: in std_logic_vector(2 downto 0);
	Funct: in std_logic_vector(5 downto 0);
	SrcA: in std_logic_vector(31 downto 0);
	SrcB: in std_logic_vector(31 downto 0);
	ALUControl: in std_logic_vector(2 downto 0);
	Op: in std_logic_vector(5 downto 0);
	ALUResult: out std_logic_vector(31 downto 0);
	Zero: out std_logic);
end ALU;

architecture RTL of ALU is
signal interm1: std_logic_vector(31 downto 0);
Begin

process(SrcA, SrcB, ALUControl,rot_amt,Funct,interm1)
begin
--Zero <= '0';
    case ALUControl(2 downto 0) is
        when "000" => ALUResult <= SrcA and SrcB;
        when "001" => ALUResult <= SrcA or SrcB;
        when "010" => ALUResult <= not(SrcA or SrcB);
        when "011"=> if (SrcA < SrcB) then Zero <= '1'; else Zero <= '0'; end if;
        when "100" => 
                case Funct is 
                    when "010000" => interm1 <= SrcA xor SrcB; 
                        case rot_amt is
                            when "001" => ALUResult <= interm1(30 downto 0)&interm1(31);
                            when "010" => ALUResult <= interm1(29 downto 0)&interm1(31 downto 30);
                            when "011" => ALUResult <= interm1(28 downto 0)&interm1(31 downto 29);
                            when "100" => ALUResult <= interm1(27 downto 0)&interm1(31 downto 28);
                            when "101" => ALUResult <= interm1(26 downto 0)&interm1(31 downto 27);
                            when "110" => ALUResult <= interm1(25 downto 0)&interm1(31 downto 26);
                            when "111" => ALUResult <=interm1(24 downto 0)&interm1(31 downto 25);
                            when others => ALUResult <= interm1;
                        end case;
                    when "010001" => 
                        case rot_amt is
                            when "001" => interm1 <= SrcA(0)&SrcA(31 downto 1);
                            when "010" => interm1 <= SrcA(1 downto 0)&SrcA(31 downto 2);
                            when "011" => interm1 <= SrcA(2 downto 0)&SrcA(31 downto 3);
                            when "100" => interm1 <= SrcA(3 downto 0)&SrcA(31 downto 4);
                            when "101" => interm1 <= SrcA(4 downto 0)&SrcA(31 downto 5);
                            when "110" => interm1 <= SrcA(5 downto 0)&SrcA(31 downto 6);
                            when "111" => interm1 <= SrcA(6 downto 0)&SrcA(31 downto 7);
                            when others => interm1 <= SrcA;
                        end case;
                    ALUResult <= interm1 Xor srcB;
                    when "010101" => 
                        case rot_amt is
                            when "001" => interm1 <= SrcA(30 downto 0)&SrcA(31);
                            when "010" => interm1 <= SrcA(29 downto 0)&SrcA(31 downto 30);
                            when "011" => interm1 <= SrcA(28 downto 0)&SrcA(31 downto 29);
                            when "100" => interm1 <= SrcA(27 downto 0)&SrcA(31 downto 28);
                            when "101" => interm1 <= SrcA(26 downto 0)&SrcA(31 downto 27);
                            when "110" => interm1 <= SrcA(25 downto 0)&SrcA(31 downto 26);
                            when "111" => interm1 <= SrcA(24 downto 0)&SrcA(31 downto 25);
                            when others => interm1 <= SrcA;
                        end case;
                        ALUResult <= interm1 + SrcB;
                    when "010110" => interm1 <= SrcA - SrcB;
                        case rot_amt is
                            when "001" => ALUResult <= interm1(0)&interm1(31 downto 1);
                            when "010" => ALUResult <=interm1(1 downto 0)&interm1(31 downto 2);
                            when "011" => ALUResult <=interm1(2 downto 0)&interm1(31 downto 3);
                            when "100" => ALUResult <=interm1(3 downto 0)&interm1(31 downto 4);
                            when "101" => ALUResult <=interm1(4 downto 0)&interm1(31 downto 5);
                            when "110" => ALUResult <=interm1(5 downto 0)&interm1(31 downto 6);
                            when "111" => ALUResult <=interm1(6 downto 0)&interm1(31 downto 7);
                            when others => ALUResult <= interm1;
                        end case;
                    when others => null;  
            end case;
        when "101" => ALUResult <= SrcA + SrcB;  --Lw Sw
        when "110" => if (SrcA = SrcB) then Zero <= '1'; else Zero <= '0'; end if;
        when "111" => if (SrcA /= SrcB) then Zero <= '1'; else Zero <= '0'; end if;
        when others => null;
        
    end case;

end process;
end RTL;

	