library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic;
    clk_cnt : in std_logic_vector (4 downto 0);
    bit_cnt : in std_logic_vector (3 downto 0);
    reading_data : out std_logic;
    clk_cnt_active : out std_logic;
    valid : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal state : std_logic_vector (2 downto 0);
  signal n98_o : std_logic;
  signal n99_o : std_logic;
  signal n103_o : std_logic;
  signal n105_o : std_logic;
  signal n106_o : std_logic;
  signal n107_o : std_logic;
  signal n111_o : std_logic;
  signal n112_o : std_logic;
  signal n116_o : std_logic;
  signal n117_o : std_logic;
  signal n119_o : std_logic_vector (2 downto 0);
  signal n121_o : std_logic;
  signal n123_o : std_logic;
  signal n125_o : std_logic_vector (2 downto 0);
  signal n127_o : std_logic;
  signal n129_o : std_logic;
  signal n131_o : std_logic_vector (2 downto 0);
  signal n133_o : std_logic;
  signal n135_o : std_logic;
  signal n137_o : std_logic_vector (2 downto 0);
  signal n139_o : std_logic;
  signal n141_o : std_logic;
  signal n142_o : std_logic_vector (4 downto 0);
  signal n145_o : std_logic_vector (2 downto 0);
  signal n150_q : std_logic_vector (2 downto 0) := "000";
