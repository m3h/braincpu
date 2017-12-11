library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_16bit is
port(
	
	addr		:	in		std_logic_vector(11 downto 0);
	dataout	:	out	std_logic_vector(15 downto 0)
	);
end rom_16bit;

architecture behave of rom_16bit is
	
	type ram_type	is array (0 to 2**11-1) of std_logic_vector(15 downto 0);
	
	signal data		:		ram_type := (others => (others => '0'));
begin
	
	
	
	data(0) <= ("1001000000000000");
	data(1) <= ("1001000000000000");
	data(2) <= ("1001000000000000");
	data(3) <= ("1001000000000000");
	data(4) <= ("1100000000000000");
	data(5) <= ("0000000000000000");
	data(6) <= ("0001000000000000");

	dataout <= data(to_integer(unsigned(addr)));

end architecture behave;