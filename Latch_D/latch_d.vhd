library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch_d is
    Port ( D  : in  STD_LOGIC_vector(5 downto 0);
           EN : in  STD_LOGIC;
           Q  : out STD_LOGIC_vector(5 downto 0));
end latch_d;

architecture Behavioral of latch_d is
    signal DATA : STD_LOGIC;
    signal zero : std_logic_vector(5 downto 0);
begin
	
	process(D, EN)
    begin

        -- clock rising edge

	if (EN='1' and EN'event) then
	    Q <= D;
	end if;

    end process;
	
end Behavioral;