library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity braincpu is
port(
	clk			:	in			std_logic;
	
	u_in_4bit	:	in			std_logic_vector(3 downto 0);
	u_in_btn_a_inv	:	in			std_logic;
	
	u_in_btn_rst_inv:	in			std_logic;
	u_out_8bit	:	out		std_logic_vector(7 downto 0) );
end braincpu;

architecture behave of braincpu is

	component Osc_1 is
	port (
    clk_50Mhz : in  std_logic;
    rst       : in  std_logic;
	 led_clk   : out std_logic;
    clk_2Hz   : out std_logic);
	end component;

	signal u_in_btn_a, u_in_btn_rst : std_LOGIC;
	component ram_8bit
	port(

		clk		:	in			std_logic;
		
		rst		:	in			std_logic;
		we			:	in			std_logic;
		
		addr		:	in			std_logic_vector(15 downto 0);
		
		datain	:	in			std_logic_vector(7 downto 0);
		dataout	:	out		std_logic_vector(7 downto 0)
	);
	end component;
	
	component rom_16bit
	port(
	
	addr		:	in		std_logic_vector(11 downto 0);
	dataout	:	out	std_logic_vector(15 downto 0)
	);
	end component;

	signal	ram_rst		:	std_logic;
	signal	ram_we		:	std_logic;
	
	signal	ram_addr		:	std_logic_vector(15 downto 0);
	
	signal	ram_datain	:	std_logic_vector(7 downto 0);
	signal	ram_dataout	:	std_logic_vector(7 downto 0);

	signal	ram_dataoutdec, ram_dataoutinc :	std_logic_vector(7 downto 0);
	
	signal	rom_addr		:	std_logic_vector(11 downto 0);
	signal	rom_dataout	:	std_logic_vector(15 downto 0);
	
	shared variable C_var			:	std_logic_vector(15 downto 0);
	signal	C, WA			:	std_logic_vector(15 downto 0) := (others => '0');
	signal	PC, NPC		:	std_logic_vector(11 downto 0) := (others => '0');
	
	signal	wag, wagon	:	std_logic := '0';
	
	constant LB: std_logic_vector(3 downto 0) := "0000";
	constant RB: std_logic_vector(3 downto 0) := "0001";
	constant AD: std_logic_vector(3 downto 0) := "0100";
	constant AI: std_logic_vector(3 downto 0) := "0101";
	constant VD: std_logic_vector(3 downto 0) := "1000";
	constant VI: std_logic_vector(3 downto 0) := "1001";
	constant DD: std_logic_vector(3 downto 0) := "1100";
	constant GD: std_logic_vector(3 downto 0) := "1101";
	
	signal rom_op	:	std_logic_vector(3 downto 0);
	
	signal col1, col2	:	std_logic_vector(3 downto 0);
	signal col1done	:	std_logic;
	
	signal clk_2hz, cc	:	std_logic;
	signal u_out_8bit_sig	:	std_logic_vector(7 downto 0);
begin

	u_in_btn_rst <= not u_in_btn_rst_inv;
	u_in_btn_a	 <= not u_in_btn_a_inv;
	
--	red:			Osc_1		port map ( clk_50Mhz => clk,
--												rst       => '0',
--												led_clk   => cc,
--												clk_2Hz   => clk_2hz );
	clk_2hz <= clk;
	
	main_ram:	ram_8bit port map (	clk 		=> clk_2hz,
												rst		=> ram_rst,
												we			=> ram_we,
												addr		=> ram_addr,
												datain	=> ram_datain,
												dataout	=> ram_dataout);

	main_rom:	rom_16bit port map (
	addr		=> rom_addr,
												dataout	=>	rom_dataout);
												
	rom_op <= rom_dataout(15 downto 12);
	
	cpu_proc: process(clk_2hz, wag)
	begin
	
		if (rising_edge(clk_2hz) and wag = '0') then
		
			if (u_in_btn_rst = '1')
			then
				WA <= (others => '0');
				ram_rst <= '1';
			else
				ram_rst <= '0';
				
				rom_addr <= PC;
				
				case (rom_op) is
					when AD =>
						C_var := std_logic_vector(unsigned(C)+1);
						
					when AI =>
						C_var := std_logic_vector(unsigned(C)+1);
						
					when LB =>
						-- Do nothing;
					
					when RB =>
						NPC <= rom_dataout(11 downto 0);
						
					when VD =>
						ram_datain <= ram_dataoutdec;
						ram_we <= '1';
						
					when VI =>
						ram_datain <= ram_dataoutinc;
						ram_we <= '1';
					
					when DD =>
						u_out_8bit_sig(3 downto 0) <= ram_dataout (3 downto 0);
						wagon <= '1';
					
					when GD =>
						
						if (col1done = '0')
						then
							col1 <= u_in_4bit;
							wagon <= '1';
							col1done <= '1';
						else
							col2 <= u_in_4bit;
							col1done <= '0';
							
							ram_datain <= col1 & col2;
							ram_we <= '1';
							
						end if;
					
					when others =>
						-- Do nothing
				end case;
						
				ram_we <= '0';
				wagon <= '0';
					
			end if;
			
			
		end if;
	end process cpu_proc;

	ram_dataoutinc <= std_logic_vector(unsigned(ram_dataout)+1);
	ram_dataoutdec <= std_logic_vector(unsigned(ram_dataout)-1);
	ram_addr <= C;
	process(u_in_btn_a, wagon)
	begin
	
		if (wagon = '1')
		then
			wag <= '1';
			
		elsif (rising_edge(u_in_btn_a))
		then
			wag <= '0';
		end if;
	end process;
	
	process(clk_2hz, NPC)
	begin
		
		if (rising_edge(clk_2hz))
		then
		
			C <= C_var;
			PC <= NPC;
		end if;
	end process;
	
	
	u_out_8bit_sig(7 downto 4) <= "1111";
	u_out_8bit <= u_out_8bit_sig;
end behave;