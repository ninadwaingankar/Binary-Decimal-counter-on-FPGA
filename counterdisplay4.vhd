--binary 4 bit updown counter with decimal display on 7 segment display
--XILINX Spartan 6 Mini SP6 V2 FPGA

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counterdisplay4 is
port(clk:in std_logic;
		rst:in std_logic;
		--status:in std_logic;	--up 1 down 0 counter status
		binary:out std_logic_vector(3 downto 0);	--8 bit updown counter output
		dig1:out std_logic_vector(13 downto 0));	--for decimal output on 2, 7 seg display
end counterdisplay4;

architecture behav of counterdisplay4 is
	signal divider:std_logic_vector(23 downto 0);	--clock divider signal
	signal bin:std_logic_vector(3 downto 0):="0000";
	
begin
-----------------process 1 clock division
	process(clk,rst) 
	begin
		if(rst='1') then
			divider<=(others=>'0');
		elsif(rising_edge(clk)) then
			divider<=divider+'1';
		end if;
	end process;
-------------------process 1 end here

-------------------process 2 main counter
	process(divider(23),rst)
		variable count:natural range 0 to 16:=0;		
	begin
		--if(status='1') then	--up counter
			if(rst='1') then
				bin<="0000";
				count:=0;
			elsif(rising_edge(divider(23))) then
				bin<=bin+'1';
				count:=count+1;
				if(count=16 or bin="1111") then
					count:=0;
					bin<="0000";
				end if;
			end if;
	----------------------------------------

--deimal equivalent of binary  counter output on 7 segment display	
	--codes for Common anode 7 segment display	abcdefg format
	
	--for digit 1
		case count is 
			when 0=>dig1<="00000010000001";-- shows 0
			when 1=>dig1<="00000011001111";-- shows 1
			when 2=>dig1<="00000010010010";-- shows 2
			when 3=>dig1<="00000010000110";-- shows 3
			when 4=>dig1<="00000011001100";-- shows 4
			when 5=>dig1<="00000010100100";-- shows 5
			when 6=>dig1<="00000010100000";-- shows 6
			when 7=>dig1<="00000010001111";-- shows 7
			when 8=>dig1<="00000010000000";-- shows 8 
			when 9=>dig1<="00000010000100";-- shows 9
			when 10=>dig1<="10011110000001";--shows 10
			when 11=>dig1<="10011111001111";-- shows 11
			when 12=>dig1<="10011110010010";-- shows 12
			when 13=>dig1<="10011110000110";-- shows 13
			when 14=>dig1<="10011111001100";-- shows 14
			when 15=>dig1<="10011110100100";-- shows 15
			when others=>null;
		end case;
	end process;
binary<=bin;	
	---------------------
end behav;
