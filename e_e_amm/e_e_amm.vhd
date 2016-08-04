library ieee;
use ieee.std_logic_1164.all;

entity e_e_amm is
port( --clk: in std_logic_vector;
	  x	: in std_logic_vector(7  downto 0);
	  y	: in std_logic_vector(7  downto 0);
	  p :out std_logic_vector(15 downto 0));
end e_e_amm;
				
architecture amm_rtl of e_e_amm is
  		
component add_mm is
port (	a		: in std_logic_vector(3 downto 0);
		c		: in std_logic_vector(3 downto 0);
		b 		: in std_logic_vector(1 downto 0);
		d 		: in std_logic_vector(1 downto 0);
		p		:out std_logic_vector(5 downto 0));
  end component;
	  
signal 	pl,ph		: std_logic_vector(23 downto 0);
signal  tc			: std_logic_vector(15 downto 0);


begin



amm1 : add_mm port map(x(3 downto 0), "0000",		 y(1 downto 0), "00",				pl(5 downto 0));
tc(1 downto 0) <= pl(3 downto 2);
amm2 : add_mm port map(x(7 downto 4), "0000",		 y(1 downto 0), pl(5 downto 4),		ph(5 downto 0));
tc(3 downto 2) <= ph(1 downto 0);
amm3 : add_mm port map(x(3 downto 0), tc(3 downto 0),y(3 downto 2), "00",			 	pl(11 downto 6));
tc(5 downto 4) <= pl(9 downto 8);
amm4 : add_mm port map(x(7 downto 4), ph(5 downto 2),y(3 downto 2), pl(11 downto 10),	ph(11 downto 6));
tc(7 downto 6) <= ph(7 downto 6);
amm5 : add_mm port map(x(3 downto 0), tc(7 downto 4),y(5 downto 4), "00",				pl(17 downto 12));
tc(9 downto 8) <= pl(15 downto 14);
amm6 : add_mm port map(x(7 downto 4), ph(11 downto 8),y(5 downto 4), pl(17 downto 16),	ph(17 downto 12));
tc(11 downto 10)<= ph(13 downto 12);
amm7 : add_mm port map(x(3 downto 0), tc(11 downto 8),y(7 downto 6),"00",				pl(23 downto 18));
tc(13 downto 12)<= pl(21 downto 20);
amm8 : add_mm port map(x(7 downto 4), ph(17 downto 14),y(7 downto 6),pl(23 downto 22),	ph(23 downto 18));
tc(15 downto 14) <= ph(19 downto 18);

p(1 downto 0)	<=	pl(1 downto 0);
p(3 downto 2)	<=	pl(7 downto 6);
p(5 downto 4)	<=	pl(13 downto 12);
p(9 downto 6)	<=	pl(21 downto 18);
p(15 downto 10)	<=  ph(23 downto 18);


end amm_rtl;
