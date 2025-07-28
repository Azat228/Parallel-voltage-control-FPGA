library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pin_control is
    Port (
        clk     : in  std_logic;  -- Clock signal
        enable  : in  std_logic;  -- Enable signal to control output
        pin_out : out std_logic   -- Pin output
    );
end pin_control;

architecture Behavioral of pin_control is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                pin_out <= '1';  -- Set pin high
            else
                pin_out <= '0';  -- Set pin low
            end if;
        end if;
    end process;
end Behavioral;
