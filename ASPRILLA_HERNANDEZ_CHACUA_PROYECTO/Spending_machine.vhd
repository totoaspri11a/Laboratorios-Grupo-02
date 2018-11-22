-- Quartus II VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Spending_machine is
	generic
	(
		DATA_WIDTH: natural := 4;
		PRIZE_WIDTH: natural := 5;
		ADDR_WIDTH: natural := 4;
		DIVISOR: natural := 50000000
		--DIVISOR: natural := 1
	);

	port
	(
		clk, reset, Enable, Lock, Button1, Button2, Button3,Button4: in	std_logic; 
		Product: in std_logic_vector(ADDR_WIDTH-1 downto 0); --Dirección
		LedDev: out unsigned(PriZE_WIDTH downto 0):= "000000"; --Leds para indicar la devuelta
		Num, Num2, Num3, Num4: out std_logic_vector(6 downto 0):="0000000" --Led 7 segmentos
	);

end entity;

architecture Spending_machine_arc of Spending_machine is
Component RAM is
	generic 
	(
		DATA_WIDTH : natural := 4;
		ADDR_WIDTH : natural := 4
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**(ADDR_WIDTH - 1);
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		Amount: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;

--Se carga la ROM
Component ROM is
generic 
	(
		DATA_WIDTH : natural := 5;
		ADDR_WIDTH : natural := 4
	);

	port 
	(
		clk	: in std_logic;
		addr	: in natural range 0 to 2**(ADDR_WIDTH - 1);
		Prize : out unsigned((DATA_WIDTH -1) downto 0)
	);
end component;

--Se carga el Cash counter
Component Cash_counter is
generic(
	DATA_PRIZE: natural := 5
);
port(
	clk: in std_logic;
	MoneyIn: in std_logic_vector(1 downto 0);
	Prize: in unsigned(DATA_PRIZE-1 downto 0); --El precio del producto seleccionado
	Y,Dcash: out std_logic; --Y = 1 -> Dinero correcto, N = 0-> Dinero incorrecto
	LedDev: out unsigned(5 downto 0)
	);
end component;


	-- Build an enumerated type for the state machine
	type state_type is (Init, Verification, Spending);

	-- Register to hold the current state
	signal state : state_type;

signal address: integer;

signal cant,Newcant: std_logic_vector(DATA_WIDTH-1 downto 0):="0000";

signal prize:unsigned(PRIZE_WIDTH-1 downto 0);

signal Devuelta: std_logic;

signal Y:std_logic;

signal NewValue: std_logic_vector(DATA_WIDTH-1 downto 0);

signal Coin:std_logic_vector(1 downto 0);

signal clkout: std_logic;

begin
	address <= to_integer(unsigned(Product));
	s1: RAM
		port map(
			clk => clk,
			addr => address,
			data => NewValue,
			we => '1',
			Amount => cant);
			
	s2: ROM
		port map(
			clk => clk,
			addr => address,
			Prize => prize);
	
	s3: Cash_counter
		port map(
			clk => clk,
			MoneyIn => Coin,
			Prize => prize,
			Y => Y,
			Dcash => Devuelta,
			LedDev => LedDev);

	process (clk, reset)
	begin

		if (reset = '1') then
			state <= Init;

		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when Init=>
					if (Enable = '1' and Lock = '1') then
						state <= Verification;
					else
						state <= Init;
					end if;
				when Verification=>
					if (Lock = '1') then
						state <= Spending;
					else
						state <= Init;
					end if;
				when Spending=>
					if (Y = '1') then
						state <= Init;
					else
						state <= Spending;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state,Enable,Lock)
	begin
			case state is
				when Init=>
					if (Enable = '1' and Lock = '0') then
						if(Product = "0000")then
							Num <="0001000"; --A
							Num2 <="1111001"; -- 1
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0001")then
							Num <="0001000"; --A
							Num2 <="0100100"; -- 2
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0010")then
							Num <="0001000"; --A
							Num2 <="0110000"; -- 3
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0011")then
							Num <="0001000"; --A
							Num2 <="0011001"; -- 4
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0100")then
							Num <="0000011"; --B
							Num2 <="1111001"; -- 1
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0101")then
							Num <="0000011"; --B
							Num2 <="0100100"; -- 2
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0110")then
							Num <="0000011"; --B
							Num2 <="0110000"; -- 3
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "0111")then
							Num <="0000011"; --B
							Num2 <="0011001"; -- 4
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1000")then
							Num <="1000110"; -- C
							Num2 <="1111001"; -- 1
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1001")then
							Num <="1000110"; -- C
							Num2 <="0100100"; -- 2
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1010")then
							Num <="1000110"; -- C
							Num2 <="0110000"; -- 3
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1011")then
							Num <="1000110"; -- C
							Num2 <="0011001"; -- 4
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1100")then
							Num <="0100001"; -- D
							Num2 <="1111001"; -- 1
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1101")then
							Num <="0100001"; -- D
							Num2 <="0100100"; -- 2
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1110")then
							Num <="0100001"; -- D
							Num2 <="0110000"; -- 3
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						elsif(Product = "1111")then
							Num <="0100001"; -- D
							Num2 <="0011001"; -- 4
							Num3 <="1111111"; -- Espacio
							Num4 <="1111111"; -- Espacio
						else
							Num <= "0010010"; -- S
							Num2 <="0000100";	-- E
							Num3 <="1000111";	-- L
							Num4 <="1000110"; -- C
						end if;
					else
						Num <= "0010010"; -- S
						Num2 <="0000100";	-- E
						Num3 <="1000111";	-- L
						Num4 <="1000110"; -- C
						if(Enable = '1' and Lock = '1' )then
							Num <="1111111"; -- Reinicio en blanco
							Num2 <="1111111"; 
							Num3 <="1111111"; 
							Num4 <="1111111";
						end if;
					end if;
				when Verification=>
					if (cant > "0000") then
						Num <="0010010"; -- S
						Num2 <="1111001"; -- I
						Num3 <="1111111"; -- Espacio
						Num4 <="0001100"; --P
						NewValue <= cant - "0001";
					elsif(cant = "0000")then
						Num <="0101011"; -- N 
						Num2 <="1000000"; -- O
						Num3 <="1111111"; -- Espacio
						Num4 <="0001100"; --P
					else
						Num <="0101011"; -- N  No buying
						Num2 <="1000000"; -- O
						Num3 <="1111111"; -- Espacio
						Num4 <= "0000011"; -- B
					end if;
				when Spending=>
						if(Y = '1' and Devuelta = '1')then
							Num <="0010010"; -- S
							Num2 <="1111001"; -- I
							Num3 <="1111111"; -- Espacio
							Num4 <="0001100"; --P
						elsif( Y= '1' and Devuelta = '0')then
							Num <="0010010"; -- S
							Num2 <="1111001"; -- I
							Num3 <="1111111"; -- Espacio
							Num4 <="0001100"; --P
						else
							Num <="1111111"; -- N  No buying
							Num2 <="1111111"; -- O
							Num3 <="1111111"; -- Espacio
							Num4 <= "1111111"; -- B
						end if;
			end case;
	end process;
	
	process(Button1,Button2,Button3,Button4)
	begin
		if (Enable = '1' and Lock = '1') then
			if(Button1='0')then
				Coin <= "00";
			elsif(Button2='0')then
				Coin <= "01";
			elsif(Button3='0')then
				Coin <= "10";
			elsif(Button4='0')then
				Coin <= "11";
			else
				Coin <= "00";
			end if;
		end if;
end process;
end architecture;