begin
  reading_data <= n99_o;
  clk_cnt_active <= n107_o;
  valid <= n112_o;
  -- uart_rx_fsm.vhd:26:12
  state <= n150_q; -- (isignal)
  -- uart_rx_fsm.vhd:29:36
  n98_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:29:25
  n99_o <= '0' when n98_o = '0' else '1';
  -- uart_rx_fsm.vhd:30:38
  n103_o <= '1' when state = "000" else '0';
  -- uart_rx_fsm.vhd:30:54
  n105_o <= '1' when state = "100" else '0';
  -- uart_rx_fsm.vhd:30:45
  n106_o <= n103_o or n105_o;
  -- uart_rx_fsm.vhd:30:27
  n107_o <= '1' when n106_o = '0' else '0';
  -- uart_rx_fsm.vhd:31:29
  n111_o <= '1' when state = "100" else '0';
  -- uart_rx_fsm.vhd:31:18
  n112_o <= '0' when n111_o = '0' else '1';
  -- uart_rx_fsm.vhd:40:19
  n116_o <= '1' when rising_edge (clk) else '0';
  -- uart_rx_fsm.vhd:46:32
  n117_o <= not din;
  -- uart_rx_fsm.vhd:46:25
  n119_o <= state when n117_o = '0' else "001";
  -- uart_rx_fsm.vhd:44:21
  n121_o <= '1' when state = "000" else '0';
  -- uart_rx_fsm.vhd:53:36
  n123_o <= '1' when clk_cnt = "01000" else '0';
  -- uart_rx_fsm.vhd:53:25
  n125_o <= state when n123_o = '0' else "010";
  -- uart_rx_fsm.vhd:50:21
  n127_o <= '1' when state = "001" else '0';
  -- uart_rx_fsm.vhd:59:36
  n129_o <= '1' when bit_cnt = "1000" else '0';
  -- uart_rx_fsm.vhd:59:25
  n131_o <= state when n129_o = '0' else "011";
  -- uart_rx_fsm.vhd:57:21
  n133_o <= '1' when state = "010" else '0';
  -- uart_rx_fsm.vhd:65:36
  n135_o <= '1' when clk_cnt = "10000" else '0';
  -- uart_rx_fsm.vhd:65:25
  n137_o <= state when n135_o = '0' else "100";
  -- uart_rx_fsm.vhd:63:21
  n139_o <= '1' when state = "011" else '0';
  -- uart_rx_fsm.vhd:69:21
  n141_o <= '1' when state = "100" else '0';
  n142_o <= n141_o & n139_o & n133_o & n127_o & n121_o;
  -- uart_rx_fsm.vhd:42:17
  with n142_o select n145_o <=
    "000" when "10000",
    n137_o when "01000",
    n131_o when "00100",
    n125_o when "00010",
    n119_o when "00001",
    "XXX" when others;
  -- uart_rx_fsm.vhd:40:13
  process (clk, rst)
  begin
    if rst = '1' then
      n150_q <= "000";
    elsif rising_edge (clk) then
      n150_q <= n145_o;
    end if;
  end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal clk_cnt : std_logic_vector (4 downto 0);
  signal bit_cnt : std_logic_vector (3 downto 0);
  signal reading_data : std_logic;
  signal clk_cnt_active : std_logic;
  signal valid : std_logic;
  signal fsm_reading_data : std_logic;
  signal fsm_clk_cnt_active : std_logic;
  signal fsm_valid : std_logic;
  signal n7_o : std_logic;
  signal n9_o : std_logic_vector (4 downto 0);
  signal n11_o : std_logic_vector (4 downto 0);
  signal n13_o : std_logic;
  signal n14_o : std_logic;
  signal n16_o : std_logic_vector (3 downto 0);
  signal n17_o : std_logic_vector (3 downto 0);
  signal n19_o : std_logic;
  signal n20_o : std_logic;
  signal n23_o : std_logic;
  signal n26_o : std_logic_vector (3 downto 0);
  signal n28_o : std_logic;
  signal n29_o : std_logic;
  signal n31_o : std_logic_vector (2 downto 0);
  signal n36_o : std_logic_vector (4 downto 0);
  signal n48_o : std_logic;
  signal n49_o : std_logic;
  signal n50_o : std_logic_vector (7 downto 0);
  signal n51_q : std_logic_vector (7 downto 0);
  signal n52_o : std_logic;
  signal n53_o : std_logic;
  signal n54_q : std_logic;
  signal n55_q : std_logic_vector (4 downto 0);
  signal n56_q : std_logic_vector (3 downto 0);
  signal n57_o : std_logic;
  signal n58_o : std_logic;
  signal n59_o : std_logic;
  signal n60_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic;
  signal n64_o : std_logic;
  signal n65_o : std_logic;
  signal n66_o : std_logic;
  signal n67_o : std_logic;
  signal n68_o : std_logic;
  signal n69_o : std_logic;
  signal n70_o : std_logic;
  signal n71_o : std_logic;
  signal n72_o : std_logic;
  signal n73_o : std_logic;
  signal n74_o : std_logic;
  signal n75_o : std_logic;
  signal n76_o : std_logic;
  signal n77_o : std_logic;
  signal n78_o : std_logic;
  signal n79_o : std_logic;
  signal n80_o : std_logic;
  signal n81_o : std_logic;
  signal n82_o : std_logic;
  signal n83_o : std_logic;
  signal n84_o : std_logic;
  signal n85_o : std_logic;
  signal n86_o : std_logic;
  signal n87_o : std_logic;
  signal n88_o : std_logic;
  signal n89_o : std_logic;
  signal n90_o : std_logic;
  signal n91_o : std_logic_vector (7 downto 0);
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n51_q;
  wrap_DOUT_VLD <= n54_q;
  -- uart_rx.vhd:22:12
  clk_cnt <= n55_q; -- (signal)
  -- uart_rx.vhd:23:12
  bit_cnt <= n56_q; -- (signal)
  -- uart_rx.vhd:24:12
  reading_data <= fsm_reading_data; -- (signal)
  -- uart_rx.vhd:25:12
  clk_cnt_active <= fsm_clk_cnt_active; -- (signal)
  -- uart_rx.vhd:26:12
  valid <= fsm_valid; -- (signal)
  -- uart_rx.vhd:30:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    clk_cnt => clk_cnt,
    bit_cnt => bit_cnt,
    reading_data => fsm_reading_data,
    clk_cnt_active => fsm_clk_cnt_active,
    valid => fsm_valid);
  -- uart_rx.vhd:50:15
  n7_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- uart_rx.vhd:58:36
  n9_o <= std_logic_vector (unsigned (clk_cnt) + unsigned'("00001"));
  -- uart_rx.vhd:56:13
  n11_o <= "00000" when clk_cnt_active = '0' else n9_o;
  -- uart_rx.vhd:66:24
  n13_o <= '1' when clk_cnt = "10000" else '0';
  -- uart_rx.vhd:66:34
  n14_o <= n13_o and reading_data;
  -- uart_rx.vhd:68:36
  n16_o <= std_logic_vector (unsigned (bit_cnt) + unsigned'("0001"));
  -- uart_rx.vhd:66:13
  n17_o <= bit_cnt when n14_o = '0' else n16_o;
  -- uart_rx.vhd:71:24
  n19_o <= '1' when bit_cnt = "1000" else '0';
  -- uart_rx.vhd:71:33
  n20_o <= n19_o and valid;
  -- uart_rx.vhd:71:13
  n23_o <= '0' when n20_o = '0' else '1';
  -- uart_rx.vhd:71:13
  n26_o <= n17_o when n20_o = '0' else "0000";
  -- uart_rx.vhd:80:47
  n28_o <= '1' when clk_cnt = "10000" else '0';
  -- uart_rx.vhd:80:35
  n29_o <= reading_data and n28_o;
  -- uart_rx.vhd:85:21
  n31_o <= bit_cnt (2 downto 0);  --  trunc
  -- uart_rx.vhd:80:13
  n36_o <= n11_o when n29_o = '0' else "00000";
  -- uart_rx.vhd:43:5
  n48_o <= not wrap_RST;
  -- uart_rx.vhd:43:5
  n49_o <= n29_o and n48_o;
  -- uart_rx.vhd:43:5
  n50_o <= n51_q when n49_o = '0' else n91_o;
  -- uart_rx.vhd:50:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n51_q <= n50_o;
    end if;
  end process;
  -- uart_rx.vhd:43:5
  n52_o <= not wrap_RST;
  -- uart_rx.vhd:43:5
  n53_o <= n54_q when n52_o = '0' else n23_o;
  -- uart_rx.vhd:50:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n54_q <= n53_o;
    end if;
  end process;
  -- uart_rx.vhd:50:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n55_q <= "00000";
    elsif rising_edge (wrap_CLK) then
      n55_q <= n36_o;
    end if;
  end process;
  -- uart_rx.vhd:50:9
  process (wrap_CLK, wrap_RST)
  begin
    if wrap_RST = '1' then
      n56_q <= "0000";
    elsif rising_edge (wrap_CLK) then
      n56_q <= n26_o;
    end if;
  end process;
  -- uart_rx.vhd:85:17
  n57_o <= n31_o (2);
  -- uart_rx.vhd:85:17
  n58_o <= not n57_o;
  -- uart_rx.vhd:85:17
  n59_o <= n31_o (1);
  -- uart_rx.vhd:85:17
  n60_o <= not n59_o;
  -- uart_rx.vhd:85:17
  n61_o <= n58_o and n60_o;
  -- uart_rx.vhd:85:17
  n62_o <= n58_o and n59_o;
  -- uart_rx.vhd:85:17
  n63_o <= n57_o and n60_o;
  -- uart_rx.vhd:85:17
  n64_o <= n57_o and n59_o;
  -- uart_rx.vhd:85:17
  n65_o <= n31_o (0);
  -- uart_rx.vhd:85:17
  n66_o <= not n65_o;
  -- uart_rx.vhd:85:17
  n67_o <= n61_o and n66_o;
  -- uart_rx.vhd:85:17
  n68_o <= n61_o and n65_o;
  -- uart_rx.vhd:85:17
  n69_o <= n62_o and n66_o;
  -- uart_rx.vhd:85:17
  n70_o <= n62_o and n65_o;
  -- uart_rx.vhd:85:17
  n71_o <= n63_o and n66_o;
  -- uart_rx.vhd:85:17
  n72_o <= n63_o and n65_o;
  -- uart_rx.vhd:85:17
  n73_o <= n64_o and n66_o;
  -- uart_rx.vhd:85:17
  n74_o <= n64_o and n65_o;
  n75_o <= n51_q (0);
  -- uart_rx.vhd:85:17
  n76_o <= n75_o when n67_o = '0' else wrap_DIN;
  n77_o <= n51_q (1);
  -- uart_rx.vhd:85:17
  n78_o <= n77_o when n68_o = '0' else wrap_DIN;
  n79_o <= n51_q (2);
  -- uart_rx.vhd:85:17
  n80_o <= n79_o when n69_o = '0' else wrap_DIN;
  n81_o <= n51_q (3);
  -- uart_rx.vhd:85:17
  n82_o <= n81_o when n70_o = '0' else wrap_DIN;
  n83_o <= n51_q (4);
  -- uart_rx.vhd:85:17
  n84_o <= n83_o when n71_o = '0' else wrap_DIN;
  n85_o <= n51_q (5);
  -- uart_rx.vhd:85:17
  n86_o <= n85_o when n72_o = '0' else wrap_DIN;
  n87_o <= n51_q (6);
  -- uart_rx.vhd:85:17
  n88_o <= n87_o when n73_o = '0' else wrap_DIN;
  n89_o <= n51_q (7);
  -- uart_rx.vhd:85:17
  n90_o <= n89_o when n74_o = '0' else wrap_DIN;
  n91_o <= n90_o & n88_o & n86_o & n84_o & n82_o & n80_o & n78_o & n76_o;
end rtl;
