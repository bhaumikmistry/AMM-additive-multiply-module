library ieee;
use ieee.std_logic_1164.all;

entity full_adder_test is
port( a,b,c: in std_logic;
	sum,ca: out std_logic
	);
end full_adder_test;

architecture rtl1 of full_adder_test is 

signal S1, S2, S3: std_logic;
begin

		s1      <= ( a XOR b );       --after 15 ns; 
		s2      <= ( c AND s1 ); 	 --after 5 ns; 
		s3      <= ( a AND b );       --after 5 ns; 	

--PROCESS(clk)
--		BEGIN
--		IF clk'EVENT AND clk = '1' THEN
			
		Sum  	<= ( s1 XOR c )	;	 --after 15 ns; 
		ca	 	<= ( s2 OR s3 );      --after 5 ns;
--		end if;
--		end process;
end rtl1;
