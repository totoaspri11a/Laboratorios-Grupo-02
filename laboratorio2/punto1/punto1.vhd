library ieee;
use ieee.std_logic_1164.all;

entity punto1 is
port(
 D, K, H: in std_logic;
 B: out std_logic
 );
end entity;

architecture punto1_arc of punto1 is
 begin
 B <= (K OR H) AND D;
 
end architecture;
