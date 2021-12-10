-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): xvrabl05
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK   : in std_logic;
   RST   : in std_logic;
   DIN   : in std_logic;
   CLOCK_CNT : in std_logic_vector(4 downto 0);
   BIT_CNT : in std_logic_vector(3 downto 0);
   D_VLD : out std_logic;
   CLOCK_CNT_EN : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
   type STATE_TYPE is (START_BIT,D0_BIT, BIT, STOP_BIT);
   signal state : STATE_TYPE := START_BIT;
begin   
   D_VLD <= '1' when state = BIT else '0';
   CLOCK_CNT_EN <= '0' when state = START_BIT else '1';
   process (CLK,RST,CLOCK_CNT,state) begin
      if rising_edge(CLK) then
         if RST = '1' then
            state <= START_BIT;
         else
            case state is
               when START_BIT => if DIN = '0' then state <= D0_BIT; end if;
               when D0_BIT => if CLOCK_CNT = "11000" then state <= BIT; end if;
               when BIT => if BIT_CNT > "1000" then state <= STOP_BIT; 
                           else state <= BIT; end if;
               when STOP_BIT => if DIN = '1' then state <= START_BIT; end if;
               when others => null;
            end case;
         end if;
      end if;
   end process;
end behavioral;
