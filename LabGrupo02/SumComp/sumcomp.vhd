library ieee;
use ieee.std_logic_1164.all;

entity sumcomp is
port ( A: in std_logic_vector(2 DOWNTO 0); --In of 3 bits
		 B: in std_logic_vector(2 DOWNTO 0); --In of 3 bits
		 c0: inout std_logic; --First Carry
		 c1: inout std_logic;
		 c2: inout std_logic;
		 c3: inout std_logic;
		 Sum: out std_logic_vector(3 DOWNTO 0); --Out of 4 bits
		 Comp: out std_logic); --Comp A > B
end entity;

architecture sumcomp_arc of sumcomp is
begin
--Sum A + B
c0 <= '0';
Sum(0) <= A(0) XOR B(0) XOR c0;
c1 <= (A(0) AND B(0)) OR (c0 AND (A(0) XOR B(0)));

Sum(1) <= A(1) XOR B(1) XOR c1;
c2 <= (A(1) AND B(1)) OR (c1 AND (A(1) XOR B(1)));

Sum(2) <= A(2) XOR B(2) XOR c2;
c3 <= (A(2) AND B(2)) OR (c2 AND (A(2) XOR B(2)));
Sum(3) <= c3;

--Comp A>B
Comp <= (A(0) AND (NOT B(0))) OR (A(1) AND (NOT B(1))) OR (A(2) AND (NOT B(2)));
-- Comp A=B
--Comp <= (A(0)XNOR B(0))AND(A(1)XNOR B(1))AND(A(2)XNOR B(2));
--Comp A<B
--Comp <= ((NOT A(0)) AND B(0)) OR ((NOT A(1) AND B(1)) OR ((NOT A(2) AND B(2));
end architecture;