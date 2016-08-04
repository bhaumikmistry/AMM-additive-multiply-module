library ieee;
use ieee.std_logic_1164.all;

entity add_mm is
  port (a		: in std_logic_vector(3 downto 0);
		c		: in std_logic_vector(3 downto 0);
		b 		: in std_logic_vector(1 downto 0);
		d 		: in std_logic_vector(1 downto 0);
		p		: out std_logic_vector(5 downto 0));
  end add_mm;
	  
architecture add_rtl of add_mm is

component full_adder_test is
  port( a,b,c	: in std_logic;
		ca,sum	: out std_logic
	);
  end component;
  
--component half_adder_test is
--  port( a,b 	:in std_logic;
--	ca,sum		: out std_logic
--	);
--  end component;
    
signal cat, st 		: std_logic_vector (7 downto 0);
signal ab0, ab1		: std_logic_vector (3 downto 0);

begin



ab0(0) <= a(0) and b(0);
ab0(1) <= a(1) and b(0);
ab0(2) <= a(2) and b(0);
ab0(3) <= a(3) and b(0);

ab1(0) <= a(0) and b(1);
ab1(1) <= a(1) and b(1);
ab1(2) <= a(2) and b(1);
ab1(3) <= a(3) and b(1);

fa1: full_adder_test port map(ab0(0),d(0),  c(0),  cat(0),st(0));
fa2: full_adder_test port map(ab0(1),ab1(0),c(1),  cat(1),st(1)); 
fa3: full_adder_test port map(ab0(2),ab1(1),c(2),  cat(2),st(2)); 
fa4: full_adder_test port map(ab0(3),ab1(2),c(3),  cat(3),st(3)); 
fa5: full_adder_test port map(st(1) ,cat(0),d(1),  cat(4),st(4)); 
fa6: full_adder_test port map(st(2) ,cat(1),cat(4),cat(5),st(5)); 
fa7: full_adder_test port map(st(3), cat(2),cat(5),cat(6),st(6));
fa8: full_adder_test port map(ab1(3),cat(3),cat(6),cat(7),st(7));


P(0) <= st(0); 
p(1) <= st(4);
p(2) <= st(5);
p(3) <= st(6);
p(4) <= st(7);
p(5) <= cat(7);



end add_rtl;

  