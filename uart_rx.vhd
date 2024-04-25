-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Michal Repčík (xrepcim00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    --SIGNALS--
    signal clk_cnt          : std_logic_vector(4 downto 0);
    signal bit_cnt          : std_logic_vector(3 downto 0);
    signal reading_data     : std_logic;
    signal clk_cnt_active   : std_logic;
    signal valid            : std_logic;
    
begin
    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    --PORTS--
    port map (
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        CLK_CNT => clk_cnt,
        BIT_CNT => bit_cnt,
        READING_DATA => reading_data,
        CLK_CNT_ACTIVE => clk_cnt_active,
        VALID => valid
    );
    --START CLOCK--
    process(CLK) begin
        --RESET COUNTERS--
        if RST = '1' then
            -- reset clock counter and bit counter to 0
            clk_cnt <= "00000";
            bit_cnt <= "0000";

        elsif rising_edge(CLK) then
            -- output 0
            DOUT_VLD <= '0';
            -----------------------------------------------------
            ------------------- CLOCK COUNTER -------------------
            -----------------------------------------------------
            if clk_cnt_active = '1' then
                -- increment clock counter when its active
                clk_cnt <= clk_cnt + 1;
            else
                -- reset it otherwise
                clk_cnt <= "00000";
            end if;
            -----------------------------------------------------
            -------------------- BIT COUNTER --------------------
            -----------------------------------------------------
            if clk_cnt = "10000" and reading_data = '1' then
                -- increment bit counter when clk_cnt is equal to 16
                bit_cnt <= bit_cnt + 1;
            end if;

            if bit_cnt = "1000" and valid = '1' then
                -- reset bit counter when it reaches 8
                bit_cnt <= "0000";
                -- if data is valid output 1
                DOUT_VLD <= '1';
            end if;
            -----------------------------------------------------
            ----------------------- DOUT ------------------------
            -----------------------------------------------------
            if reading_data = '1' and clk_cnt = "10000" then
                -- reset clock counter when clk_cnt is equal to 16
                -- and data is being read
                clk_cnt <= "00000";
                -- output data input indexed with converted bit_cnt
                DOUT(conv_integer(bit_cnt)) <= DIN;
            end if;
            -----------------------------------------------------
        end if;
    end process;
end architecture;