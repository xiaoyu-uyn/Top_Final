library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;


entity test is
--  Port ( );
end test;

architecture Behavioral of test is
component CPU_top port( 
        CLK100MHZ   : IN     STD_LOGIC;
        BTNL   : in std_logic;  -- reset to decrption (default)
        BTND: in STD_LOGIC;     -- reset to decrption
        BTNU : in STD_LOGIC;
        BTNR : in STD_LOGIC;
        L1   : out std_logic;
        LED0 : out std_logic;
        BTNC : in STD_LOGIC;
        SW   : in STD_LOGIC_VECTOR (15 downto 0);
        seg 		: out  STD_LOGIC_VECTOR (7 downto 0);
        an 		: out  STD_LOGIC_VECTOR (3 downto 0)
);
end component;
signal main_clock : std_logic;
signal btnc       : std_logic;
signal btnu       : std_logic;
signal btnd       : std_logic;
signal btnl       : std_logic;
signal btnr       : std_logic;
signal cur_in     : std_logic_vector(7 downto 0);
signal address     : std_logic_vector(7 downto 0);
signal led0       : std_logic;
signal led1       : std_logic;
signal sseg_ca    : std_logic_vector(07 downto 0);
signal sseg_an    : std_logic_vector(03 downto 0);
signal display    : STD_LOGIC_VECTOR (63 downto 0);


--File operation
file file_input : text;
file file_output : text;
signal input_ref : std_logic_vector(7 downto 0);
signal output_ref : std_logic_vector(63 downto 0);

constant main_clock_period : time := 20ns; --change the clock period of the clock, HERE.

begin

process --File operation process
    variable enc_in : line;
    variable enc_out : line;
    variable enc_input : std_logic_vector(7 downto 0);
    variable enc_output : std_logic_vector(63 downto 0);
    variable i_cnt: integer:= 0;
begin
-- File operations.
    report "in process loop";
    file_open(file_input,  "D:/3-Ee/2018/statem/testfile/changed_/Top_Final/testdata.txt",  read_mode);
    file_open(file_output,  "D:/3-Ee/2018/statem/testfile/changed_/Top_Final/testout.txt",  read_mode);
 --Run the loop till all the file content is not read.
    while not endfile(file_input) loop
        if (i_cnt < 11) then
            btnc <= '0';
            btnl <= '0';
            btnd <= '0';
            btnu <= '0';
            btnr <= '0';
            wait for 6000ns;
            address <= "00000000";
            readline(file_input, enc_in);
            read(enc_in, enc_input);
            input_ref  <= enc_input;
            wait for 100ns;
            btnl <= '1';
            wait for 3000ns;
            cur_in <= input_ref;                            -- read din
            report "din = " & to_hstring(input_ref); 
            wait for 5000ns;
            btnl <= '0';
            wait for 3000ns;
            btnc <= '1';
            address <= "11111111";
            wait for 3000ns;
            btnl <= '1';
            readline(file_input, enc_in);
            read(enc_in, enc_input);
            input_ref  <= enc_input;
            cur_in <= input_ref;                            -- read key
            report "ukey = " & to_hstring(input_ref);
            wait for 1000ns;
            btnl <= '0';
            wait for 3000ns;
            btnc <= '0';
            wait for 370000ns;
            readline(file_output, enc_out);
            read(enc_out, enc_output);
            output_ref  <= enc_output;
            wait for 100ns;
            BTNR <= '0';
            BTNU <= '0';
            wait for 100ns;
            if(display = output_ref)  then
            --print to TCL console
                report "Input pattern correct." & (to_hstring(display));
            else
            --print to TCL console
                report "Input pattern is NOT correct." & to_hstring(display) severity error;
            end if;   
            wait for 100ns;
            i_cnt := i_cnt + 1;
        else
            btnc <= '0';
            btnl <= '0';
            btnd <= '0';
            btnu <= '0';
            btnr <= '0';
            wait for 2500ns;
            readline(file_input, enc_in);
            read(enc_in, enc_input);
            input_ref  <= enc_input;
            btnd <= '1';
            cur_in <= input_ref;                            -- read din
            report "din = " & to_hstring(input_ref); 
            wait for 5000ns;
            btnc <= '1';
            wait for 5000ns;
            readline(file_input, enc_in);
            read(enc_in, enc_input);
            input_ref  <= enc_input;
            cur_in <= input_ref;                            -- read key
            report "ukey = " & to_hstring(input_ref);
            wait for 1000ns;
            btnd <= '0';
            wait for 1000000ns;
            readline(file_output, enc_out);
            read(enc_out, enc_output);
            output_ref  <= enc_output;
            if(display = output_ref)  then
            --print to TCL console
                report "Input pattern correct." & (to_hstring(display));
            else
            --print to TCL console
                report "Input pattern is NOT correct." & to_hstring(display) severity error;
            end if;   
            i_cnt := i_cnt + 1;
             wait for 100ns;
        end if; 
    end loop;
    file_close(file_input);
    file_close(file_output);
    wait; -- put wait for EVERY process that you dont want to repeat continously.
end process;


process begin
    main_clock  <= '0';
    wait for main_clock_period/2; 
    main_clock  <= '1';
    wait for main_clock_period/2;
end process;

--Instantiation of module
dut: CPU_top port map(
            CLK100MHZ => main_clock,
            BTNL => btnl,
            BTND => btnd,
            BTNU => btnu,
            BTNR => btnr,
            BTNC => btnc,
            SW(15 downto 8) => cur_in,
            SW(7 downto 0) => address,
            L1 =>  led1, --useless
            LED0 =>  led0, --useless
            testdisplay => display,
            seg => sseg_ca,
            an => sseg_an
);
end Behavioral;
