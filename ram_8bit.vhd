library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_8bit is
port(

	clk		:	in		std_logic;
	
	rst		:	in		std_logic;
	we			:	in		std_logic;
	
	addr		:	in		std_logic_vector(15 downto 0);
	
	datain	:	in		std_logic_vector(7 downto 0);
	dataout	:	out	std_logic_vector(7 downto 0)
	);
end ram_8bit;

architecture behave of ram_8bit is
	
	type ram_type	is array (0 to 2**16-1) of std_logic_vector(7 downto 0);
	
	signal data		:		ram_type;

begin

	ram_main:	process(clk) is
	begin
	
		if (rising_edge(clk))
		then
			
			if (rst = '1') then
				data <= (others=> (others=>'0'));
			elsif (we = '1') then
				data(to_integer(unsigned(addr))) <= datain;
			end if;
			
		end if;
	end process ram_main;
	
	dataout <= data(to_integer(unsigned(addr)));

end architecture behave;