library ieee; 
use ieee.std_logic_1164.all; 
entity adder8 is 
 port(A,B: in std_logic_vector(7 downto 0); 
  Cin: in std_logic; 
  S: out std_logic_vector(7 downto 0); 
  Co: out std_logic); 
end adder8; 
 
architecture struct of adder8 is 
 component FullAdder 
  port(X, Y, Cin: in std_logic; 
   Cout, Sum : out std_logic); 
 end component; 
 signal C: std_logic_vector(7 downto 0); 
begin 
   FA0: FullAdder port map(A(0), B(0), Cin, C(0), S(0)); 
   FA1: FullAdder port map(A(1), B(1), C(0), C(1), S(1)); 
   FA2: FullAdder port map(A(2), B(2), C(1), C(2), S(2)); 
   FA3: FullAdder port map(A(3), B(3), C(2), C(3), S(3)); 
   FA4: FullAdder port map(A(4), B(4), C(3), C(4), S(4)); 
   FA5: FullAdder port map(A(5), B(5), C(4), C(5), S(5)); 
   FA6: FullAdder port map(A(6), B(6), C(5), C(6), S(6)); 
   FA7: FullAdder port map(A(7), B(7), C(6), Co, S(7));  
end struct; 
