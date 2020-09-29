-- Name: Xiaoyu Qiao
-- N number: N18302199
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.stype.all;

entity Control is port (
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
end Control;
architecture RTL of Control is
signal h: std_logic:='1';
signal l: std_logic:='0';
	Begin
	process(Op, Funct,state)
	begin
	   if(state = Res) then
            Reset <= h ;
            ALUControl <= "000";
            ALUSrc <= l;
            MemtoReg <= l;
            RegDst <= l;
            RegWrite <= l;
            Branch <= l;
            MemWrite <= l;
            JMP <= l;
        else
			case Op is
				when "000000" => Branch <= l;MemWrite <= l;JMP <= l;Reset <= l;MemtoReg <= l;
					case funct is
						when "010010" => ALUControl <= "000"; ALUSrc <= l; MemtoReg <= l; RegDst <= l; RegWrite <= h; --AND
						when "010011" => ALUControl <= "001"; ALUSrc <= l; MemtoReg <= l; RegDst <= l; RegWrite <= h;  --OR
						when "010100" => ALUControl <= "010"; ALUSrc <= l; MemtoReg <= l; RegDst <= l; RegWrite <= h;  --NOR
						when "010000" => ALUControl <= "100"; RegDst <= l; RegWrite <= h;ALUSrc <= l;  --XRLS
						when "010001" => ALUControl <= "100"; RegDst <= l; RegWrite <= h;ALUSrc <= l;  --RSXR
						when "010101" => ALUControl <= "100"; RegDst <= l; RegWrite <= h;ALUSrc <= l;  --LSAD
						when "010110" => ALUControl <= "100"; RegDst <= l; RegWrite <= h;ALUSrc <= l;  --SBRS
						when others => null;
					end case;
				when "000011" => ALUSrc <= h; RegDst <= h; RegWrite <= h;ALUControl <= "000";
				    Branch <= l;MemWrite <= l;JMP <= l;Reset <= l;MemtoReg <= l;  --ANDI
				when "000100" => ALUSrc <= h; RegDst <= h; RegWrite <= h;ALUControl <= "001";
				    Branch <= l;MemWrite <= l;JMP <= l;Reset <= l; MemtoReg <= l; --ORI
				when "000111" => MemtoReg <= h;ALUSrc <= h; RegDst <= h; RegWrite <= h;ALUControl <= "101";
				    Branch <= l;MemWrite <= l;JMP <= l;Reset <= l;  --LW
				when "001000" => MemWrite <= h;ALUSrc <= h;ALUControl <= "101";
				    Branch <= l;RegWrite <= l;JMP <= l;Reset <= l;MemtoReg <= l;  --SW
				when "001001" => ALUControl <= "011";Branch <= h;
				      RegWrite <= l;MemWrite <= l;JMP <= l;Reset <= l;ALUSrc <= l;MemtoReg <= l;--BLT
				when "001010" => ALUControl <= "110";Branch <= h;
				      RegWrite <= l;MemWrite <= l;JMP <= l;Reset <= l;ALUSrc <= l;MemtoReg <= l;--BEQ
				when "001011" => ALUControl <= "111";Branch <= h;
				      RegWrite <= l;MemWrite <= l;JMP <= l;Reset <= l;ALUSrc <= l;MemtoReg <= l;--BNE
				when "001100" => JMP <= h;
				    Branch <= l;RegWrite <= l;MemWrite <= l;Reset <= l;MemtoReg <= l; -- JMP
				when "111111" => Reset <= h ;
				    ALUControl <= "000";
                    ALUSrc <= l;
                    MemtoReg <= l;
                    RegDst <= l;
                    RegWrite <= l;
                    Branch <= l;
                    MemWrite <= l;
                    JMP <= l;  --HAL
				when others => null;
			end case;
	    end if;
		end process;
	end RTL;
			
	