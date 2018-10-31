library ieee;
use ieee.std_logic_1164.all;

entity Corrimiento is

port(
	Shift: in std_logic;
	w: in std_logic_vector(3 downto 0);
	k: out std_logic;
	y: out std_logic_vector(3 downto 0)
);

end entity;

architecture Corrimiento_arc of Corrimiento is
begin
	process(w)is
		begin
			if(Shift = '1')then
				y(2 downto 0) <= w(3 downto 1);
				k<= w(0);
				y(3)<= '0';
			else
				y(3 downto 0)<= w(3 downto 0);
				k <= '0';
			end if;
	end process;
end architecture;