-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Michal Repčík (xrepcim00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_RX_FSM is
    port(
        --INPUT--
        CLK             : in std_logic;                         -- clock
        RST             : in std_logic;                         -- reset
        DIN             : in std_logic;                         -- data input
        CLK_CNT         : in std_logic_vector(4 downto 0);      -- clock counter
        BIT_CNT         : in std_logic_vector(3 downto 0);      -- bit counter
        --OUTPUT--
        READING_DATA    : out std_logic;                        -- reading data input
        CLK_CNT_ACTIVE  : out std_logic;                        -- clock counter is active
        VALID           : out std_logic                         -- data input is valid
    );
end entity;

architecture behavioral of UART_RX_FSM is
    --FSM STATES--
    type states is (IDLE, START_BIT, READ_BIT, STOP_BIT, VALIDATE);
    signal state : states := IDLE; 
begin
    --OUTPUTS--
    READING_DATA <= '1' when state = READ_BIT else '0';
    CLK_CNT_ACTIVE <= '0' when state = IDLE or state = VALIDATE else '1';
    VALID <= '1' when state = VALIDATE else '0';
    --START CLOCK--
    process(CLK) begin

            if RST = '1' then
                state <= IDLE;
            --   __    __         __    __    _
            -- _|  \__|  \_ ... _|  \__/  \__|
            --     SB  B0         B6 B7 SB
            elsif rising_edge(CLK) then
                --FSM--
                case state is
                    --IDLE STATE--
                    when IDLE =>
                        -- 0 indicates start bit
                        if DIN = '0' then
                            state <= START_BIT;
                        end if;
                    --START BIT--
                    when START_BIT =>
                        -- wait 8 clock cycles
                        -- reach the middle of start bit
                        if CLK_CNT = "01000" then -- 8
                            state <= READ_BIT;
                        end if;
                    --READ BIT--
                    when READ_BIT => 
                        -- wait for 8 bits to be processed
                        if BIT_CNT = "1000" then -- 8
                            state <= STOP_BIT;
                        end if;
                    --STOP BIT--
                    when STOP_BIT =>
                        -- wait 16 clock cycles
                        if CLK_CNT = "10000" then -- 16
                            state <= VALIDATE;
                        end if;
                    --VALIDATE--
                    when VALIDATE =>
                        -- reset to idle
                        state <= IDLE;
                end case;
        end if;
    end process;
end architecture;