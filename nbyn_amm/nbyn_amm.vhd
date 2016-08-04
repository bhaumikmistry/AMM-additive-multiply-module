--
library ieee;
use ieee.std_logic_1164.All;

entity nbyn_amm is
	
	generic(N		: integer :=32);	--- Changing the N integer determines the NxN 
	port(	clk		: std_logic;
	 	    x		: in std_logic_vector(N-1 downto 0);
		    y		: in std_logic_vector(N-1 downto 0);
	 	    p		: out std_logic_vector(N+N-1 downto 0)
	 	    );

			end nbyn_amm;
		
architecture add_rtl of nbyn_amm is
constant r : natural := integer (N/4);	-- for row of the n by n matrix
constant c : natural := integer (N/2);	-- for col of the n by n matrix

-----------------------------Component Amm_Latch-----------------------------
-- It consists of one 4x2 amm and one latch which holds the amm output for the 
-- maximam delay of an amm. The idea of merging the amm and a latch is to 
-- avoid the number of inter-connection to be made. 
-----------------------------------------------------------------------------
component amm_latch is
port( clk: in std_logic;
	  x	: in std_logic_vector(3  downto 0);
	  y	: in std_logic_vector(1  downto 0);
	  c1 : in std_logic_vector(1  downto 0);--3downto2-- 
	  c2 : in std_logic_vector(1  downto 0);--1downto0--
	  d	: in std_logic_vector(1  downto 0);
	  tp : out std_logic_vector(5 downto 0));
end component;

--signal cd feeds zeros to initial row and initial col of the matrix--
signal cd : std_logic_vector(6 downto 0) := (0 => '0', others => '0');
-- Signal pt is wire which connects P to C and D of the next amm.
signal pt : std_logic_vector((r*c*6) downto 0);


begin
--- For loop with J changes the values of signal Y--
for_loop_1: for j in 1 to c generate
begin

--- For loop with I changes the va;ues of signal X--
for_loop_2: for i in 1 to r generate
begin
    
----------------Type I--------------------------------------

	if_typeI: if (j=1) generate	
			-----------Sub-Types I,II and III-----------------			   
			
			--first row and last block--
			if_subtypeI: if (i=r) and (r>1) generate 
			
				amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								cd(5 downto 4),
								cd(3 downto 2),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
			
			end generate if_subtypeI;
			
			if_subtypeII:if (i=1) generate
			
				amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								cd(5 downto 4),
								cd(3 downto 2),
								cd(1 downto 0),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
				p((2*j)-1 downto (2*j)-2) <= pt(((r*6*j)-(6*(r-i)))-5 downto ((r*6*j)-(6*(r-i)))-6);
				
			end generate if_subtypeII;
			
			if_subtypeIII: if ((i>1) and (i<r)) generate
			
				amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								cd(5 downto 4),
								cd(3 downto 2),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
			
			end generate if_subtypeIII;
			
			---------------End of sub-types--------------------
	
	end generate if_typeI;		
	
----------------End of Type I--------------------------------

----------------Type II--------------------------------------

	if_typeII: if ((i=1) and (j>1)) generate
		if_sub1:if (j<c) generate
		amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-((r*6)-2) downto (((r*6*j)-(6*(r-i)))-2)-((r*6)-2)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								cd(1 downto 0),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
		p((2*j)-1 downto (2*j)-2) <= pt(((r*6*j)-(6*(r-i)))-5 downto ((r*6*j)-(6*(r-i)))-6);
		end generate if_sub1;
		
		if_sub2:if (j=c) generate
		amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-((r*6)-2) downto (((r*6*j)-(6*(r-i)))-2)-((r*6)-2)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								cd(1 downto 0),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
		p((2*j)-1 downto (2*j)-2) <= pt(((r*6*j)-(6*(r-i)))-5 downto ((r*6*j)-(6*(r-i)))-6);
		p((2*j)+1 downto (2*j)) <= pt(((r*6*j)-(6*(r-i)))-3 downto ((r*6*j)-(6*(r-i)))-4);
		end generate if_sub2;
		
	end generate if_typeII;

----------------End of Type II-------------------------------

----------------Type III--------------------------------------

	if_typeIII: if ((j>1)and (j<c) and (i=r)) generate
	
		amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-(r*6) downto (((r*6*j)-(6*(r-i)))-2)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
	
	end generate if_typeIII;

----------------End of Type III-------------------------------

----------------Type IV----------------------------------------
	
	if_typeIV: if((i>1) and (j=c)) generate
		
		if_subtype1: if ((i<r) and (j=c)) generate
			amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-((r*6)-2) downto (((r*6*j)-(6*(r-i)))-2)-((r*6)-2)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
			p(((2*j)+(4*(i-1)))-1 downto ((2*j)+(4*(i-1)))-2) <= pt(((r*6*j)-(6*(r-i)))-5 downto ((r*6*j)-(6*(r-i)))-6);
			p(((2*j)+(4*(i-1)))+1 downto ((2*j)+(4*(i-1)))) <= pt(((r*6*j)-(6*(r-i)))-3 downto ((r*6*j)-(6*(r-i)))-4);				   
		end generate if_subtype1;
		
		if_subtype2: if ((i=r) and (j=c)) generate
			amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-(r*6) downto (((r*6*j)-(6*(r-i)))-2)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
			p(((2*j)+(4*(i-1)))-1 downto ((2*j)+(4*(i-1)))-2) <= pt(((r*6*j)-(6*(r-i)))-5 downto ((r*6*j)-(6*(r-i)))-6);
			p(((2*j)+(4*(i-1)))+1 downto ((2*j)+(4*(i-1)))) <= pt(((r*6*j)-(6*(r-i)))-3 downto ((r*6*j)-(6*(r-i)))-4);
			p(((2*j)+(4*(i-1)))+3 downto ((2*j)+(4*(i-1)))+2) <= pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-2);				   
		end generate if_subtype2;
	end generate if_typeIV;

----------------End of Type IV---------------------------------

----------------Type V------------------------------------------

	if_typeV: if((i>1) and (i<r) and (j>1) and (j<c)) generate
	
		amm_l: amm_latch port map (clk,
								x(((4*i)-1) downto ((4*i)-4)),
								y((2*j)-1 downto (2*j)-2),
								pt((((r*6*j)-(6*(r-i)))-1)-((r*6)-2) downto (((r*6*j)-(6*(r-i)))-2)-((r*6)-2)),
								pt((((r*6*j)-(6*(r-i)))-3)-(r*6) downto (((r*6*j)-(6*(r-i)))-4)-(r*6)),
								pt((((r*6*j)-(6*(r-i)))-5)-2 downto (((r*6*j)-(6*(r-i)))-6)-2),
								pt(((r*6*j)-(6*(r-i)))-1 downto ((r*6*j)-(6*(r-i)))-6)
							   );
	
	end generate if_typeV;

----------------End of Type V-----------------------------------

					   
					   
end generate for_loop_2;

end generate for_loop_1;

end add_rtl;