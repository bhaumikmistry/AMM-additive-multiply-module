

library ieee;
use ieee.std_logic_1164.all;

entity amm_latch is
port( clk: in std_logic;
	  x	: in std_logic_vector(3  downto 0);
	  y	: in std_logic_vector(1  downto 0);
	  c1 : in std_logic_vector(1  downto 0);--3downto2-- 
	  c2 : in std_logic_vector(1  downto 0);--1downto0--
	  d	: in std_logic_vector(1  downto 0);
	  tp : out std_logic_vector(5 downto 0));
	  
end amm_latch;
				
architecture amm_rtl of amm_latch is
        
component add_mm is
port (	a		: in std_logic_vector(3 downto 0);
		c		: in std_logic_vector(3 downto 0);
		b 		: in std_logic_vector(1 downto 0);
		d 		: in std_logic_vector(1 downto 0);
		p		:out std_logic_vector(5 downto 0));
  end component;
  
component latch_d is
port (  D  : in  STD_LOGIC_vector(5 downto 0);
        EN : in  STD_LOGIC;
        Q  : out STD_LOGIC_vector(5 downto 0));
	end component;
	
signal  p			: std_logic_vector(15  downto 0);
signal cmerge		: std_logic_vector(3  downto 0);

begin

cmerge(1 downto 0)<= c2;
cmerge(3 downto 2)<= c1;


amm1 : add_mm port map(x(3 downto 0), cmerge(3 downto 0),		 y(1 downto 0), d(1 downto 0),				p(5 downto 0));
L1	 : latch_d port map(p(5 downto 0),clk,tp(5 downto 0));

end amm_rtl;
	

	