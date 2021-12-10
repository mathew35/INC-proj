-- uart.vhd: UART controller - receiving part
-- Author(s): xvrabl05
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD: 	inout std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
	signal clock_cnt : std_logic_vector(4 downto 0):="00000";
	signal bit_cnt : std_logic_vector(3 downto 0);
	signal d_out : std_logic_vector(7 downto 0);
	signal d_vld : std_logic;
	signal clk_cnt_en : std_logic;
begin	
    FSM: entity work.UART_FSM(behavioral)
    port map (
		CLK => clk,
		RST => rst,
		DIN => din,
        CLOCK_CNT => clock_cnt,
        BIT_CNT => bit_cnt,
		D_VLD => d_vld,
		CLOCK_CNT_EN => clk_cnt_en
    );
	process (CLK,clock_cnt,bit_cnt,d_vld,clk_cnt_en) begin
		if rising_edge(CLK) then
			DOUT_VLD <= '0';
			if clk_cnt_en = '1' then
				clock_cnt <= clock_cnt + 1 ;
			else
				clock_cnt <= "00001";
			end if;
			if d_vld = '1' then
				if clock_cnt > "01110" then
					clock_cnt <= "00000";
					case bit_cnt is
						when "0000" => d_out(0) <= DIN;
						when "0001" => d_out(1) <= DIN;
						when "0010" => d_out(2) <= DIN;
						when "0011" => d_out(3) <= DIN;
						when "0100" => d_out(4) <= DIN;
						when "0101" => d_out(5) <= DIN;
						when "0110" => d_out(6) <= DIN;
						when "0111" => d_out(7) <= DIN;
						when others => null;
					end case;
					bit_cnt <= bit_cnt + 1;				
				end if;
				if bit_cnt = "1000" then 
					bit_cnt <= bit_cnt + 1;	
					DOUT_VLD <= '1';
					DOUT <= d_out;
				end if;	
			else
				bit_cnt <= "0000";
				DOUT <= "XXXXXXXX";
			end if;
		end if;
	end process;
end behavioral;
