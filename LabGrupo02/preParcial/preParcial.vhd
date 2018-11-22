library ieee;

use ieee.std_logic_1164.all;

entity preParcial is

port(
	clk,sensor,pin_t: in std_logic;
	Major,Minor,pin_tf: out std_logic
);

end entity;

architecture preParcial_arc of PreParcial is
type Def_States is (red,green);
signal current_state, next_state: Def_States;
begin
	process(current_state) is
	begin
		case current_state is
			when green =>
				if(sensor = '0')then
					pin_tf <= '0';
					Major <= '1';
					Minor <= '0';
					next_state <= red;
				else
					pin_tf <= '0';
					Major <= '0';
					Minor <= '1';
					next_state <= green;
				end if;
			when red =>
				if(sensor = '1')then
					Major <= '0';
					Minor <= '1';
					pin_tf <= '0';
					next_state <= green;
				else
					pin_tf <= '1';
					Major <= '1';
					Minor <= '0';
					next_state <= red;
				end if;
		end case;
	end process;
	
	process(next_state) is
	begin
		if(Rising_edge(clk))then 
			current_state <= next_state;
		end if;
	end process;
end architecture;