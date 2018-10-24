library ieee;
use ieee.std_logic_1164.all;

entity Decoder2N is
port (
		B0,B1: in std_logic;
		F0,F1,F2,F3: out std_logic
);

end entity;

architecture Decoder2N_arc of Decoder2N is
begin

F3 <= B1 AND B0;
F2 <= B1 AND NOT B0;
F1 <= NOT B1 AND B0;
F0 <= NOT B1 AND NOT B0;

end architecture;

