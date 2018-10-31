library ieee;
use ieee.std_logic_1164.all;

entity Alarm is
port(
	D,K,H: in std_logic;
	B: out std_logic
);
end entity;

architecture Alarm_arc of Alarm is
begin

B <= (K OR H) AND D;

end architecture;