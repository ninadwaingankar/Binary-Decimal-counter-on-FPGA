--binary 4 bit updown counter with decimal display on 7 segment display
--XILINX Spartan 6 Mini SP6 V2 FPGA

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;

entity counterdisplay8 is
port(clk:in std_logic;
		rst:in std_logic;
		--status:in std_logic;	--up 1 down 0 counter status
		binary:out std_logic_vector(7 downto 0);	--8 bit updown counter output
		dig1,dig2,dig3:out std_logic_vector(6 downto 0));	--for decimal output on 2, 7 seg display
end counterdisplay8;

architecture behavior of counterdisplay8 is
	signal divider:std_logic_vector(20 downto 0);	--clock divider signal
	signal bin:std_logic_vector(7 downto 0):="00000000";
	
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
-------------------process 1 ends here

-------------------process 2 binary counter starts here
	process(divider(20),rst)		
	begin
			if(rst='1') then
				bin<="00000000";
			elsif(rising_edge(divider(20))) then
				bin<=bin+'1';
				if(bin="11111111") then
					bin<="00000000";
				end if;
			end if;
	end process;
	binary<=bin;
	-----------------process 2 ends here
	
-------------------process 3 decimal counter starts here
	process(divider(20),rst)	
		variable count1:natural range 0 to 10:=0;
		variable count2:natural range 0 to 6:=0;
		variable count3:natural range 0 to 3:=0;
	begin
			if(rst='1') then
				count1:=0;
				count2:=0;
				count3:=0;
			elsif(rising_edge(divider(20))) then
				count1:=count1+1;
				if(count1=10) then
					count2:=count2+1;
					if(count2=6) then
						count3:=count3+1;
						if(count3=3) then
							count1:=0;
							count2:=0;
							count3:=0;
						end if;
					end if;	
				end if;
			end if;
	

--deimal equivalent of binary  counter output on 7 segment display	
	--codes for Common anode 7 segment display	abcdefg format
	
	--for digit 1
		case count1 is 
			when 0=>dig1<="0000001";-- shows 0
			when 1=>dig1<="1001111";-- shows 1
			when 2=>dig1<="0010010";-- shows 2
			when 3=>dig1<="0000110";-- shows 3
			when 4=>dig1<="1001100";-- shows 4
			when 5=>dig1<="0100100";-- shows 5
			when 6=>dig1<="0100000";-- shows 6
			when 7=>dig1<="0001111";-- shows 7
			when 8=>dig1<="0000000";-- shows 8 
			when 9=>dig1<="0000100";-- shows 9
			when others=>null;
		end case;
		
		--for digit 2
		case count2 is 
			when 0=>dig2<="0000001";--
			when 1=>dig2<="1001111";--
			when 2=>dig2<="0010010";--
			when 3=>dig2<="0000110";--
			when 4=>dig2<="1001100";--
			when 5=>dig2<="0100100";--
			--when 6=>dig2<="0100000";--
			--when 7=>dig2<="0001111";--
			--when 8=>dig2<="0000000";--
			--when 9=>dig2<="0000100";
			when others=>null;
		end case;
		
		--for digit 3
		case count3 is 
			when 0=>dig3<="0000001";--
			when 1=>dig3<="1001111";--
			when 2=>dig3<="0010010";--
			--when 3=>dig3<="0000110";--
			--when 4=>dig3<="1001100";--
			--when 5=>dig3<="0100100";--
			--when 6=>dig3<="0100000";--
			--when 7=>dig3<="0001111";--
			--when 8=>dig3<="0000000";--
			--when 9=>dig3<="0000100";--
			when others=>null;
		end case;	
	end process;
---------------------process 3 ends here
end behavior;
